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
    
    def img_should_process
      return @attachment.instance.read_attribute(@attachment.name.to_s+"_should_process")
    end
    
    def img_val(val)
      return @attachment.instance.read_attribute(@attachment.name.to_s+"_"+val)
    end
    
    def crop_command
      target = @attachment.instance
      #puts "crop_command"
      #if target.cropping?
      if img_should_process == true && !img_val("crop_w").blank? && !img_val("crop_h").blank? && !img_val("crop_x").blank? && !img_val("crop_y").blank?
        #" -crop '346x346+0+0'"
        #puts "running crop = -crop '#{target.crop_w.to_i}x#{target.crop_h.to_i}+#{target.crop_x.to_i}+#{target.crop_y.to_i}'"
        #["-crop", "1080x1080+0+0"]
        [" -crop", "#{img_val("crop_w")}x#{img_val("crop_h")}+#{img_val("crop_x")}+#{img_val("crop_y")}"]
        puts '" -crop", "#{img_val("crop_w")}x#{img_val("crop_h")}+#{img_val("crop_x")}+#{img_val("crop_y")}"'
        puts "---------------------------------------------------#{@attachment.instance.class} #{@attachment.instance.id}"
      end
    end
    
  end
  
end