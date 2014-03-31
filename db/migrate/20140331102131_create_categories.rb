class CreateCategories < ActiveRecord::Migration
  def up
    create_table :categories do |t|
      
      t.timestamps
    end
    Category.create_translation_table! :title => :string
		create_table :categories_users do |t|
			t.belongs_to :category
			t.belongs_to :user
		end
  end
  
  def down
    drop_table :categories
    Category.drop_translation_table!
  end
end
