class RemoveOldColumnsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :menu_tariff, :string
    remove_column :users, :daily_tariff, :string
    remove_column :users, :download_code, :string
    remove_column :users, :register_source, :string
    remove_column :users, :telephone, :string
    remove_column :users, :website, :string
    
    remove_reference :users, :supportedFont
    add_reference :restaurants, :supportedFont

    drop_table :opening_hours
  end
end
