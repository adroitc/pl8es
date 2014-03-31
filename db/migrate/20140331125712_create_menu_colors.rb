class CreateMenuColors < ActiveRecord::Migration
  def change
    create_table :menu_colors do |t|
      t.string :background
      t.string :bar_background
      
      t.string :bev_background_selected
      t.string :bev_text
      t.string :bev_text_active
      t.string :bev_background
      t.string :bev_background_active
      t.string :bev_text_selected

      t.string :nav_background
      t.string :nav_background_active
      t.string :nav_background_selected
      t.string :nav_text
      t.string :nav_text_active
      t.string :nav_text_selected
      
      t.string :sub_background
      t.string :sub_background_active
      t.string :sub_background_selected
      t.string :sub_text
      t.string :sub_text_active
      t.string :sub_text_selected
      
      t.timestamps
    end
  end
end
