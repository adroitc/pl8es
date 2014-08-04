class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.references :session
      
      t.string :controller
      t.string :action
      t.text :params

      t.timestamps
    end
  end
end
