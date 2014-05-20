class AddSplashscreenFingerprintToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :splashscreen_image_fingerprint, :string
  end

  def self.down
    remove_column :users, :splashscreen_image_fingerprint
  end
end
