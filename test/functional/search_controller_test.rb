require "test_helper"

class SearchControllerTest < ActionDispatch::IntegrationTest
  test "search form renders before a search" do
    get search_path

    assert_response :success
    assert_includes response.body, "Ready to Search"
  end

  test "name search returns matching coaches in the current city" do
    post search_path, params: {
      commit: "Search",
      name: "alice",
      day: "",
      start_hour: ""
    }

    assert_response :success
    assert_includes response.body, users(:coach).name
    assert_not_includes response.body, users(:chicago_coach).name
  end

  test "schedule search requires every half-hour block in the requested span" do
    post search_path, params: {
      commit: "Search",
      day: "1",
      start_hour: "10",
      start_minute: "0",
      end_hour: "11",
      end_minute: "0"
    }

    assert_response :success
    assert_includes response.body, users(:coach).name

    post search_path, params: {
      commit: "Search",
      day: "1",
      start_hour: "10",
      start_minute: "0",
      end_hour: "11",
      end_minute: "30"
    }

    assert_response :success
    assert_includes response.body, "No Results Found"
  end
end
