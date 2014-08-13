class CreateBeveragePages < ActiveRecord::Migration
  def change
    create_table :beverage_pages do |t|
      t.references :restaurant
      
      t.string :title
      
      t.timestamps
    end
  end
end
