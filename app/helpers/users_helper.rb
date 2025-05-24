module UsersHelper
  def avatar_image(user, size = '300x300')
    if user.avatar.attached?
      # In development, skip image processing entirely to avoid VIPS/ImageMagick dependency
      if Rails.env.development?
        url_for(user.avatar)
      else
        # In production, always process the image
        width, height = size.split('x').map(&:to_i)
        url_for(user.avatar.variant(resize_to_fill: [width, height]))
      end
    else
      size == '300x300' ? asset_path('users/missing_medium.png') : asset_path('users/missing_thumb.png')
    end
  end
end
