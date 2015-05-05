class OffersController < ApplicationController
	
	def index
		selected_date = Date.today + params[:weeks].to_i*7
		week_range = selected_date.at_beginning_of_week..selected_date.at_end_of_week
		
		@offers = current_user.restaurant.offers.in_range(week_range)
		@dates_with_offers = Offer.dates_with_offers(@offers, week_range)
	end
end
