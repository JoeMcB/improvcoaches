require "test_helper"

class TimeBlockTest < ActiveSupport::TestCase
  test "accepts valid calendar coordinates" do
    block = schedules(:member).time_blocks.build(day: 0, hour: 0, minute: 0)

    assert_predicate block, :valid?
  end

  test "rejects values outside calendar boundaries" do
    block = schedules(:member).time_blocks.build(day: 7, hour: 24, minute: 60)

    assert_not block.valid?
    assert block.errors[:day].present?
    assert block.errors[:hour].present?
    assert block.errors[:minute].present?
  end

  test "requires a schedule" do
    block = TimeBlock.new(day: 1, hour: 10, minute: 0)

    assert_not block.valid?
    assert block.errors[:schedule].present?
  end
end
