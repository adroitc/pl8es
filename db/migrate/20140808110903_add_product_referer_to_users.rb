class AddProductRefererToUsers < ActiveRecord::Migration
  def change
    add_column :users, :product_referer, :string
  end
end
