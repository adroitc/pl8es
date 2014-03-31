class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :title
      t.string :locale
      
      t.timestamps
    end
		
		create_table :languages_users do |t|
			t.belongs_to :language
			t.belongs_to :user
		end
  end
end
