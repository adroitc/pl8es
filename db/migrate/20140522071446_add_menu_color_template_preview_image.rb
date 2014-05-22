class AddMenuColorTemplatePreviewImage < ActiveRecord::Migration
  def self.up
    add_attachment :menu_color_templates, :preview_image
  end

  def self.down
    remove_attachment :menu_color_templates, :preview_image
  end
end
