module SearchHelper
	def days
		{ 
			'Sunday' => 0,
			'Monday' => 1,
			'Tuesday' => 2,
			'Wednesday' => 3,
			'Thursday' => 4,
			'Friday' => 5,
			'Saturday' => 6
		}
	end

	def searchable_hours
		hours = 8..24

		return hours.collect do |h|
			suffix = "pm"
			value = h

			if(h < 12) then
				suffix = "am"
			elsif(h > 12) then
				 h = h - 12
			end

			[h.to_s + suffix, value]
		end
	end
end
