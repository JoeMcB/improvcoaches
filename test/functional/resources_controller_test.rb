require 'test_helper'

class ResourcesControllerTest < ActionController::TestCase
  setup do
    @resource = resources(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:resources)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create resource" do
    assert_difference('Resource.count') do
      post :create, resource: { amazon_id: @resource.amazon_id, image_url: @resource.image_url, long_description: @resource.long_description, name: @resource.name, price: @resource.price, resource_type: @resource.resource_type, short_description: @resource.short_description, url: @resource.url }
    end

    assert_redirected_to resource_path(assigns(:resource))
  end

  test "should show resource" do
    get :show, id: @resource
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @resource
    assert_response :success
  end

  test "should update resource" do
    put :update, id: @resource, resource: { amazon_id: @resource.amazon_id, image_url: @resource.image_url, long_description: @resource.long_description, name: @resource.name, price: @resource.price, resource_type: @resource.resource_type, short_description: @resource.short_description, url: @resource.url }
    assert_redirected_to resource_path(assigns(:resource))
  end

  test "should destroy resource" do
    assert_difference('Resource.count', -1) do
      delete :destroy, id: @resource
    end

    assert_redirected_to resources_path
  end
end
