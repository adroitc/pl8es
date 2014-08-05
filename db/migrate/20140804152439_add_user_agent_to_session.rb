class AddUserAgentToSession < ActiveRecord::Migration
  def change
    add_column :sessions, :user_agent, :text
  end
end
