class AddImagesToRestaurants < ActiveRecord::Migration
  def change
    add_attachment :restaurants, :preview_image
    add_column :restaurants, :preview_image_fingerprint, :string
    add_column :restaurants, :preview_image_crop_w, :integer
    add_column :restaurants, :preview_image_crop_h, :integer
    add_column :restaurants, :preview_image_crop_x, :integer
    add_column :restaurants, :preview_image_crop_y, :integer
    add_column :restaurants, :preview_image_processed, :boolean, :default => true
    
    add_attachment :restaurants, :appmain_image
    add_column :restaurants, :appmain_image_fingerprint, :string
    add_column :restaurants, :appmain_image_crop_w, :integer
    add_column :restaurants, :appmain_image_crop_h, :integer
    add_column :restaurants, :appmain_image_crop_x, :integer
    add_column :restaurants, :appmain_image_crop_y, :integer
    add_column :restaurants, :appmain_image_processed, :boolean, :default => true
    
    add_attachment :restaurants, :logo_image
    add_column :restaurants, :logo_image_fingerprint, :string
    add_column :restaurants, :logo_image_crop_w, :integer
    add_column :restaurants, :logo_image_crop_h, :integer
    add_column :restaurants, :logo_image_crop_x, :integer
    add_column :restaurants, :logo_image_crop_y, :integer
    add_column :restaurants, :logo_image_processed, :boolean, :default => true
    
    add_attachment :restaurants, :splashscreen_image
    add_column :restaurants, :splashscreen_image_fingerprint, :string
    add_column :restaurants, :splashscreen_image_crop_w, :integer
    add_column :restaurants, :splashscreen_image_crop_h, :integer
    add_column :restaurants, :splashscreen_image_crop_x, :integer
    add_column :restaurants, :splashscreen_image_crop_y, :integer
    add_column :restaurants, :splashscreen_image_processed, :boolean, :default => true
    
    add_attachment :restaurants, :restaurant_image
    add_column :restaurants, :restaurant_image_fingerprint, :string
    add_column :restaurants, :restaurant_image_crop_w, :integer
    add_column :restaurants, :restaurant_image_crop_h, :integer
    add_column :restaurants, :restaurant_image_crop_x, :integer
    add_column :restaurants, :restaurant_image_crop_y, :integer
    add_column :restaurants, :restaurant_image_processed, :boolean, :default => true
  end
end
