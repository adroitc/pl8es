class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.references :dish, index: true, foreign_key: true
      t.string :every
      t.text :on
      t.integer :interval
      t.integer :repeat
      t.date :start_date
      t.date :end_date, default: '2037-12-31'
      t.text :except

      t.timestamps null: false
    end
  end
end
