class CreateFavoriteRestaurants < ActiveRecord::Migration
  def change
    create_table :favorite_restaurants do |t|
      t.references :device
      t.references :restaurant

      t.timestamps
    end
  end
end
