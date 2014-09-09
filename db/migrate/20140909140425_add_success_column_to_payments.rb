class AddSuccessColumnToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :successful, :boolean, :default => false
  end
end
