class ChangeImageDimensionsFieldType < ActiveRecord::Migration
  def change
    change_column :daily_dishes, :image_dimensions, :hash
    change_column :dishes, :image_dimensions, :hash
    change_column :menu_color_templates, :preview_image_dimensions, :hash
    change_column :navigations, :image_dimensions, :hash
    change_column :users, :appmain_image_dimensions, :hash
    change_column :users, :logo_image_dimensions, :hash
    change_column :users, :restaurant_image_dimensions, :hash
    change_column :users, :splashscreen_image_dimensions, :hash
  end
end
