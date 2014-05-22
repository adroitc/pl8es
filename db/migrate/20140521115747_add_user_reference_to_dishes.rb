class AddUserReferenceToDishes < ActiveRecord::Migration
  def change
    add_reference :dishes, :user
  end
end
