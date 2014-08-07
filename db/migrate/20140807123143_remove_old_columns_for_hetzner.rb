class RemoveOldColumnsForHetzner < ActiveRecord::Migration
  def change
    remove_column :daily_dishes, :old_user_id, :integer
    remove_column :dishes, :old_user_id, :integer
    remove_column :locations, :old_user_id, :integer
    remove_column :menus, :old_user_id, :integer
    remove_column :navigations, :old_user_id, :integer

    remove_column :users, :name, :string
  end
end
