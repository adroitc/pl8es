class AddImageCropValuesToDailyDishes < ActiveRecord::Migration
  def change
    add_column :daily_dishes, :image_crop_w, :integer
    add_column :daily_dishes, :image_crop_h, :integer
    add_column :daily_dishes, :image_crop_x, :integer
    add_column :daily_dishes, :image_crop_y, :integer
  end
end
