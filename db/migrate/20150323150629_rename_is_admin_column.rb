class RenameIsAdminColumn < ActiveRecord::Migration
  def change
	  rename_column :users, :isAdmin, :type
	  change_column :users, :type, :string
	  
	  change_column_default :users, :type, "User"
  end
end
