class CreateBeverageNavigations < ActiveRecord::Migration
  def up
    create_table :beverage_navigations do |t|
      t.references :beverage_page
      
      t.timestamps
    end
    BeverageNavigation.create_translation_table! :title => :string
  end
  
  def down
    drop_table :beverage_navigations
    BeverageNavigation.drop_translation_table!
  end
end
