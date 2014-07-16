class RemoveDefaultMenuIdColumnFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :default_menu_id, :string
  end
end
