module Paperclip
  
  class Cropper < Thumbnail
    
    def transformation_command
      puts "transformation_command"
      if crop_command
        crop_command + super.join(' ').sub(/ -crop \S+/, '').split(' ')
      else
        super
      end
    end
    
    def img_crop_processed
      #puts "---------------------------------------------------should_process = #{@attachment.name.to_s+"_crop_processed"}-#{@attachment.instance.class}-#{@attachment.instance.id}-#{@attachment.instance.read_attribute(@attachment.name.to_s+"_crop_processed")}"
      #return @attachment.instance.read_attribute(@attachment.name.to_s+"_should_process")
      return @attachment.instance.read_attribute(@attachment.name.to_s+"_crop_processed")
    end
    
    def img_val(val)
      return @attachment.instance.read_attribute(@attachment.name.to_s+"_"+val)
    end
    
    def crop_command
      #target = @attachment.instance
      #puts "---------------------------------------------------crop_command"
      #if target.cropping?
      #puts "---------------------------------------------------#{img_crop_processed}-#{img_val("crop_w")}x#{img_val("crop_h")}+#{img_val("crop_x")}+#{img_val("crop_y")}"
      if img_crop_processed == false && !img_val("crop_w").blank? && !img_val("crop_h").blank? && !img_val("crop_x").blank? && !img_val("crop_y").blank?
        #" -crop '346x346+0+0'"
        #puts "running crop = -crop '#{target.crop_w.to_i}x#{target.crop_h.to_i}+#{target.crop_x.to_i}+#{target.crop_y.to_i}'"
        #["-crop", "1080x1080+0+0"]
        #puts "---------------------------------------------------#{@attachment.instance.class}-#{@attachment.instance.id}"
        [" -crop", "#{img_val("crop_w")}x#{img_val("crop_h")}+#{img_val("crop_x")}+#{img_val("crop_y")}"]
      end
    end
    
  end
  
end