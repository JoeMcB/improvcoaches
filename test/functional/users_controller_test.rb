require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "coach index is scoped to the current city" do
    get users_path

    assert_response :success
    assert_includes response.body, users(:coach).name
    assert_not_includes response.body, users(:chicago_coach).name
    assert_not_includes response.body, users(:member).name
  end

  test "registration form renders" do
    get join_path

    assert_response :success
    assert_select "form[action=?]", users_path
  end

  test "registration creates a user and their schedule" do
    assert_difference(["User.count", "Schedule.count"], 1) do
      post users_path, params: {
        user: {
          name: "New Coach",
          email: "NEW.COACH@EXAMPLE.COM",
          password: "new-secret",
          password_confirmation: "new-secret",
          bio: "New here"
        }
      }
    end

    created_user = User.find_by!(email: "new.coach@example.com")
    assert_equal cities(:new_york), created_user.city
    assert created_user.authenticate("new-secret")
    assert_redirected_to root_url
  end

  test "invalid registration explains the validation errors" do
    assert_no_difference "User.count" do
      post users_path, params: {
        user: { name: "", email: "not-an-email", password: "secret" }
      }
    end

    assert_response :unprocessable_entity
    assert_includes response.body, "prohibited this user from being saved"
  end

  test "coach profiles use friendly ids" do
    get user_path(users(:coach))

    assert_response :success
    assert_includes response.body, users(:coach).bio

    get "/coaches/#{users(:coach).id}"
    assert_response :moved_permanently
    assert_redirected_to user_path(users(:coach))
  end

  test "non-coach records are not exposed as coach profiles" do
    get user_path(users(:member))

    assert_redirected_to users_url
  end

  test "profile pages require login" do
    get profile_edit_path

    assert_redirected_to root_path
    assert_equal "Please log in to access that page.", flash[:alert]
  end

  test "facebook comment notifications require login" do
    post user_comment_path(users(:coach)), params: { comment_id: "comment", access_token: "token" }

    assert_response :success
    assert_includes response.body, "Please log in to access that page."
  end

  test "an authenticated coach can view their profile route" do
    sign_in_as users(:coach)

    get profile_path

    assert_response :success
    assert_includes response.body, users(:coach).name
  end

  test "profile update changes only permitted fields on the current user" do
    sign_in_as users(:coach)

    post profile_update_path,
         params: { user: { bio: "Updated biography", is_admin: 1, name: "Hacked" } },
         headers: { "HTTP_REFERER" => profile_edit_url }

    assert_redirected_to profile_edit_url
    assert_equal "Updated biography", users(:coach).reload.bio
    assert_equal "Alice Coach", users(:coach).name
    assert_not users(:coach).is_admin?
  end

  test "account deletion deletes the signed-in user rather than a route id" do
    sign_in_as users(:member)

    assert_difference "User.count", -1 do
      delete profile_destroy_path
    end

    assert_redirected_to users_url
    assert_not User.exists?(users(:member).id)
  end

  test "oauth unlink is a protected state-changing request" do
    user = users(:member)
    user.update!(provider: "facebook", uid: "123", oauth_token: "token")
    sign_in_as user

    assert_emails 1 do
      delete profile_unlink_path
    end

    assert_redirected_to profile_edit_path
    assert_nil user.reload.provider
    assert user.password_reset_token.present?
  end
end
