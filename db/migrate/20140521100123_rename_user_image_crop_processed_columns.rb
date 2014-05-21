class RenameUserImageCropProcessedColumns < ActiveRecord::Migration
  def change
    rename_column :users, :restaurant_image_processed, :restaurant_image_crop_processed
    rename_column :users, :logo_image_processed, :logo_image_crop_processed
    rename_column :users, :appmain_image_processed, :appmain_image_crop_processed
  end
end
