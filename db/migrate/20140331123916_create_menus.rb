class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.string :title
      t.string :label
      t.string :from_time
      
      t.references :navigations
      t.references :beverages
      
      t.references :languages
      t.references :default_language
      
      t.references :menuColor
      
      t.timestamps
    end
    
		create_table :languages_menus do |t|
			t.belongs_to :language
			t.belongs_to :menu
		end
  end
end
