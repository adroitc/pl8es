class RemoveOldUserImageColumns < ActiveRecord::Migration
  def change
    remove_column :users, :restaurant_image_file_name, :string
    remove_column :users, :restaurant_image_content_type, :string
    remove_column :users, :restaurant_image_file_size, :integer
    remove_column :users, :restaurant_image_updated_at, :datetime
    remove_column :users, :restaurant_image_dimensions, :string
    
    remove_column :users, :logo_image_file_name, :string
    remove_column :users, :logo_image_content_type, :string
    remove_column :users, :logo_image_file_size, :integer
    remove_column :users, :logo_image_updated_at, :datetime
    remove_column :users, :logo_image_dimensions, :string
    
    remove_column :users, :appmain_image_file_name, :string
    remove_column :users, :appmain_image_content_type, :string
    remove_column :users, :appmain_image_file_size, :integer
    remove_column :users, :appmain_image_updated_at, :datetime
    remove_column :users, :appmain_image_dimensions, :string
    
    remove_column :users, :splashscreen_image_file_name, :string
    remove_column :users, :splashscreen_image_content_type, :string
    remove_column :users, :splashscreen_image_file_size, :integer
    remove_column :users, :splashscreen_image_updated_at, :datetime
    remove_column :users, :splashscreen_image_dimensions, :string
    
    remove_column :users, :splashscreen_image_processed, :boolean
  end
end
