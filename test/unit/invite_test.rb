require "test_helper"

class InviteTest < ActiveSupport::TestCase
  test "new invitations receive a unique code and free status" do
    invite = users(:coach).invites.create!

    assert_equal "free", invite.status
    assert_match(/\A[0-9a-f]{16}\z/, invite.code)
  end

  test "status is constrained to the invitation workflow" do
    invite = users(:coach).invites.build(status: "revoked")

    assert_not invite.valid?
    assert_includes invite.errors[:status], "is not included in the list"
  end

  test "scopes distinguish available sent and used invitations" do
    assert_includes Invite.free, invites(:free)
    assert_includes Invite.sent, invites(:pending)
    assert_includes Invite.sent, invites(:used)
    assert_not_includes Invite.sent, invites(:free)
  end

  test "to_param uses the invitation code" do
    assert_equal invites(:pending).code, invites(:pending).to_param
  end
end
