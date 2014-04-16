class CreateNavigations < ActiveRecord::Migration
  def up
    create_table :navigations do |t|
      t.references :menu
      t.references :navigation
      
      t.integer :level
      t.references :sub_navigations
      
      t.references :dishes
      
      t.timestamps
    end
    Navigation.create_translation_table! :title => :string
  end
  
  def down
    drop_table :navigations
    Navigation.drop_translation_table!
  end
end
