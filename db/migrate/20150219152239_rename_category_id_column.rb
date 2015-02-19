class RenameCategoryIdColumn < ActiveRecord::Migration
  def change
	  rename_column :categories, :category_id, :parent_id
  end
end
