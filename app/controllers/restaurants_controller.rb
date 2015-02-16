class RestaurantsController < ApplicationController
	
	def search
		if params[:s].length > 1
			search_term = params[:s].gsub(/\s+/, " ")
			search_term = "%#{search_term.squish.downcase}%"
			
			@restaurants = Restaurant.referred.where("lower(restaurants.name) LIKE ?", search_term).joins(:location)
		else
			@restaurants = nil
		end
	end
end