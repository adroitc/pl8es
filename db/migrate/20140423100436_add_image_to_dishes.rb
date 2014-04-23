class AddImageToDishes < ActiveRecord::Migration
  def self.up
    add_attachment :dishes, :image
  end

  def self.down
    remove_attachment :dishes, :image
  end
end
