class RestaurantsController < ApplicationController
	
	def search
		if params[:s].length > 1
			search_term = params[:s].gsub(/\s+/, " ")
			search_term = "%#{search_term.squish.downcase}%"
			
			@restaurants = Restaurant.referred.where("lower(restaurants.name) LIKE ?", search_term).joins(:location)
			
			if params[:limit]
				@restaurants = @restaurants.limit(params[:limit].to_i)
			end
		else
			@restaurants = nil
		end
	end
end