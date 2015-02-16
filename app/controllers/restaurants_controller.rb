class RestaurantsController < ApplicationController
	
	def search
		search_term = params[:s].gsub(/\s+/, " ")
		search_term = "%#{search_term.squish.downcase}%"
		
		@restaurants = Restaurant.referred.where("lower(restaurants.name) LIKE ?", search_term).joins(:location)
	end
end