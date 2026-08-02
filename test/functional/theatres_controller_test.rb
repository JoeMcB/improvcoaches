require "test_helper"

class TheatresControllerTest < ActionDispatch::IntegrationTest
  test "theatre management requires an administrator" do
    get theatres_path

    assert_redirected_to root_path
  end

  test "administrator can list create update and destroy theatres" do
    sign_in_as users(:admin)

    get theatres_path
    assert_response :success
    assert_includes response.body, theatres(:ucb).name

    assert_difference "Theatre.count", 1 do
      post theatres_path, params: {
        theatre: { name: "Magnet Theater", city_ids: [cities(:new_york).id] }
      }
    end

    theatre = Theatre.find_by!(name: "Magnet Theater")
    assert_redirected_to theatre_path(theatre)
    assert_equal [cities(:new_york)], theatre.cities.to_a

    patch theatre_path(theatre), params: {
      theatre: { name: "Magnet Training Center", city_ids: [cities(:new_york).id] }
    }
    assert_redirected_to theatre_path(theatre)
    assert_equal "Magnet Training Center", theatre.reload.name

    assert_difference "Theatre.count", -1 do
      delete theatre_path(theatre)
    end
    assert_redirected_to theatres_url
  end
end
