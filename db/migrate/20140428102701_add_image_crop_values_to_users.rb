class AddImageCropValuesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :restaurant_image_crop_w, :integer
    add_column :users, :restaurant_image_crop_h, :integer
    add_column :users, :restaurant_image_crop_x, :integer
    add_column :users, :restaurant_image_crop_y, :integer
    add_column :users, :logo_image_crop_w, :integer
    add_column :users, :logo_image_crop_h, :integer
    add_column :users, :logo_image_crop_x, :integer
    add_column :users, :logo_image_crop_y, :integer
    add_column :users, :appmain_image_crop_w, :integer
    add_column :users, :appmain_image_crop_h, :integer
    add_column :users, :appmain_image_crop_x, :integer
    add_column :users, :appmain_image_crop_y, :integer
  end
end
