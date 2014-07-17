class RenameCropProcessed < ActiveRecord::Migration
  def change
    rename_column :restaurants, :restaurant_image_processed, :restaurant_image_crop_processed
    rename_column :restaurants, :logo_image_processed, :logo_image_crop_processed
  end
end
