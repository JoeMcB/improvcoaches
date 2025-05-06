module UsersHelper
  def avatar_image(user, size = '300x300')
    if user.avatar.attached?
      width, height = size.split('x').map(&:to_i)
      url_for(user.avatar.variant(resize_to_fill: [width, height]))
    else
      size == '300x300' ? asset_path('users/missing_medium.png') : asset_path('users/missing_thumb.png')
    end
  end
end
