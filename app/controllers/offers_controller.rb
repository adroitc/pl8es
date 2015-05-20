class OffersController < ApplicationController
	
	def index
		selected_date = Date.today + params[:weeks].to_i*7
		week_range = selected_date.at_beginning_of_week..selected_date.at_end_of_week
		
		@offers = current_user.restaurant.offers.in_range(week_range)
		@dates_with_dishes = Offer.dates_with_dishes(@offers, week_range)
	end
	
	def new
		@offer = Offer.new
	end
	
	def create
		@offer = current_user.restaurant.offers.build(offer_params)
		
		unless @offer.save
			render :new
		end
	end
	
	private
		
		def offer_params
			params[:offer][:on].shift if params[:offer][:on].first.blank? # strip the empty element from the hidden field - this is used to send data even when no days are selected (
			params.require(:offer).permit(:dish_id, :start_date, :end_date, :interval, :every, :on => [])
		end
end
