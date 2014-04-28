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

      t.string :menu_tariff
      t.string :daily_tariff
      
      t.string :download_code
      
      t.date :last_login
      
      t.references :languages
      t.references :default_language
      
      t.references :openingHours
      
      t.references :categories
      
      t.references :default_menu
      t.references :menus
      
      t.references :daily_dishes
      
      t.timestamps
    end
    
		create_table :languages_users do |t|
			t.belongs_to :language
			t.belongs_to :user
		end
    User.create_translation_table! :description => :string
  end
  
  def down
    drop_table :users
    drop_table :languages_users
    User.drop_translation_table!
  end
end
