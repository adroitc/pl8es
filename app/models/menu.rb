class Menu < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :default_language, :class_name => "Language"
  has_and_belongs_to_many :languages
  belongs_to :menuColorTemplate
  belongs_to :menuColor
  has_many :navigations, -> { where(:navigation_id => nil) }
  has_many :dishes
  has_many :beverages
	
	validates :title, :presence => true, :length => 4..75
	validates :from_time, :allow_blank => true, :length => 4..7
	validates :to_time, :allow_blank => true, :length => 4..7
	
end
