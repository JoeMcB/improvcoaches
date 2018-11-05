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

    if end_hour.nil? then end_hour = start_hour end
    if end_minute.nil? then end_hour = start_minute end
    
    while h < end_hour || ( h == end_hour && m <= end_minute )
      if(time_blocks.where(
        hour: h,
        minute: m,
        day: d
      ).first().nil?) then
        success = false
        break
      else
        m += 30
        h += 1 if m >= 60
        m = 0 if m >= 60
      end
    end

    return success
  end

  def first_hour_available
    first_block = time_blocks.first( order: 'hour asc');

    first_block.hour unless first_block.nil?
  end

  def last_hour_available
    first_block = time_blocks.first( order: 'hour desc');

    first_block.hour unless first_block.nil?
  end
end
