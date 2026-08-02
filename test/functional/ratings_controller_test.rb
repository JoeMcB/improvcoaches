require "test_helper"

class RatingsControllerTest < ActionDispatch::IntegrationTest
  test "rating actions require login" do
    post user_like_path(users(:coach)), as: :turbo_stream

    assert_response :success
    assert_includes response.body, "Please log in"
  end
end
