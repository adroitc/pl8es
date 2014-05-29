class AddImageToDailyDishes < ActiveRecord::Migration
  def self.up
    add_attachment :daily_dishes, :image
  end

  def self.down
    remove_attachment :daily_dishes, :image
  end
end
