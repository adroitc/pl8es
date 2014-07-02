class AddPositionColumnToDailyDishes < ActiveRecord::Migration
  def change
    add_column :daily_dishes, :position, :integer
  end
end
