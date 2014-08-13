class AddRestaurantReferenceToBeveragePages < ActiveRecord::Migration
  def change
    add_reference :beverage_navigations, :beveragePage
    add_reference :beverages, :beverageNavigation
    add_reference :beverages, :beverageAmount
  end
end
