class AddImageToNavigations < ActiveRecord::Migration
  def self.up
    add_attachment :navigations, :image
  end

  def self.down
    remove_attachment :navigations, :image
  end
end
