class MoveColorReferencesFromUsersToRestaurants < ActiveRecord::Migration
  def change
    remove_reference :users, :menuColor
    add_reference :restaurants, :menuColor
    
    remove_reference :users, :menuColorTemplate
    add_reference :restaurants, :menuColorTemplate
  end
end
