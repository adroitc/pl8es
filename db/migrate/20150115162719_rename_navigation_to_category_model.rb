class RenameNavigationToCategoryModel < ActiveRecord::Migration
	def change
		rename_column :dishes, :navigation_id, :category_id
		rename_column :navigations, :navigation_id, :category_id
		
		rename_table :navigations, :categories
		
		rename_column :navigation_translations, :navigation_id, :category_id
		rename_table :navigation_translations, :category_translations
	end
end
