class DishIngredient < ActiveRecord::Base
	# –––––––––––––
	#   Relations
	# –––––––––––––
	
	belongs_to :dish
	belongs_to :ingredient
end
