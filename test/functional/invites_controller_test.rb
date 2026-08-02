require "test_helper"

class InvitesControllerTest < ActionDispatch::IntegrationTest
  setup do
    ActionMailer::Base.deliveries.clear
  end

  test "pending invitation landing page renders registration choices" do
    get invite_landing_path(invites(:pending))

    assert_response :success
    assert_includes response.body, invites(:pending).owner.name
  end

  test "missing and used invitation codes redirect safely" do
    get invite_landing_path(code: "missing")
    assert_redirected_to root_url

    get invite_landing_path(invites(:used))
    assert_redirected_to root_url
  end

  test "accepting a pending invite upgrades the signed-in member" do
    sign_in_as users(:member)

    post invite_accept_path(invites(:pending))

    assert_redirected_to profile_edit_url
    assert_equal "used", invites(:pending).reload.status
    assert users(:member).reload.is_coach?
    assert users(:member).is_improv?
    assert_equal invites(:pending).owner.city, users(:member).city
  end

  test "accepting an invite requires login" do
    post invite_accept_path(invites(:pending))

    assert_redirected_to root_path
    assert_equal "Please log in to access that page.", flash[:alert]
  end

  test "owner can resend and cancel an invitation" do
    sign_in_as users(:coach)

    assert_emails 1 do
      post profile_invite_resend_path(invites(:pending)), as: :turbo_stream
    end
    assert_response :success

    delete profile_invite_cancel_path(invites(:pending)), as: :turbo_stream
    assert_response :success
    assert_equal "free", invites(:pending).reload.status
    assert_nil invites(:pending).recipient
  end

  test "another member cannot manage invitations they do not own" do
    sign_in_as users(:member)

    post profile_invite_resend_path(invites(:pending)), as: :turbo_stream
    assert_response :not_found

    delete profile_invite_cancel_path(invites(:pending)), as: :turbo_stream
    assert_response :not_found
    assert_equal "pending", invites(:pending).reload.status
  end
end
