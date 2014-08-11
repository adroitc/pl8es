class Location < ActiveRecord::Base
  belongs_to :restaurant
  
  attr_accessor :distance
  acts_as_mappable :default_units => :kms,
                   :default_formula => :sphere,
                   :distance_field_name => :distance,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude
  
  validates :address, :presence => true, :length => {
    :maximum => 255
  }
  validates :zip, :presence => true, :length => {
    :maximum => 255
  }
  validates :city, :presence => true, :length => {
    :maximum => 255
  }
  validates :country, :presence => true, :length => {
    :maximum => 255
  }
  
end
