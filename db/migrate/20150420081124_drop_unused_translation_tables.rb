class DropUnusedTranslationTables < ActiveRecord::Migration
  def change
	  drop_table :beverage_navigation_translations
	  drop_table :wine_translations
  end
end
