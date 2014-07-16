class ReplaceUserReferencesWithRestaurant < ActiveRecord::Migration
  def change
    remove_reference :daily_dishes, :user
    add_reference :daily_dishes, :restaurant

    remove_reference :dishes, :user
    add_reference :dishes, :restaurant

    drop_table :languages_users
    User.drop_translation_table!

    remove_reference :locations, :user
    add_reference :locations, :restaurant

    remove_reference :menu_colors, :user
    add_reference :menu_colors, :restaurant

    drop_table :menu_labels
    #MenuLabel.drop_translation_table!

    remove_reference :menus, :user
    add_reference :menus, :restaurant
  end
end
