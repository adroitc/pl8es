class AddPositionColumnToBeverageTables < ActiveRecord::Migration
  def change
    add_column :beverage_pages, :position, :integer
    add_column :beverage_navigations, :position, :integer
    add_column :beverages, :position, :integer
  end
end
