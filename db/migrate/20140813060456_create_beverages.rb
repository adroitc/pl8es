class CreateBeverages < ActiveRecord::Migration
  def up
    create_table :beverages do |t|
      
      t.string :price

      t.timestamps
    end
    Beverage.create_translation_table! :title => :string
  end
  
  def down
    drop_table :beverages
    Beverage.drop_translation_table!
  end
end
