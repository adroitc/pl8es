class CreateIngredients < ActiveRecord::Migration
  def up
    create_table :ingredients do |t|
      t.references :dish

      t.timestamps
    end
    Ingredient.create_translation_table! :title => :string
  end
  
  def down
    drop_table :ingredients
    Ingredient.drop_translation_table!
  end
end
