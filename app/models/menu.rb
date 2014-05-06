class Menu < ActiveRecord::Base
  belongs_to :user
  
  belongs_to :menuLabel
  
  has_many :navigations
  has_many :dishes
  has_many :beverages
  
  has_and_belongs_to_many :languages
  belongs_to :default_language, :class_name => "Language"
  
  belongs_to :menuColor
  
end
