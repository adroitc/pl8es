class RemoveDailyColumnsFromDishes < ActiveRecord::Migration
  def change
    remove_column :dishes, :is_daily, :boolean
    remove_column :dishes, :daily_date, :date
  end
end
