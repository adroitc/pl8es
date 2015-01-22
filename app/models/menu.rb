class Menu < ActiveRecord::Base
  belongs_to :restaurant
  
  belongs_to :menuColorTemplate
  belongs_to :menuColor
  
  has_many :categories#, -> { where(:category_id => nil) }
  has_many :dishes
  has_many :beverages
	
	validates :title, :presence => true, :length => 4..75
	validates :from_time, :allow_blank => true, :length => 4..7
	validates :to_time, :allow_blank => true, :length => 4..7
	
	
	def default?
		if self.id.present?
			self == self.restaurant.defaultMenu ? true : false
		else
			self.restaurant.menus.count == 0 ? true : false
		end
	end
	
	def to_param
		"#{id} #{title}".parameterize
	end
end
