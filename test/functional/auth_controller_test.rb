require "test_helper"

class AuthControllerTest < ActionDispatch::IntegrationTest
  test "login form renders" do
    get login_path

    assert_response :success
    assert_includes response.body, "Welcome Back"
    assert_select "form[action='/auth/facebook'][method='post']"
  end

  test "facebook request phase requires and accepts the Rails CSRF token" do
    previous_forgery_protection = ActionController::Base.allow_forgery_protection
    ActionController::Base.allow_forgery_protection = true

    begin
      get login_path
      token = css_select("form[action='/auth/facebook'] input[name='authenticity_token']").first['value']

      post "/auth/facebook"
      assert_response :redirect
      assert_includes response.location, "/auth/failure"

      post "/auth/facebook", params: { authenticity_token: token }
      assert_response :redirect
      assert_includes response.location, "facebook.com"
    ensure
      ActionController::Base.allow_forgery_protection = previous_forgery_protection
    end
  end

  test "valid credentials authenticate and return the user to their destination" do
    get profile_edit_path
    assert_redirected_to root_path

    post login_path, params: {
      email: users(:coach).email.upcase,
      password: "secret"
    }

    assert_redirected_to profile_edit_url

    follow_redirect!
    assert_response :success
  end

  test "invalid or missing credentials return to login without raising" do
    post login_path, params: { email: users(:coach).email, password: "wrong" }
    assert_redirected_to login_path
    assert_equal "Hmm, that email and password appear to be invalid.", flash[:notice]

    post login_path, params: { password: "secret" }
    assert_redirected_to login_path
  end

  test "logout clears authentication" do
    sign_in_as users(:coach)

    delete logout_path
    assert_redirected_to login_path

    get profile_edit_path
    assert_redirected_to root_path
  end

end

class AuthLinkControllerTest < ActionController::TestCase
  tests AuthController

  setup do
    @request.host = "www.improvcoaches.com"
    @request.session[:omniauth] = {
      provider: "facebook",
      uid: "facebook-123",
      info: { email: users(:member).email, name: users(:member).name },
      credentials: { token: "oauth-token", expires_at: 1.day.from_now.to_i }
    }
  end

  test "linking an oauth identity requires the existing account password" do
    post :confirm_link, params: { password: "wrong" }
    assert_redirected_to link_path
    assert_nil users(:member).reload.provider

    post :confirm_link, params: { password: "secret" }
    assert_redirected_to root_path
    assert_equal "facebook", users(:member).reload.provider
    assert_equal "facebook-123", users(:member).uid
  end

  test "facebook callback without account data fails safely" do
    get :create, params: { from_facebook: true }

    assert_redirected_to login_path
    assert_match(/did not provide/, flash[:alert])
  end

  test "facebook signup builds a valid password and Active Storage avatar" do
    auth = OmniAuth::AuthHash.new(
      provider: "facebook",
      uid: "new-facebook-user",
      info: { email: "facebook.user@example.com", name: "Facebook User" },
      credentials: { token: "oauth-token", expires_at: 1.day.from_now.to_i }
    )
    avatar_io = StringIO.new("fake-image-data")
    avatar_io.define_singleton_method(:content_type) { "image/jpeg" }
    user = User.new
    @controller.define_singleton_method(:fetch_facebook_avatar) { |_uid| avatar_io }

    @controller.send(:setup_new_user, user, auth)

    assert user.save
    assert user.authenticate(user.password)
    assert user.avatar.attached?
    assert_equal "facebook-avatar-new-facebook-user.jpg", user.avatar.filename.to_s
  end

  test "facebook signup remains available when the avatar download fails" do
    auth = OmniAuth::AuthHash.new(
      provider: "facebook",
      uid: "facebook-user-without-avatar",
      info: { email: "no.avatar@example.com", name: "No Avatar" },
      credentials: { token: "oauth-token" }
    )
    @controller.define_singleton_method(:fetch_facebook_avatar) { |_uid| raise SocketError, "unavailable" }
    user = User.new

    @controller.send(:setup_new_user, user, auth)

    assert user.save
    assert_not user.avatar.attached?
    assert user.password_digest.start_with?("$2")
  end
end
