class AddSplashscreenCropValuesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :splashscreen_image_crop_w, :integer
    add_column :users, :splashscreen_image_crop_h, :integer
    add_column :users, :splashscreen_image_crop_x, :integer
    add_column :users, :splashscreen_image_crop_y, :integer
  end
end
