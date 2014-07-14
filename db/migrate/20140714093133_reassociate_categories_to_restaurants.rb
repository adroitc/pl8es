class ReassociateCategoriesToRestaurants < ActiveRecord::Migration
  def change
    drop_table :categories_users
    
		create_table :categories_restaurants do |t|
			t.belongs_to :category
			t.belongs_to :restaurant
		end
  end
end
