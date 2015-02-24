class DropWineModel < ActiveRecord::Migration
	def change
		drop_table :wines
	end
end
