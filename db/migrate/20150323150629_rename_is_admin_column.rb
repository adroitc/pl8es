class RenameIsAdminColumn < ActiveRecord::Migration
  def change
	  rename_column :users, :isAdmin, :rank
	  change_column :users, :rank, :string
  end
end
