class CreateNavigations < ActiveRecord::Migration
  def up
    create_table :navigations do |t|
      t.references :menu
      t.references :navigation
      
      t.integer :level
      t.string :style
      t.references :sub_navigations
      
      t.references :dishes
      
      t.timestamps
    end
    
    create_table :navigation_translations do |t|
      t.references :navigation, null: false
      t.string :locale, null: false
      t.timestamps
      t.string :title
    end
    
    add_index :navigation_translations, :locale
    add_index :navigation_translations, :navigation_id
  end
  
  def down
    drop_table :navigations
    Navigation.drop_translation_table!
  end
end
