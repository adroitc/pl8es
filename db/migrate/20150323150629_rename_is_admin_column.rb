class RenameIsAdminColumn < ActiveRecord::Migration
  def change
	  rename_column :users, :isAdmin, :rank
	  change_column :users, :rank, :string
	  
	  change_column_default :users, :rank, "User"
  end
end
