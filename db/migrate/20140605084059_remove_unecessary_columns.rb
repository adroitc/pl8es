class RemoveUnecessaryColumns < ActiveRecord::Migration
  def change
    remove_reference :categories, :menu 
    remove_reference :ingredients, :dish 
    
    remove_reference :menus, :menuLabel
    remove_reference :menus, :navigations
    remove_reference :menus, :beverages
    remove_reference :menus, :languages
    remove_reference :menus, :default_language
    remove_reference :menus, :menuColor
    
    remove_reference :navigations, :sub_navigations
    
    remove_reference :users, :languages
    remove_reference :users, :categories
    remove_reference :users, :openingHours
    remove_reference :users, :menus
    remove_reference :users, :daily_dishes
    
    remove_column :dishes, :wines_should_display, :boolean
    remove_column :dishes, :dishes_should_display, :boolean
    remove_column :dishes, :drinks_should_display, :boolean
    remove_column :dishes, :sides_should_display, :boolean
    remove_column :dishes, :ingredients_should_display, :boolean
  end
end
