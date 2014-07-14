class AddTranslationsToRestaurant < ActiveRecord::Migration
  def up
    Restaurant.create_translation_table! :description => :string
  end
  
  def down
    Restaurant.drop_translation_table!
  end
end
