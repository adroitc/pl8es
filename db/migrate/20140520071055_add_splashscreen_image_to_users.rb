class AddSplashscreenImageToUsers < ActiveRecord::Migration
  def self.up
    add_attachment :users, :splashscreen_image
  end

  def self.down
    remove_attachment :users, :splashscreen_image
  end
end
