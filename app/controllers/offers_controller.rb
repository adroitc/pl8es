class OffersController < ApplicationController
	
	def index
		week_start = (Date.today + params[:weeks].to_i*7).at_beginning_of_week
		week_end = (Date.today + params[:weeks].to_i*7).at_end_of_week
		
		week_range = week_start..week_end
		
		@offers = current_user.restaurant.offers.in_range(week_range)
		@dates_with_offers = Offer.dates_with_offers(@offers, week_range)
	end
end
