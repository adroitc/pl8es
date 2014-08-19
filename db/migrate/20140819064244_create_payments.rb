class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :user
      t.references :dailycious_plan
      
      t.timestamps
    end
  end
end
