class SearchController < ApplicationController
  # Search criteria persisted in the session so paginated pages can re-run the
  # search. We store the *criteria* (a few small strings), never the result IDs:
  # stuffing hundreds of user IDs into the cookie session blows past the ~4KB
  # cookie limit and raises ActionDispatch::Cookies::CookieOverflow.
  SEARCH_PARAM_KEYS = %w[set name theatre_id experience_types day start_hour start_minute end_hour end_minute].freeze

  def search
    @searched = (params[:commit] == "Search" || params[:page]) # Did a search happen

    if @searched
      if params[:commit] == "Search" # Fresh search: run it, remember the criteria
        session[:last_search_params] = params.to_unsafe_h.slice(*SEARCH_PARAM_KEYS)
        user_ids = search_user_ids(params)
      else # Paginated page: re-run the stored search instead of reading IDs out of the cookie
        stored = session[:last_search_params]
        user_ids = stored ? search_user_ids(stored) : Array(session[:last_search_user_ids])
      end

      if user_ids.any?
        @users = User.where(id: user_ids)

        if params[:sort_by] == "rating"
          @users = @users.order("users.rating DESC")
        else # Sort by schedule update
          @users = @users.joins(:schedule).order("schedules.updated_at DESC")
        end

        @users = @users.paginate(per_page: 10, page: params[:page])
      end
    end

    # Always render the search template
    respond_to do |format|
      format.html # renders search.html.erb
      format.turbo_stream # for Turbo Drive compatibility
    end
  end

  def index
    # Just render the index template
  end

  private

  # Runs the full search and returns the matching user IDs. Takes a plain hash
  # (or params) so it works with both the live request and the criteria we
  # stored in the session for paginated pages.
  def search_user_ids(p)
    p = p.is_a?(ActionController::Parameters) ? p.to_unsafe_h : p
    p = p.with_indifferent_access

    if p[:set] == "favorites"
      users = current_user.bookmarked_users.is_coach
    elsif p[:set] == "recommended"
      users = current_user.recommended_users.where(is_coach: :t)
    elsif p[:set] == "top"
      top_ids = User.coaches.order(rating: :desc).limit(100).pluck(:id)
      users = current_city.coaches.where(user_id: top_ids)
    else
      users = current_city.coaches
    end

    # Name
    if p[:name].present?
      users = users.where("users.name ILIKE ?", "%#{p[:name]}%") # ILIKE is postgres case insensitive like
    end

    # Theatre
    if p[:theatre_id].present?
      users = users.joins(:theatres).where("theatres.id = ?", p[:theatre_id])
    end

    # Experiences. The checkboxes are named experience_types[0], experience_types[1], ...
    # so this arrives as a Parameters *hash* (e.g. {"0" => "5", "1" => "12"}), not an
    # array. Passing it raw into `where("... IN (?)", ...)` makes ActiveRecord raise
    # `TypeError: can't quote ActionController::Parameters`, so normalize first.
    if p[:experience_types].present?
      experience_type_ids =
        case (raw = p[:experience_types])
        when ActionController::Parameters then raw.to_unsafe_h.values
        when Hash then raw.values
        when Array then raw
        else [raw.to_s]
        end
      users = users.joins(:experiences).where("experiences.experience_type_id IN (?)", experience_type_ids)
    end

    return [] if users.empty?

    filtered_user_ids = users.distinct.pluck("users.id")

    if p[:day].present? || p[:start_hour].present? # Schedule based search
      time_block = {}
      time_block[:day] = p[:day] if p[:day].present?
      time_block[:hour] = p[:start_hour] if p[:start_hour].present?
      time_block[:minute] = p[:start_minute] if p[:start_minute].present?

      user_ids = []
      Schedule.where(user_id: filtered_user_ids)
              .joins(:time_blocks)
              .where(time_blocks: time_block)
              .group("schedules.id")
              .each do |schedule|
        if time_block[:hour]
          if schedule.has_time_span(
               p[:start_hour] ? p[:start_hour].to_i : 0,
               p[:start_minute] ? p[:start_minute].to_i : 0,
               p[:end_hour] ? p[:end_hour].to_i : nil,
               p[:end_minute] ? p[:end_minute].to_i : nil,
               p[:day]
             )
            user_ids << schedule.user_id
          end
        else
          user_ids << schedule.user_id
        end
      end
      user_ids
    else
      users.distinct.pluck(:id)
    end
  end
end
