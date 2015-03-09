class DropDailyciousCreditsTables < ActiveRecord::Migration
	def change
		drop_table :dailycious_credits
		drop_table :dailycious_plans
		drop_table :payments
	end
end
