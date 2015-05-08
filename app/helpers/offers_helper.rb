module OffersHelper
	def output_dates_range(dates)
		l(dates.to_a.first[0], format: :long) + " - " + l(dates.to_a.last[0], format: :long)
	end
	
	def weekdays_array
		final_arr = []
		[:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday].each do |weekday|
			final_arr << [weekday.to_s.titleize, weekday]
		end
		
		return final_arr
	end
end
