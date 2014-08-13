class AddImageToBeveragePage < ActiveRecord::Migration
  def change
    add_attachment :beverage_pages, :image
    add_column :beverage_pages, :image_fingerprint, :string
    add_column :beverage_pages, :image_crop_w, :integer
    add_column :beverage_pages, :image_crop_h, :integer
    add_column :beverage_pages, :image_crop_x, :integer
    add_column :beverage_pages, :image_crop_y, :integer
    add_column :beverage_pages, :image_crop_processed, :boolean, :default => true
  end
end
