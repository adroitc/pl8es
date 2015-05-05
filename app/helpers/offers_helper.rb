module OffersHelper
	def output_dates_range(dates)
		l(dates.to_a.first[0], format: :long) + " - " + l(dates.to_a.last[0], format: :long)
	end
end
