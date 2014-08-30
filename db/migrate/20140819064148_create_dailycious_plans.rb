class CreateDailyciousPlans < ActiveRecord::Migration
  def change
    create_table :dailycious_plans do |t|
      t.references :restaurant
      
      t.string :paypal_profile_id
      t.string :paypal_profile_status
      
      t.boolean :activated, :default => false
      t.date :setup_date
      
      t.timestamps
    end
  end
end
