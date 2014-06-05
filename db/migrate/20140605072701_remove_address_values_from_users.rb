class RemoveAddressValuesFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :address, :string
    remove_column :users, :zip, :string
    remove_column :users, :city, :string
    remove_column :users, :country, :string
  end
end
