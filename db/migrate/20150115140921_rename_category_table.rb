class RenameCategoryTable < ActiveRecord::Migration
	def change
		drop_table :category_translations
		rename_table :categories, :tags
		
		Tag.create_translation_table! :title => :string
		create_table :tags_users do |t|
			t.belongs_to :tag
			t.belongs_to :user
		end
		
		rename_column :categories_restaurants, :category_id, :tag_id
		rename_table :categories_restaurants, :restaurants_tags
	end
end
