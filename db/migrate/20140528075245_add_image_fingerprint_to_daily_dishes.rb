class AddImageFingerprintToDailyDishes < ActiveRecord::Migration
  def self.up
    add_column :daily_dishes, :image_fingerprint, :string
  end

  def self.down
    remove_column :daily_dishes, :image_fingerprint
  end
end
