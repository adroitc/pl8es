class AddAbbreviationColumnToIngredients < ActiveRecord::Migration
  def change
    add_column :ingredients, :abbreviation, :string
  end
end
