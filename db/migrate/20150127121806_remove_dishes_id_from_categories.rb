class RemoveDishesIdFromCategories < ActiveRecord::Migration
  def change
	  remove_column :categories, :dishes_id
  end
end
