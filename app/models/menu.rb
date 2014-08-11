class Menu < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :default_language, :class_name => "Language"
  has_and_belongs_to_many :languages
  belongs_to :menuColorTemplate
  belongs_to :menuColor
  has_many :navigations
  has_many :dishes
  has_many :beverages
  
  validates :title, :length => {
    :minimum => 4,
    :maximum => 75
  }
  validates :from_time, :length => {
    :minimum => 4,
    :maximum => 7
  }
  validates :to_time, :length => {
    :minimum => 4,
    :maximum => 7
  }
  
end
