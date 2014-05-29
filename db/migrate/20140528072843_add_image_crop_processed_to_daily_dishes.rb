class AddImageCropProcessedToDailyDishes < ActiveRecord::Migration
  def change
    add_column :daily_dishes, :image_crop_processed, :boolean, :default => true
  end
end
