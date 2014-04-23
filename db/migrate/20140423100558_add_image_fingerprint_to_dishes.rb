class AddImageFingerprintToDishes < ActiveRecord::Migration
  def self.up
    add_column :dishes, :image_fingerprint, :string
  end

  def self.down
    remove_column :dishes, :image_fingerprint
  end
end
