class CreateLunchMenus < ActiveRecord::Migration
  def change
    create_table :lunch_menus do |t|
      t.references :dish, index: true, foreign_key: true
      t.references :restaurant, index: true, foreign_key: true
      t.date :date
      t.decimal :price
      t.integer :position

      t.timestamps null: false
    end
  end
end
