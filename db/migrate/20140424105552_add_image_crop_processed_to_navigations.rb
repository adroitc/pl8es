class AddImageCropProcessedToNavigations < ActiveRecord::Migration
  def change
    add_column :navigations, :image_crop_processed, :boolean, :default => true
  end
end
