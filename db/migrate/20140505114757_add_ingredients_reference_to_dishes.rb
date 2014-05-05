class AddIngredientsReferenceToDishes < ActiveRecord::Migration
  def change
    add_reference :dishes, :ingredients
    
		create_table :dishes_ingredients do |t|
			t.belongs_to :dish
			t.belongs_to :ingredient
		end
  end
end
