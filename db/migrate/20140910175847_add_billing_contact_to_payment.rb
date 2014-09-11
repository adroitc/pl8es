class AddBillingContactToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :billing_contact, :string
  end
end
