class DropSuperfluousDishColumns < ActiveRecord::Migration
  def change
	  remove_column :dishes, :menu_id
	  remove_column :dishes, :wines_id
	  remove_column :dishes, :category_id
	  remove_column :dishes, :image_crop_w
	  remove_column :dishes, :image_crop_h
	  remove_column :dishes, :image_crop_x
	  remove_column :dishes, :image_crop_y
	  remove_column :dishes, :ingredients_id
  end
end
