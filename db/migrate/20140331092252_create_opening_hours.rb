class CreateOpeningHours < ActiveRecord::Migration
  def change
    create_table :opening_hours do |t|
      t.integer :weekday
      t.string :a_from
      t.string :a_to
      t.string :b_from
      t.string :b_to
      
      t.references :user
      
      t.timestamps
    end
  end
end
