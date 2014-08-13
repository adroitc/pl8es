class CreateBeveragePages < ActiveRecord::Migration
  def change
    create_table :beverage_pages do |t|
      t.string :title
      
      t.timestamps
    end
  end
end
