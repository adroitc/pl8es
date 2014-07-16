class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.references :user
      
      t.string :name
      
      t.string :telephone
      t.string :website

      t.string :download_code

      t.timestamps
    end
  end
end
