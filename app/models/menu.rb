class Menu < ActiveRecord::Base
  belongs_to :user
  belongs_to :default_language, :class_name => "Language"
  has_and_belongs_to_many :languages
  belongs_to :menuLabel
  belongs_to :menuColorTemplate
  belongs_to :menuColor
  has_many :navigations
  has_many :dishes
  has_many :beverages
end
