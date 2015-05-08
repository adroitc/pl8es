class RemoveRepeatColumnFromOffers < ActiveRecord::Migration
  def change
	  remove_column :offers, :repeat
  end
end
