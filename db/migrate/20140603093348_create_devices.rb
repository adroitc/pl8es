class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.references :user
      
      t.string :device_id
      t.string :device_app
      t.string :device_version
      t.string :device_type
      t.string :device_system
      
      t.string :request_hash
      t.datetime :request_update

      t.timestamps
    end
  end
end
