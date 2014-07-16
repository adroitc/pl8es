class AddOldUserIdColumn < ActiveRecord::Migration
  def change
    add_column :locations, :old_user_id, :integer
    add_column :menus, :old_user_id, :integer
    add_column :navigations, :old_user_id, :integer
    add_column :dishes, :old_user_id, :integer
    add_column :daily_dishes, :old_user_id, :integer
  end
end
