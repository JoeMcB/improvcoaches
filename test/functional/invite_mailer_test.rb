require "test_helper"

class InviteMailerTest < ActionMailer::TestCase
  test "invitation identifies the owner recipient and acceptance link" do
    invite = invites(:pending)
    mail = InviteMailer.send_invitation(invite)

    assert_equal "Your ImprovCoaches.com Coaching Invite", mail.subject
    assert_equal [invite.recipient], mail.to
    assert_equal ["support@improvcoaches.com"], mail.from
    assert_includes mail.body.encoded, invite.owner.name
    assert_includes mail.body.encoded, "/invite/#{invite.code}"
  end
end
