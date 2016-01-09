class InviteMailer < ActionMailer::Base
  default from: "support@improvcoaches.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invite_mailer.inviation.subject
  #
  def send_invitation(invite)
    @invite = invite

    mail to: @invite.recipient, subject: "Your ImprovCoaches.com Coaching Invite"
  end
end
