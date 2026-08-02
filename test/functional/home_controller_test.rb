require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "public information pages render" do
    {
      root_path => "Welcome to",
      about_path => "About ImprovCoaches.com",
      become_a_coach_path => "Become a Coach",
      resources_path => "Books"
    }.each do |path, content|
      get path

      assert_response :success
      assert_includes response.body, content
    end
  end

  test "splash page renders without the application layout" do
    get splash_path

    assert_response :success
    assert_not_includes response.body, "application.tailwind"
  end
end
