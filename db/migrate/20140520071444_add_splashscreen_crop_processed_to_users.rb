class AddSplashscreenCropProcessedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :splashscreen_image_processed, :boolean, :default => true
  end
end
