require "test_helper"

class SchedulesControllerTest < ActionDispatch::IntegrationTest
  test "schedule editing requires login" do
    post profile_edit_schedule_path, params: { time_blocks: {} }

    assert_redirected_to root_path
  end

  test "schedule update replaces the signed-in coach's availability" do
    sign_in_as users(:coach)
    schedule = schedules(:coach)

    assert_changes -> { schedule.time_blocks.reload.pluck(:day, :hour, :minute) } do
      post profile_edit_schedule_path, params: {
        time_blocks: {
          "0" => { day: "Tuesday", hour: "18", minute: "0" },
          "1" => { day: "Tuesday", hour: "18", minute: "30" }
        }
      }
    end

    assert_redirected_to profile_edit_schedule_path
    assert_equal [[2, 18, 0], [2, 18, 30]], schedule.time_blocks.order(:hour, :minute).pluck(:day, :hour, :minute)
  end

  test "submitting no blocks clears availability" do
    sign_in_as users(:coach)

    assert_difference "TimeBlock.count", -3 do
      post profile_edit_schedule_path
    end

    assert_redirected_to profile_edit_schedule_path
  end
end
