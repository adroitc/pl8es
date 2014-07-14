class RemoveUnneededColumnsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :restaurant_image_crop_processed, :boolean
    remove_column :users, :logo_image_crop_processed, :boolean
    remove_column :users, :appmain_image_crop_processed, :boolean
    remove_column :users, :background_type, :string
    
    add_column :restaurants, :background_type, :string
  end
end
