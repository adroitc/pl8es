class CreateMenuColorTemplates < ActiveRecord::Migration
  def change
    create_table :menu_color_templates do |t|
      t.string :preview_image
      
      t.string :background
      t.string :bar_background
      
      t.string :bev_background#-nav_text
      t.string :bev_background_selected#-bar_background
      t.string :bev_background_active#-bev_background
      t.string :bev_text#-bar_background
      t.string :bev_text_selected#-nav_text
      t.string :bev_text_active#-bev_text

      t.string :nav_background#-transparent
      t.string :nav_background_selected#-transparent
      t.string :nav_background_active#-transparent
      t.string :nav_text
      t.string :nav_text_selected#-nav_text_active
      t.string :nav_text_active
      
      t.string :sub_background#-transparent
      t.string :sub_background_selected#-transparent
      t.string :sub_background_active#-transparent
      t.string :sub_text#-nav_text
      t.string :sub_text_selected#-sub_text_active
      t.string :sub_text_active#-nav_text_active

      t.timestamps
    end
  end
end
