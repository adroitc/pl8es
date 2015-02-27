class RemoveXywhColumns < ActiveRecord::Migration
  def change
	  remove_column :categories, :image_crop_h
	  remove_column :categories, :image_crop_w
	  remove_column :categories, :image_crop_x
	  remove_column :categories, :image_crop_y
	  remove_column :categories, :level
  end
end
