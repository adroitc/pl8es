json.restaurants (@locations) do |location|
		json.(location.restaurant, :id, :name)
		json.logo_url image_url_for_host(location.restaurant.logo_image.url(:cropped_dailycious_retina))

		json.location do
			json.(location, :address, :zip, :city, :country, :distance, :latitude, :longitude)
		end

		json.dishes Dish.where( :id => location.restaurant.offers.dates_with_dishes(location.restaurant.offers, Date.today..Date.today).first.last ) do |dish|
			json.(dish, :id, :title, :price)
			json.cropped_suggestion_retina image_url_for_host(dish.image.url(:cropped_default_retina))
			json.original_cropping image_url_for_host(dish.image.url(:original_cropping))
		end
end