class AddFontsReferenceToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :supportedFont
  end
end
