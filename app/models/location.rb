class Location < ActiveRecord::Base
  belongs_to :user
  
  attr_accessor :distance
  acts_as_mappable :default_units => :kms,
                   :default_formula => :sphere,
                   :distance_field_name => :distance,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude
  
  validates :address, :length => {
    :maximum => 250
  }
  validates :zip, :length => {
    :maximum => 28
  }
  validates :city, :length => {
    :maximum => 250
  }
  validates :country, :length => {
    :maximum => 250
  }
  
end
