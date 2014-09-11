class AddTranslationsToRestaurant < ActiveRecord::Migration
  def up
    Restaurant.create_translation_table! :description => :text
  end
  
  def down
    Restaurant.drop_translation_table!
  end
end
