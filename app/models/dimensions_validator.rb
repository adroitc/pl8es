class DimensionsValidator < ActiveModel::EachValidator
  
  def validate_each(record, attribute, value)
    if value.queued_for_write[:original]
      dimensions = Paperclip::Geometry.from_file(value.queued_for_write[:original].path)
      width = options[:width]
      height = options[:height]
      
      #puts "width----------------------------------------"+dimensions.width.to_s+"----"+width.to_s
      
      record.errors[attribute] << "Width must be #{width}px" unless dimensions.width >= width
      record.errors[attribute] << "Height must be #{height}px" unless dimensions.height >= height
    end
  end
  
end