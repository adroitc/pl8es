class AddPositionColumnToNavigations < ActiveRecord::Migration
  def change
    add_column :navigations, :position, :integer
  end
end
