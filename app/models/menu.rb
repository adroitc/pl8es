class Menu < ActiveRecord::Base
  belongs_to :restaurant
  
  belongs_to :menuColorTemplate
  belongs_to :menuColor
  
  has_many :categories
  has_many :dishes, :through => :categories
	
	validates :title, :presence => true, :length => 4..75
	validates :from_time, :allow_blank => true, :length => 4..7
	validates :to_time, :allow_blank => true, :length => 4..7
	
	
	def default?
		if self.id.present?
			self == self.restaurant.default_menu ? true : false
		else
			false
		end
	end
	
	def to_param
		"#{id} #{title}".parameterize
	end
end
