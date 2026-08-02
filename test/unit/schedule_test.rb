require "test_helper"

class ScheduleTest < ActiveSupport::TestCase
  test "has_block checks an exact availability slot" do
    schedule = schedules(:coach)

    assert schedule.has_block?(1, 10, 0)
    assert_not schedule.has_block?(1, 9, 30)
  end

  test "has_time_span requires every half-hour slot inclusively" do
    schedule = schedules(:coach)

    assert schedule.has_time_span(10, 0, 11, 0, 1)
    assert_not schedule.has_time_span(10, 0, 11, 30, 1)
    assert schedule.has_time_span(10, 30, nil, nil, 1)
  end

  test "first and last available hours handle populated and empty schedules" do
    schedule = schedules(:coach)
    assert_equal 10, schedule.first_hour_available
    assert_equal 11, schedule.last_hour_available

    empty_schedule = schedules(:member)
    assert_nil empty_schedule.first_hour_available
    assert_nil empty_schedule.last_hour_available
  end
end
