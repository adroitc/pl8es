module LunchMenusHelper
	def get_week_range(date)
		l(date.beginning_of_week, format: :long) + " - " + l(date.end_of_week, format: :long)
	end
end
