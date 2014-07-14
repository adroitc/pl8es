class AddFieldsToRestaurant < ActiveRecord::Migration
  def up
		create_table :languages_restaurants do |t|
			t.belongs_to :language
			t.belongs_to :restaurant
		end
    User.create_translation_table! :description => :string
  end
  
  def down
    drop_table :languages_restaurants
    User.drop_translation_table!
  end
end
