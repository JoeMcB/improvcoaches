class UserMailer < ActionMailer::Base
  default from: "support@improvcoaches.com"

  def password_reset(user)
  	@user = user
  	mail to: user.email, subject: "Reset your ImprovCoaches.com password."
  end

  def coach_contact(from, to, body)
  	@user_from = from
  	@user_to = to
  	@body = body

  	mail to: to.email,
  		 subject: "An email from #{from.name} from ImprovCoaches.com",
  		 reply_to: from.email,
       from: "gigs@improvcoaches.com"
  end

  def comment_notification(user, sender, content)
    @to_user = user
    @sender = sender
    @content = content

    mail to: @to_user.email,
        subject: "You've recieved a new comment on ImprovCoaches.com"
  end
end
