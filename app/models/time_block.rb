# == Schema Information
#
# Table name: time_blocks
#
#  id          :integer          not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  day         :integer
#  hour        :integer
#  minute      :integer
#  schedule_id :integer
#

class TimeBlock < ActiveRecord::Base
  belongs_to :schedule

  validates :schedule_id, presence: true
  validates :day, presence: true, numericality: { greater_than_or_equal_: 0, less_than: 7 }
  validates :hour, presence: true, numericality: { greater_than_or_equal_: 0, less_than: 24 }
  validates :minute, presence: true, numericality: { greater_than_or_equal_: 0, less_than: 60 }
end
