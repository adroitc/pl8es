class AddClientResetDateToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :client_reset_date, :datetime
  end
end
