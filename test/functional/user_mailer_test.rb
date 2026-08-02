require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "password reset includes the user's tokenized link" do
    user = users(:member)
    user.update!(password_reset_token: "mailer-token")

    mail = UserMailer.password_reset(user)

    assert_equal "Reset your ImprovCoaches.com password.", mail.subject
    assert_equal [user.email], mail.to
    assert_includes mail.body.encoded, "/password_resets/mailer-token/edit"
  end

  test "coach contact comes from the gigs address and replies to the sender" do
    sender = users(:member)
    recipient = users(:coach)
    mail = UserMailer.coach_contact(sender, recipient, "Are you available Tuesday?")

    assert_equal [recipient.email], mail.to
    assert_equal ["gigs@improvcoaches.com"], mail.from
    assert_equal [sender.email], mail.reply_to
    assert_includes mail.body.encoded, "Are you available Tuesday?"
  end

  test "comment notification includes sender and content" do
    mail = UserMailer.comment_notification(users(:coach), "Commenter", "Great workshop")

    assert_equal [users(:coach).email], mail.to
    assert_includes mail.body.encoded, "Commenter"
    assert_includes mail.body.encoded, "Great workshop"
  end
end
