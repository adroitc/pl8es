class Device < ActiveRecord::Base
  belongs_to :user
  has_many :favoriteRestaurants
  has_many :restaurants, :through => :favoriteRestaurants

	def self.validHeader(header)
    if header["Device-Id"] && header["Device-App"] && header["Device-Version"] && header["Device-Type"] && header["Device-System"]
      if Device.exists?(:device_id => header["Device-Id"])
        device = Device.find_by_device_id(header["Device-Id"])
        device.update_attributes({
          :device_app => header["Device-App"],
          :device_version => header["Device-Version"],
          :device_type => header["Device-Type"],
          :device_system => header["Device-System"]
        })
        device.touch
      else
        device = Device.create({
          :device_id => header["Device-Id"],
          :device_app => header["Device-App"],
          :device_version => header["Device-Version"],
          :device_type => header["Device-Type"],
          :device_system => header["Device-System"]
        })
      end
      return device
    end
		return nil
	end
  
end
