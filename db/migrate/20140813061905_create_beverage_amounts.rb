class CreateBeverageAmounts < ActiveRecord::Migration
  def change
    create_table :beverage_amounts do |t|

      t.timestamps
    end
  end
end
