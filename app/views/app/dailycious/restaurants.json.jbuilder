json.restaurants (@locations) do |location|
		json.(location.restaurant, :id, :name)
		json.logo_url image_url_for_host location.restaurant.logo_image.url(:cropped_dailycious_retina)

		json.location do
			json.(location, :address, :zip, :city, :country, :distance, :latitude, :longitude)
		end

		json.daily_dishes location.restaurant.daily_dishes do |dish|
			json.(dish, :id, :title, :price, :image_fingerprint)
			json.image_map_url image_url_for_host dish.image.url(:cropped_map_retina)
			json.image_small_url image_url_for_host dish.image.url(:cropped_small_retina)
		end
end