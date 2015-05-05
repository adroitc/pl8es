class DropDailyDishTable < ActiveRecord::Migration
	def change
		drop_table :daily_dishes
	end
end
