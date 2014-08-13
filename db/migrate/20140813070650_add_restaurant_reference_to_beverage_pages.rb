class AddRestaurantReferenceToBeveragePages < ActiveRecord::Migration
  def change
    add_reference :beverages, :beverage_navigation
    add_reference :beverages, :beverage_amount
  end
end
