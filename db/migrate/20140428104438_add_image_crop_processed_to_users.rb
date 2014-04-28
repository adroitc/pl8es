class AddImageCropProcessedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :restaurant_image_processed, :boolean, :default => true
    add_column :users, :logo_image_processed, :boolean, :default => true
    add_column :users, :appmain_image_processed, :boolean, :default => true
  end
end
