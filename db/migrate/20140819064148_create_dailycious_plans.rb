class CreateDailyciousPlans < ActiveRecord::Migration
  def change
    create_table :dailycious_plans do |t|
      t.references :restaurant
      
      t.timestamps
    end
  end
end
