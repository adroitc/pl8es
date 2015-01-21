class DropTableLanguagesMenus < ActiveRecord::Migration
  def change
	  drop_table :languages_menus
  end
end
