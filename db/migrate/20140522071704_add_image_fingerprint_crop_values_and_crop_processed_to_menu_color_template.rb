class AddImageFingerprintCropValuesAndCropProcessedToMenuColorTemplate < ActiveRecord::Migration
  def change
    add_column :menu_color_templates, :preview_image_fingerprint, :string
    
    add_column :menu_color_templates, :preview_image_crop_w, :integer
    add_column :menu_color_templates, :preview_image_crop_h, :integer
    add_column :menu_color_templates, :preview_image_crop_x, :integer
    add_column :menu_color_templates, :preview_image_crop_y, :integer
    
    add_column :menu_color_templates, :preview_image_processed, :boolean, :default => true
  end
end
