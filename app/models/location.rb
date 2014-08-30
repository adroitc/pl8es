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
  
  def self.validate_address(params)
    if !params.values_at(:address, :zip, :city, :country).include?(nil)
      google_address = params[:address].gsub(" ","+")+","+params[:zip].gsub(" ","+")+","+params[:city].gsub(" ","+")+","+params[:country].gsub(" ","+")
      google_url = URI.parse(URI.encode("http://maps.googleapis.com/maps/api/geocode/json?address="+google_address+"&sensor=false&language="+I18n.locale.to_s))
      google_req = Net::HTTP::Get.new(google_url.request_uri)
      google_res = Net::HTTP.start(google_url.host, google_url.port) {|http|
        http.request(google_req)
      }
      google_results = JSON.parse(google_res.body)["results"]
      if google_results.count == 1 && google_results[0]["geometry"]["location_type"] == "ROOFTOP"
        return {
          :address => google_results[0]["address_components"].find_all{|item|
            item["types"] == ["route"]
          }[0]["long_name"]+" "+google_results[0]["address_components"].find_all{|item|
            item["types"] == ["street_number"]
          }[0]["long_name"],
          :zip => google_results[0]["address_components"].find_all{|item|
            item["types"] == ["postal_code"]
          }[0]["long_name"],
          :city => google_results[0]["address_components"].find_all{|item|
            item["types"] == ["locality", "political"]
          }[0]["long_name"],
          :country => google_results[0]["address_components"].find_all{|item|
            item["types"] == ["country", "political"]
          }[0]["long_name"]
        }
      end
    end
    return nil
  end
  
end
