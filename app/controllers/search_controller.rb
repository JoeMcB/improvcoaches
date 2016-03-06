class SearchController < ApplicationController
  def search
    @searched = (params[:commit] == "Search" || params[:page]) #Did a search happen
    
    if(@searched)
        user_ids = Array.new

        if(params[:commit] == "Search") #Fresh Search
            
            if(params[:set] == "favorites")
                users = current_user.bookmarked_users.is_coach
            elsif(params[:set] == "recommended")
                users = current_user.recommended_users.where(is_coach: :t)
            elsif(params[:set] == "top")
                users = current_city.coaches.where( "user_id IN ( "+User.top(100).pluck(:id)+")")
            else
                users = current_city.coaches
            end

            #Name
            if(!params[:name].nil? && !params[:name].empty?)
                users = users.where( "users.name ILIKE ?", "%"+params[:name]+"%") #ILIKE is postgres case insenstive like
            end

            #Theatre
            if(!params[:theatre_id].nil? && !params[:theatre_id].empty?)
                users = users.joins(:theatres).where( "theatres.id = ?", params[:theatre_id])
            end


            #Experiences
            if(params[:experience_types])
                puts "lol"
                users = users.joins(:experiences).where( "experiences.experience_type_id IN (?)", params[:experience_types])
            end
            

            if(!users.empty?)
                filtered_user_ids = users.uniq.pluck("users.id")

                if(!params[:day].empty? || !params[:start_hour].empty?) #Schedule based search
                    time_block = { }
                    time_block[:day] = params[:day] unless params[:day].empty?

                    time_block[:hour] = params[:start_hour] unless params[:start_hour].empty?
                    time_block[:minute] = params[:start_minute] unless ( params[:start_minute].nil? || params[:start_minute].empty?)

                    schedules = Schedule.where( 
                        "user_id IN ('"+filtered_user_ids.join("', '")+"')"
                    ).joins(:time_blocks).where( time_blocks: time_block).group("schedules.id").each do |schedule|
                        
                        if(!time_block[:hour].nil?)
                            
                            if(schedule.has_time_span(
                                params[:start_hour] ? params[:start_hour].to_i : 0,
                                params[:start_minute] ? params[:start_minute].to_i : 0,
                                params[:end_hour] ? params[:end_hour].to_i : nil,
                                params[:end_minute] ? params[:end_minute].to_i : nil,
                                params[:day]
                            )) then
                              user_ids << schedule.user_id     
                            end
                        else
                            user_ids << schedule.user_id     
                        end

                    end     
                else
                    user_ids = users.collect do |u|
                        u.id
                    end
                end
                
               

                session[:last_search_user_ids] = user_ids
            end
        else
            user_ids = session[:last_search_user_ids] || Array.new
        end

        if(!user_ids.empty?)
            @users = User.where( id: user_ids )

            if(params[:sort_by] == "rating")
                @users = @users.order("users.rating DESC")
            else  #Sort by schedule update
                @users = @users.joins(:schedule).order("schedules.updated_at DESC")
            end
            
            @users = @users.paginate( per_page: 10, page: params[:page] )
        end
    end

  end
end
