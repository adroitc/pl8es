class Menu < ActiveRecord::Base
  has_many :navigations
  has_many :beverages
  
  has_and_belongs_to_many :languages
  belongs_to :default_language, :class_name => "Language"
  
  belongs_to :menuColor
end
