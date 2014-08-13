class CorrectImageCropProcessedColumns < ActiveRecord::Migration
  def change
    rename_column :menu_color_templates, :preview_image_processed, :preview_image_crop_processed
    rename_column :restaurants, :preview_image_processed, :preview_image_crop_processed
    rename_column :restaurants, :appmain_image_processed, :appmain_image_crop_processed
    rename_column :restaurants, :splashscreen_image_processed, :splashscreen_image_crop_processed
  end
end
