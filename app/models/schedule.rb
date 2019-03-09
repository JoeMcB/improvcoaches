# frozen_string_literal: true

# == Schema Information
#
# Table name: schedules
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#


class Schedule < ActiveRecord::Base
  belongs_to :user
  has_many :time_blocks

  def has_block?(day, hour, minute)
    time_blocks.any? do |block|
      block.day == day &&
        block.hour == hour &&
        block.minute == minute
    end
  end

  def has_time_span(start_hour, start_minute, end_hour, end_minute, day)
    h = start_hour
    m = start_minute
    d = day
    success = true

    end_hour = start_hour if end_hour.nil?
    end_hour = start_minute if end_minute.nil?

    while h < end_hour || (h == end_hour && m <= end_minute)
      if time_blocks.where(
        hour: h,
        minute: m,
        day: d
      ).first.nil?
        success = false
        break
      else
        m += 30
        h += 1 if m >= 60
        m = 0 if m >= 60
      end
    end

    success
  end

  def first_hour_available
    first_block = time_blocks.order('hour asc').first

    first_block&.hour
  end

  def last_hour_available
    first_block = time_blocks.order('hour desc').first

    first_block&.hour
  end
end
