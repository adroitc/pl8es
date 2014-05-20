class AddBackgroundTypeStringToUsers < ActiveRecord::Migration
  def change
    add_column :users, :background_type, :string
  end
end
