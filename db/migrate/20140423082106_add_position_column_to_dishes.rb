class AddPositionColumnToDishes < ActiveRecord::Migration
  def change
    add_column :dishes, :position, :integer
  end
end
