class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.references :user
      
      t.float :latitude
      t.float :longitude
      
      t.string :address
      t.string :zip
      t.string :city
      t.string :country

      t.timestamps
    end
  end
end
