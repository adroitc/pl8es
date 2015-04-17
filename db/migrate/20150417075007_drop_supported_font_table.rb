class DropSupportedFontTable < ActiveRecord::Migration
  def change
	  drop_table :supported_fonts
	  remove_column :restaurants, :supportedFont_id
  end
end
