class CreateBeverageAmounts < ActiveRecord::Migration
  def up
    create_table :beverage_amounts do |t|

      t.timestamps
    end
    BeverageAmount.create_translation_table! :title => :string
  end
  
  def down
    drop_table :beverage_amounts
    BeverageAmount.drop_translation_table!
  end
end
