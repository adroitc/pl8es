class CreateDailyciousCredits < ActiveRecord::Migration
  def change
    create_table :dailycious_credits do |t|
      t.references :restaurant
      t.references :payment
      
      t.date :usage_date
      
      t.timestamps
    end
  end
end
