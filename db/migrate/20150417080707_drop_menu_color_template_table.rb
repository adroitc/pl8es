class DropMenuColorTemplateTable < ActiveRecord::Migration
  def change
	  drop_table :menu_colors
	  drop_table :menu_color_templates
	  
	  remove_column :restaurants, :menuColorTemplate_id
	  remove_column :restaurants, :menuColor_id
  end
end
