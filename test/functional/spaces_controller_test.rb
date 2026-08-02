require "test_helper"

class SpacesControllerTest < ActionDispatch::IntegrationTest
  test "space index is public and scoped to the current city" do
    get spaces_path

    assert_response :success
    assert_includes response.body, spaces(:nyc_studio).name
    assert_not_includes response.body, spaces(:chicago_studio).name
  end

  test "space pages use friendly ids" do
    get space_path(spaces(:nyc_studio))

    assert_response :success
    assert_includes response.body, spaces(:nyc_studio).description
  end

  test "space management requires an administrator" do
    sign_in_as users(:member)

    get new_space_path

    assert_redirected_to root_path
    assert_equal "You are not authorized to view that page.", flash[:alert]
  end

  test "administrator can create a space with permitted fields" do
    sign_in_as users(:admin)

    assert_difference "Space.count", 1 do
      post spaces_path, params: {
        space: {
          name: "Chelsea Rehearsal Room",
          description: "Mirrors and chairs",
          city_id: cities(:new_york).id,
          real_city: "New York",
          state: "NY",
          zip: "10011",
          unknown_attribute: "ignored"
        }
      }
    end

    space = Space.find_by!(name: "Chelsea Rehearsal Room")
    assert_redirected_to space_path(space)
    assert_equal cities(:new_york), space.city
  end

  test "administrator can update and destroy a friendly-id space" do
    sign_in_as users(:admin)
    space = spaces(:nyc_studio)

    patch space_path(space), params: {
      space: { description: "Updated rooms", city_id: cities(:new_york).id }
    }

    assert_redirected_to edit_space_url(space)
    assert_equal "Updated rooms", space.reload.description

    assert_difference "Space.count", -1 do
      delete space_path(space)
    end
    assert_redirected_to spaces_url
  end
end
