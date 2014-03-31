class CreateWines < ActiveRecord::Migration
  def up
    create_table :wines do |t|
      t.references :user
      
      t.string :year
      t.string :price

      t.timestamps
    end
    Wine.create_translation_table! :title => :string, :type => :string, :country => :string, :description => :string
  end
  
  def down
    drop_table :wines
    Wine.drop_translation_table!
  end
end
