class CreateDailyDishes < ActiveRecord::Migration
  def change
    create_table :daily_dishes do |t|
      t.string :title
      t.string :price
      t.datetime :display_date

      t.timestamps
    end
  end
end
