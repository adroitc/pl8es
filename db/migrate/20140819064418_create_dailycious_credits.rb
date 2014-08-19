class CreateDailyciousCredits < ActiveRecord::Migration
  def change
    create_table :dailycious_credits do |t|
      t.references :restaurant
      t.references :payment
      
      t.timestamps
    end
  end
end
