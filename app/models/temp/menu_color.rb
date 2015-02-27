class MenuColor < ActiveRecord::Base
	belongs_to :restaurant
	
	validates :background, :presence => true, :length => 4..7
	validates :bar_background, :presence => true, :length => 4..7
	validates :nav_text, :presence => true, :length => 4..7
	validates :nav_text_active, :presence => true, :length => 4..7
	
end
