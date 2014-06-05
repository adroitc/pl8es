class Location < ActiveRecord::Base
  belongs_to :user
  
  validates :address, :length => {
    :maximum => 28
  }
  
  validates :zip, :length => {
    :maximum => 28
  }
  
  validates :city, :length => {
    :maximum => 28
  }
  
  validates :country, :length => {
    :maximum => 28
  }
end
