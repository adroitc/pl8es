class AddRestaurantReferenceToBeveragePages < ActiveRecord::Migration
  def change
    add_reference :beverage_pages, :restaurant
  end
end
