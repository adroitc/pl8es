class RemoveMenuColorTemplatePreviewImageString < ActiveRecord::Migration
  def change
    remove_column :menu_color_templates, :preview_image, :string
  end
end
