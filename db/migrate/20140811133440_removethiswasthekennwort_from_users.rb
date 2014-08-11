class RemovethiswasthekennwortFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :thiswasthekennwort
  end
end
