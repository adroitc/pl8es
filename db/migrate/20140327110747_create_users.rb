class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :name
      
      t.string :email
      t.string :password
      
      t.string :first_name
      t.string :last_name
      
      t.string :address
      t.string :zip
      t.string :city
      t.string :country
      
      t.string :telephone
      t.string :website
      
      t.string :register_source
      
      t.string :tarif
      
      t.string :download_code
      
      t.date :last_login
      
      t.references :languages
      t.references :default_language
      
      t.references :openingHours
      
      t.references :categories
      
      t.timestamps
    end
    User.create_translation_table! :description => :string
  end
  
  def down
    drop_table :users
    User.drop_translation_table!
  end
end
