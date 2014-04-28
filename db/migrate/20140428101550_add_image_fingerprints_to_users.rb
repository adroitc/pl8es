class AddImageFingerprintsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :restaurant_image_fingerprint, :string
    add_column :users, :logo_image_fingerprint, :string
    add_column :users, :appmain_image_fingerprint, :string
  end

  def self.down
    remove_column :users, :restaurant_image_fingerprint
    remove_column :users, :logo_image_fingerprint
    remove_column :users, :appmain_image_fingerprint
  end
end
