class CreateSupportedFonts < ActiveRecord::Migration
  def change
    create_table :supported_fonts do |t|
      t.string :title

      t.string :name_navigation
      t.string :size_navigation
      
      t.string :name_heading
      t.string :size_heading
      
      t.string :name_heading_small
      t.string :size_heading_small
      
      t.string :name_description
      t.string :size_description
      
      t.string :name_price
      t.string :size_price
      
      t.string :name_card_tab_title
      t.string :size_card_tab_title
      
      t.timestamps
    end
  end
end
