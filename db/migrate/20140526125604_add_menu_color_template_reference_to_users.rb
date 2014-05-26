class AddMenuColorTemplateReferenceToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :menuColorTemplate
  end
end
