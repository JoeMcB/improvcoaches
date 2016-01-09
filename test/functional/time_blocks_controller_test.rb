require 'test_helper'

class TimeBlocksControllerTest < ActionController::TestCase
  setup do
    @time_block = time_blocks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:time_blocks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create time_block" do
    assert_difference('TimeBlock.count') do
      post :create, time_block: { day_of_week: @time_block.day_of_week, end_time: @time_block.end_time, start_time: @time_block.start_time, user_id: @time_block.user_id }
    end

    assert_redirected_to time_block_path(assigns(:time_block))
  end

  test "should show time_block" do
    get :show, id: @time_block
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @time_block
    assert_response :success
  end

  test "should update time_block" do
    put :update, id: @time_block, time_block: { day_of_week: @time_block.day_of_week, end_time: @time_block.end_time, start_time: @time_block.start_time, user_id: @time_block.user_id }
    assert_redirected_to time_block_path(assigns(:time_block))
  end

  test "should destroy time_block" do
    assert_difference('TimeBlock.count', -1) do
      delete :destroy, id: @time_block
    end

    assert_redirected_to time_blocks_path
  end
end
