json.restaurants (@restaurants) do |json, restaurant|
	json.(restaurant, :id, :name)
	
	json.location restaurant.location, :address, :zip, :city, :country
end