class AddColumnsToRestaurant < ActiveRecord::Migration
  def change
    remove_reference :users, :defaultMenu
    add_reference :restaurants, :defaultMenu

    User.drop_translation_table!
  end
end
