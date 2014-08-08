module Paperclip
  class Attachment
    def set_crop_values_for_instance(params)
      img_inst = self.instance
      img_name = self.name.to_s
      img_dims = img_inst.read_attribute("#{img_name}_dimensions")
      img_crop_r = [:w, :h, :x, :y].map{|k|
        [k ,"#{img_name}_crop_#{k.to_s}".to_sym]
      }.to_h
      img_updt = !img_crop_r.values.map{|m| params[m]}.include?(nil)
      img_crop = img_crop_r.keys.map{|k|
        [img_crop_r[k], img_updt ? params[img_crop_r[k]].to_i : img_inst[img_crop_r[k]]]
      }.to_h
      
      if img_updt
        if img_crop[img_crop_r[:w]]+img_crop[img_crop_r[:x]] > img_dims["original"][0]
          img_crop[img_crop_r[:x]] = img_dims["original"][0]-img_crop[img_crop_r[:w]]
        end
        if img_crop[img_crop_r[:h]]+img_crop[img_crop_r[:y]] > img_dims["original"][1]
          img_crop[img_crop_r[:y]] = img_dims["original"][1]-img_crop[img_crop_r[:h]]
        end
      elsif params[img_name.to_sym]
        if img_dims["original"][1] >= img_dims["original"][0]
          img_crop[img_crop_r[:w]] = img_dims["original"].min
          img_crop[img_crop_r[:h]] = img_crop[img_crop_r[:w]]/(img_dims["cropped_default_retina"][0].to_f/img_dims["cropped_default_retina"][1].to_f)
        else
          img_crop[img_crop_r[:h]] = img_dims["original"].min
          img_crop[img_crop_r[:w]] = (img_dims["cropped_default_retina"][0].to_f/img_dims["cropped_default_retina"][1].to_f)*img_crop[img_crop_r[:h]]
        end
        img_crop[img_crop_r[:x]] = (img_dims["original"][0]-img_crop[img_crop_r[:w]]).to_f/2
        img_crop[img_crop_r[:y]] = (img_dims["original"][1]-img_crop[img_crop_r[:h]]).to_f/2
      end
      
      if img_updt || params[img_name.to_sym]
        img_inst.attributes = img_crop
        
        if img_inst.changed?
          img_inst.save
          if img_updt
            
            img_inst.update_attributes({
              "#{img_name}_crop_processed" => false
            })
            img_inst.image.reprocess!
            img_inst.update_attributes({
              "#{img_name}_crop_processed" => true
            })
          end
        end
      end
    end
  end
end