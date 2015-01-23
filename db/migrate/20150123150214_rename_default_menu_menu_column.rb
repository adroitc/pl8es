class RenameDefaultMenuMenuColumn < ActiveRecord::Migration
  def change
	  rename_column :restaurants, :defaultMenu_id, :default_menu_id
  end
end
