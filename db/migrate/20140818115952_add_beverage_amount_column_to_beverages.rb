class AddBeverageAmountColumnToBeverages < ActiveRecord::Migration
  def change
    remove_column :beverages, :beverage_amount_id, :integer
    add_column :beverages, :amount, :string
  end
end
