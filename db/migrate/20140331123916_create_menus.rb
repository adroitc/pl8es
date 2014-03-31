class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.string :title
      t.string :label
      
      t.references :navigations
      t.references :beverages
      
      t.references :languages
      
      t.references :menuColor
      
      t.timestamps
    end
  end
end
