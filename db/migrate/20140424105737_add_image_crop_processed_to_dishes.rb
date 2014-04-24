class AddImageCropProcessedToDishes < ActiveRecord::Migration
  def change
    add_column :dishes, :image_crop_processed, :boolean, :default => true
  end
end
