class AddImageFingerprintToNavigations < ActiveRecord::Migration
  def self.up
    add_column :navigations, :image_fingerprint, :string
  end

  def self.down
    remove_column :navigations, :image_fingerprint
  end
end
