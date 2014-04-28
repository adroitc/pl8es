class AddMenuColorReferenceToMenu < ActiveRecord::Migration
  def change
    add_reference :users, :menuColor
    add_reference :menu_colors, :user
  end
end
