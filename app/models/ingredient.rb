class Ingredient < ActiveRecord::Base
	
	# –––––––––––––
	#   Relations
	# –––––––––––––
	
	has_many :dish_ingredients
	has_many :dishes, :through => :dish_ingredients
	
	# –––––––––––––
	#  Validations
	# –––––––––––––
	
	validates :abbreviation, :presence => true, :length => { :maximum => 2 }
	
	# ––––––––––––––
	#  Translations
	# ––––––––––––––
	
	translates :title
	
end
