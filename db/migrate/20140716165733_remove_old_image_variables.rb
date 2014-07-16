class RemoveOldImageVariables < ActiveRecord::Migration
  def change
    #remove_attachment :users, :preview_image
    remove_column :users, :preview_image_fingerprint, :string
    remove_column :users, :preview_image_crop_w, :integer
    remove_column :users, :preview_image_crop_h, :integer
    remove_column :users, :preview_image_crop_x, :integer
    remove_column :users, :preview_image_crop_y, :integer
    remove_column :users, :preview_image_processed, :boolean, :default => true
    
    #remove_attachment :users, :appmain_image
    remove_column :users, :appmain_image_fingerprint, :string
    remove_column :users, :appmain_image_crop_w, :integer
    remove_column :users, :appmain_image_crop_h, :integer
    remove_column :users, :appmain_image_crop_x, :integer
    remove_column :users, :appmain_image_crop_y, :integer
    remove_column :users, :appmain_image_processed, :boolean, :default => true
    
    #remove_attachment :users, :logo_image
    remove_column :users, :logo_image_fingerprint, :string
    remove_column :users, :logo_image_crop_w, :integer
    remove_column :users, :logo_image_crop_h, :integer
    remove_column :users, :logo_image_crop_x, :integer
    remove_column :users, :logo_image_crop_y, :integer
    remove_column :users, :logo_image_processed, :boolean, :default => true
    
    #remove_attachment :users, :splashscreen_image
    remove_column :users, :splashscreen_image_fingerprint, :string
    remove_column :users, :splashscreen_image_crop_w, :integer
    remove_column :users, :splashscreen_image_crop_h, :integer
    remove_column :users, :splashscreen_image_crop_x, :integer
    remove_column :users, :splashscreen_image_crop_y, :integer
    remove_column :users, :splashscreen_image_processed, :boolean, :default => true
    
    #remove_attachment :users, :restaurant_image
    remove_column :users, :restaurant_image_fingerprint, :string
    remove_column :users, :restaurant_image_crop_w, :integer
    remove_column :users, :restaurant_image_crop_h, :integer
    remove_column :users, :restaurant_image_crop_x, :integer
    remove_column :users, :restaurant_image_crop_y, :integer
    remove_column :users, :restaurant_image_processed, :boolean, :default => true
  end
end
