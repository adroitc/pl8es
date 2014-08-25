class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :user
      t.references :dailycious_plan
      
      t.string :paypal_token
      t.string :paypal_payer_id
      
      t.boolean :recurring, :default => false
      t.integer :quantity
      t.decimal :amount
      t.string :description
      
      t.timestamps
    end
  end
end
