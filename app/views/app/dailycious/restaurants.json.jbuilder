json.restaurants (@locations) do |location|
		json.(location.restaurant, :id, :name)
		json.logo_url image_url_for_host(location.restaurant.logo_image.url(:cropped_dailycious_retina))

		json.location do
			json.(location, :address, :zip, :city, :country, :distance, :latitude, :longitude)
		end

		json.offers location.restaurant.offers.in_range([Date.today]) do |offer|
			json.(offer.dish, :id, :title, :price)
			json.cropped_suggestion_retina image_url_for_host(offer.dish.image.url(:cropped_default_retina))
			json.original_cropping image_url_for_host(offer.dish.image.url(:original_cropping))
		end
end