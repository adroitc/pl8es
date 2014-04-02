class User < ActiveRecord::Base
	has_and_belongs_to_many :languages
  belongs_to :default_language, :class_name => "Language"
  has_many :openingHours
  has_and_belongs_to_many :categories
  has_many :menus
  has_many :daily_dishes, :class_name => "Dish"
  
  translates :description
  
  validates :email, :uniqueness => true
end
