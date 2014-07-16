class AddEmailColumnToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :email, :string
  end
end
