class OffersController < ApplicationController
	
	def index
		week_range = Date.today.at_beginning_of_week..Date.today.at_end_of_week
		
		@offers = current_user.restaurant.offers.in_range(week_range)
		@dates_with_offers = Offer.dates_with_offers(@offers, week_range)
	end
end
