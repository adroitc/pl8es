class ChangeLastLoginColumnTypeToDatetime < ActiveRecord::Migration
  def change
    change_column :users, :last_login, :datetime
  end
end
