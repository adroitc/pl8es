class CreateDishes < ActiveRecord::Migration
  def up
    create_table :dishes do |t|
      t.references :user
      t.references :navigation
      
      t.references :wines
      t.references :dishes
      
      t.string :price
      
      t.boolean :is_daily, :default => false
      t.date :daily_date
      
      t.timestamps
    end
    Dish.create_translation_table! :title => :string, :drinks => :string, :sidedish => :string, :ingredients => :string
  end
  
  def down
    drop_table :dishes
    Dish.drop_translation_table!
  end
end
