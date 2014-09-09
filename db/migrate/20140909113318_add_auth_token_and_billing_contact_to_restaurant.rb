class AddAuthTokenAndBillingContactToRestaurant < ActiveRecord::Migration
  def change
    add_column :users, :reset_token, :string
    add_column :users, :reset_date, :datetime

    add_column :restaurants, :billing_contact, :string
  end
end
