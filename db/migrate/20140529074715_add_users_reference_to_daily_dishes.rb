class AddUsersReferenceToDailyDishes < ActiveRecord::Migration
  def change
    add_reference :daily_dishes, :user
  end
end
