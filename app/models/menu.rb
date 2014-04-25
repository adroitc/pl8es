class Menu < ActiveRecord::Base
  belongs_to :user
  
  belongs_to :menuLabel
  
  has_many :navigations
  has_many :beverages
  
  has_and_belongs_to_many :languages
  belongs_to :default_language, :class_name => "Language"
  
  belongs_to :menuColor
  
  def navigations_main
    return navigations.find_all_by_level(0)
  end
end
