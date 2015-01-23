class RemoveDefaultLanguageIdColumnFromMenus < ActiveRecord::Migration
	def change
		remove_column :menus, :default_language_id
	end
end
