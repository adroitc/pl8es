class AddDefaultLanguageReferenceToRestaurants < ActiveRecord::Migration
  def change
    remove_reference :users, :default_language
    add_reference :restaurants, :default_language
  end
end
