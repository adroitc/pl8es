module NeonHelper
  
  def neon_modal(opts={},&block)
    if opts[:width]
      width = "width:#{opts[:width]};"
    end
    if opts[:languages]
      opts[:languages] = opts[:languages].sort_by {|k| k[:id]}
      output_languages = raw %(
      <ul class="nav nav-tabs" style="margin-top:-10px;">
      )
      opts[:languages].each do |language|
        set_active = (language == opts[:default_language]) || (opts[:default_language] == nil && language == opts[:languages].first)
        output_languages += raw %(
  			<li class="#{"active" if set_active}">
          <a href="#modal-#{opts[:id]}-lang-#{language.locale}" data-toggle="tab">
            #{language.title.capitalize}#{" (#{t("language.default")})" if language == opts[:default_language]}
  				</a>
  			</li>
        )
      end
      output_languages += raw %(
      </ul>
      )
    end
    raw %(
    <div class="modal in" id="modal-#{opts[:id]}">
    	<div class="modal-dialog" style="margin-bottom:20px;#{width}">
    		<div class="modal-content">
    			<div class="modal-header">
    			 	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
    			 	<h4 class="modal-title" style="display:inline-block;">#{opts[:title]}</h4>
        		#{output_languages}
    			</div>
    			#{capture(&block)}
    		</div>
    	</div>
    </div>
    )
  end
  
  def neon_modal_body(opts={},&block)
    raw %(
    <div class="modal-body">
    #{capture(&block)}
    </div>
    )
  end
  
  def neon_modal_footer(opts={},&block)
    raw %(
    <div class="modal-footer">
    #{capture(&block)}
    </div>
    )
  end
  
  def neon_imageinput(opts={},&block)
    if opts[:instance_class]
      image_min_size = opts[:instance_class].validators_on(opts[:name])[opts[:instance_class].validators_on(opts[:name]).index{|v| v.class.to_s == "DimensionsValidator"}].options
    end
    raw %(
		<div class="form-group fileinput fileinput-new" data-provides="fileinput">
			<span class="btn btn-info btn-file">
				<span class="fileinput-new">#{opts[:different] ? t("neon.image_input_select_different") : t("neon.image_input_select")}</span>
				<span class="fileinput-exists">#{t("neon.image_input_change")}</span>
				<input type="file" name="#{opts[:name].to_s}" accept="image/*" data-validate="filedimension" data-imgvalidation="#{image_min_size[:width].to_s+"x"+image_min_size[:height].to_s if opts[:instance_class]}" #{"-required" if !opts[:different]}>
			</span>
			<span class="fileinput-filename"></span>
			<a href="#" class="close fileinput-exists" data-dismiss="fileinput" style="float: none">&times;</a>
		</div>
    )
  end
  
  def neon_imagecrop(opts={},&block)
    image = opts[:image]
    instance = image.instance
    
    output = neon_imageinput :instance_class => instance.class, :name => image.name, :different => image.present?
    if opts[:image].present?
      image_min_size = instance.class.validators_on(image.name)[instance.class.validators_on(image.name).index{|v| v.class.to_s == "DimensionsValidator"}].options
      output = raw %(
      <div class="thumbnail" style="width:auto;height:auto;" data-trigger="fileinput">
      	<img id="navigation-#{image.name.to_s}-#{instance.id}" src="#{image.url(:original_cropping)}">
      </div>
      <input name="#{image.name.to_s}_crop_w" type="hidden" id="form-cropimage-#{instance.id}-#{image.name.to_s}_crop_w">
      <input name="#{image.name.to_s}_crop_h" type="hidden" id="form-cropimage-#{instance.id}-#{image.name.to_s}_crop_h">
      <input name="#{image.name.to_s}_crop_x" type="hidden" id="form-cropimage-#{instance.id}-#{image.name.to_s}_crop_x">
      <input name="#{image.name.to_s}_crop_y" type="hidden" id="form-cropimage-#{instance.id}-#{image.name.to_s}_crop_y">
      <script type="text/javascript">
        $("#navigation-#{image.name.to_s}-#{instance.id}").jcrop_old({
          aspectRatio: #{image_min_size[:width].to_f/image_min_size[:height].to_f},
          onSelect: updateCoords,
          trueSize: [#{instance.read_attribute(image.name.to_s+"_dimensions")["original"][0]},#{instance.read_attribute(image.name.to_s+"_dimensions")["original"][1]}],
          setSelect: [#{instance.read_attribute(image.name.to_s+"_crop_x")}, #{instance.read_attribute(image.name.to_s+"_crop_y")}, #{instance.read_attribute(image.name.to_s+"_crop_x")}+#{instance.read_attribute(image.name.to_s+"_crop_w")}, #{instance.read_attribute(image.name.to_s+"_crop_y")}+#{instance.read_attribute(image.name.to_s+"_crop_h")}],
          minSize: [#{image_min_size[:width]},#{image_min_size[:height]}]
        });
        function updateCoords(c)
        { 	$("#form-cropimage-#{opts[:image].instance.id}-#{image.name.to_s}_crop_w").val(Math.min(#{instance.read_attribute(image.name.to_s+"_dimensions")["original"][0]},Math.floor(c.w)));
        	$("#form-cropimage-#{opts[:image].instance.id}-#{image.name.to_s}_crop_h").val(Math.min(#{instance.read_attribute(image.name.to_s+"_dimensions")["original"][1]},Math.floor(c.h)));
        	$("#form-cropimage-#{opts[:image].instance.id}-#{image.name.to_s}_crop_x").val(Math.floor(c.x));
        	$("#form-cropimage-#{opts[:image].instance.id}-#{image.name.to_s}_crop_y").val(Math.floor(c.y));
        };
      </script>
      )+output
    end
    
    output
  end
  
end
