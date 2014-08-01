class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.references :restaurant
      
      t.string :device_id
      t.string :device_app
      t.string :device_version
      t.string :device_type
      t.string :device_system
      
      t.string :request_hash
      t.datetime :request_update

      t.timestamps
    end

    remove_column :devices, :request_hash, :string
    remove_column :devices, :request_update, :datetime
  end
end
