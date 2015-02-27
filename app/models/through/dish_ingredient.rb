class DishIngredient < ActiveRecord::Base
	# –––––––––––––
	#   Relations
	# –––––––––––––
	
	belongs_to :dish
	belongs_to :ingredient
	
	# –––––––––––––
	#  Validations
	# –––––––––––––
	
	validates_uniqueness_of :ingredient_id, scope: :dish_id
end
