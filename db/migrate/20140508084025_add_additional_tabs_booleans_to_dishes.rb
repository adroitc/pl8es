class AddAdditionalTabsBooleansToDishes < ActiveRecord::Migration
  def change
    add_column :dishes, :wines_should_display, :boolean, :default => false
    add_column :dishes, :dishes_should_display, :boolean, :default => false
    add_column :dishes, :drinks_should_display, :boolean, :default => false
    add_column :dishes, :sides_should_display, :boolean, :default => false
    add_column :dishes, :ingredients_should_display, :boolean, :default => false
  end
end
