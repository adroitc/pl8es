class AddImagesToUsers < ActiveRecord::Migration
  def self.up
    add_attachment :users, :restaurant_image
    add_attachment :users, :logo_image
    add_attachment :users, :appmain_image
  end

  def self.down
    remove_attachment :users, :restaurant_image
    remove_attachment :users, :logo_image
    remove_attachment :users, :appmain_image
  end
end
