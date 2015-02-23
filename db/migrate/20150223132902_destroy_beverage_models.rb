class DestroyBeverageModels < ActiveRecord::Migration
  def change
	  drop_table :beverage_navigations
	  drop_table :beverage_pages
  end
end
