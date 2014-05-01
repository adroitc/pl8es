class CreateDishes < ActiveRecord::Migration
  def up
    create_table :dishes do |t|
      t.references :menu
      t.references :navigation
      
      t.references :wines
      t.references :dishsuggestion_1
      t.references :dishsuggestion_2
      
      t.string :price
      
      t.boolean :is_daily, :default => false
      t.date :daily_date
      
      t.timestamps
    end
    Dish.create_translation_table! :title => :string, :description => :string, :drinks => :string, :sidedish => :string, :ingredients => :string
  end
  
  def down
    drop_table :dishes
    Dish.drop_translation_table!
  end
end
