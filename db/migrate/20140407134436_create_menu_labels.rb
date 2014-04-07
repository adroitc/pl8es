class CreateMenuLabels < ActiveRecord::Migration
  def up
    create_table :menu_labels do |t|
      t.string :color
      
      t.timestamps
    end
    MenuLabel.create_translation_table! :title => :string
  end
  
  def down
    drop_table :menu_labels
    MenuLabel.drop_translation_table!
  end
end
