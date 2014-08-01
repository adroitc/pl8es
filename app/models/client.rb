class Client < ActiveRecord::Base
  belongs_to :restaurant
  
	def self.validHeader(header)
    if header["Device-Id"] && header["Device-App"] && header["Device-Version"] && header["Device-Type"] && header["Device-System"]
      if Client.exists?(:device_id => header["Device-Id"])
        client = Client.find_by_device_id(header["Device-Id"])
        client.update_attributes({
          :device_app => header["Device-App"],
          :device_version => header["Device-Version"],
          :device_type => header["Device-Type"],
          :device_system => header["Device-System"]
        })
        client.touch
      else
        client = Client.create([{
          :device_id => header["Device-Id"],
          :device_app => header["Device-App"],
          :device_version => header["Device-Version"],
          :device_type => header["Device-Type"],
          :device_system => header["Device-System"]
        }])
      end
      return client
    end
		return nil
	end
  
end
