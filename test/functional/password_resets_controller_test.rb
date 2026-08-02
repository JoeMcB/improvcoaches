require "test_helper"

class PasswordResetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    ActionMailer::Base.deliveries.clear
  end

  test "new form renders and legacy index redirects to it" do
    get new_password_reset_path
    assert_response :success

    get password_resets_path
    assert_redirected_to new_password_reset_path
  end

  test "requesting a reset stores a token and sends mail" do
    assert_emails 1 do
      post password_resets_path, params: { email: users(:member).email.upcase }
    end

    user = users(:member).reload
    assert user.password_reset_token.present?
    assert_in_delta Time.current, user.password_reset_time, 2.seconds
    assert_redirected_to root_url
  end

  test "unknown email gets the same response without sending mail" do
    assert_no_emails do
      post password_resets_path, params: { email: "unknown@example.com" }
    end

    assert_redirected_to root_url
  end

  test "valid reset token renders the password form" do
    users(:member).update!(password_reset_token: "valid-token", password_reset_time: Time.current)

    get edit_password_reset_path("valid-token")

    assert_response :success
    assert_select "form[action=?]", password_reset_path("valid-token")
  end

  test "invalid reset token redirects to a new request" do
    get edit_password_reset_path("missing-token")

    assert_redirected_to new_password_reset_path
    assert_match(/invalid or has expired/, flash[:alert])
  end

  test "fresh reset token changes the password" do
    user = users(:member)
    user.update!(password_reset_token: "fresh-token", password_reset_time: Time.current)

    patch password_reset_path("fresh-token"), params: {
      user: { password: "changed-secret", password_confirmation: "changed-secret" }
    }

    assert_redirected_to login_path
    assert user.reload.authenticate("changed-secret")
    assert_nil user.password_reset_token
    assert_nil user.password_reset_time

    patch password_reset_path("fresh-token"), params: {
      user: { password: "reused-secret", password_confirmation: "reused-secret" }
    }
    assert_redirected_to new_password_reset_path
    assert_not user.reload.authenticate("reused-secret")
  end

  test "expired token does not change the password" do
    user = users(:member)
    user.update!(password_reset_token: "expired-token", password_reset_time: 3.hours.ago)

    patch password_reset_path("expired-token"), params: {
      user: { password: "changed-secret", password_confirmation: "changed-secret" }
    }

    assert_redirected_to new_password_reset_path
    assert user.reload.authenticate("secret")
  end

  test "expired token does not render the password form" do
    users(:member).update!(password_reset_token: "expired-form-token", password_reset_time: 3.hours.ago)

    get edit_password_reset_path("expired-form-token")

    assert_redirected_to new_password_reset_path
  end

  test "password confirmation mismatch rerenders with validation errors" do
    users(:member).update!(password_reset_token: "mismatch-token", password_reset_time: Time.current)

    patch password_reset_path("mismatch-token"), params: {
      user: { password: "changed-secret", password_confirmation: "different" }
    }

    assert_response :unprocessable_entity
    assert_includes response.body, "Password confirmation"
  end
end
