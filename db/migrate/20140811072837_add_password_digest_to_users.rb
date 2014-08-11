class AddPasswordDigestToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_digest, :string
    rename_column :users, :password, :thiswasthekennwort
  end
end
