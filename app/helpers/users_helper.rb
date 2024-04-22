module UsersHelper
  def avatar_image(user, size = '300x300')
    if user.avatar_new.attached?
      url_for(user.avatar_new.variant(resize: size))
    else
      size == '300x300' ? '/assets/users/missing_medium.png' : '/assets/users/missing_thumb.png'
    end
  end
end
