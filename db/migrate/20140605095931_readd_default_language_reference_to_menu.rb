class ReaddDefaultLanguageReferenceToMenu < ActiveRecord::Migration
  def change
    add_reference :menus, :default_language
  end
end
