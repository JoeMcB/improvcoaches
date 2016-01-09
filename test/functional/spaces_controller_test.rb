require 'test_helper'

class SpacesControllerTest < ActionController::TestCase
  setup do
    @space = spaces(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:spaces)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create space" do
    assert_difference('Space.count') do
      post :create, space: { address: @space.address, address_2: @space.address_2, city: @space.city, city_id: @space.city_id, description: @space.description, facebook_link: @space.facebook_link, name: @space.name, phone: @space.phone, rating: @space.rating, state: @space.state, website_link: @space.website_link, yelp_link: @space.yelp_link, zip: @space.zip }
    end

    assert_redirected_to space_path(assigns(:space))
  end

  test "should show space" do
    get :show, id: @space
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @space
    assert_response :success
  end

  test "should update space" do
    put :update, id: @space, space: { address: @space.address, address_2: @space.address_2, city: @space.city, city_id: @space.city_id, description: @space.description, facebook_link: @space.facebook_link, name: @space.name, phone: @space.phone, rating: @space.rating, state: @space.state, website_link: @space.website_link, yelp_link: @space.yelp_link, zip: @space.zip }
    assert_redirected_to space_path(assigns(:space))
  end

  test "should destroy space" do
    assert_difference('Space.count', -1) do
      delete :destroy, id: @space
    end

    assert_redirected_to spaces_path
  end
end
