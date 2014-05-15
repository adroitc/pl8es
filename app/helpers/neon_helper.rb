module NeonHelper
  
  def neon_modal(opts={},&block)
    if opts[:width]
      width = "width:#{opts[:width]};"
    end
    if opts[:languages]
      output_languages = raw %(
      <ul class="nav nav-tabs" style="margin-top:-10px;">
      )
      opts[:languages].each do |language|
        output_languages += raw %(
  			<li class="#{"active" if language == opts[:default_language]}">
          <a href="#modal-#{opts[:id]}-lang-#{language.locale}" data-toggle="tab">
            #{language.title.capitalize}#{" (Default)" if language == opts[:default_language]}
  				</a>
  			</li>
        )
      end
      output_languages += raw %(
      </ul>
      )
    end
    raw %(
    <div class="modal fade in" id="modal-#{opts[:id]}">
    	<div class="modal-dialog" style="#{width}">
    		<div class="modal-content">
    			 <div class="modal-header">
    			 	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
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
    raw %(
		<div class="form-group fileinput fileinput-new" data-provides="fileinput">
			<span class="btn btn-info btn-file">
				<span class="fileinput-new">#{opts[:different] ? t("neon.image_input_select_different") : t("neon.image_input_select")}</span>
				<span class="fileinput-exists">#{t("neon.image_input_change")}</span>
				<input type="file" name="#{opts[:name].to_s}" accept="image/*" data-imgvalidation="#{opts[:instance_class].img_min_dimensions()[opts[:name]].join("x") if opts[:instance_class]}">
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
      output = raw %(
      <div class="thumbnail" style="width:auto;height:auto;" data-trigger="fileinput">
      	<img id="navigation-image-#{instance.id}" src="#{image.url(:original_cropping)}">
      </div>
      <input name="image_crop_w" type="hidden" id="form-cropimage-#{instance.id}-image_crop_w">
      <input name="image_crop_h" type="hidden" id="form-cropimage-#{instance.id}-image_crop_h">
      <input name="image_crop_x" type="hidden" id="form-cropimage-#{instance.id}-image_crop_x">
      <input name="image_crop_y" type="hidden" id="form-cropimage-#{instance.id}-image_crop_y">
      <script type="text/javascript">
        $("#navigation-image-#{instance.id}").Jcrop({
          aspectRatio: #{instance.class.img_min_dimensions[image.name][0].to_f/instance.class.img_min_dimensions[image.name][1].to_f},
          onSelect: updateCoords,
          trueSize: [#{instance.read_attribute(image.name.to_s+"_dimensions")["original"][0]},#{instance.read_attribute(image.name.to_s+"_dimensions")["original"][1]}],
          setSelect: [#{instance.read_attribute(image.name.to_s+"_crop_x")}, #{instance.read_attribute(image.name.to_s+"_crop_y")}, #{instance.read_attribute(image.name.to_s+"_crop_x")}+#{instance.read_attribute(image.name.to_s+"_crop_w")}, #{instance.read_attribute(image.name.to_s+"_crop_y")}+#{instance.read_attribute(image.name.to_s+"_crop_h")}],
          minSize: [#{instance.class.img_min_dimensions[image.name][0]},#{instance.class.img_min_dimensions[image.name][1]}]
        });
        function updateCoords(c)
        {
        	$("#form-cropimage-#{opts[:image].instance.id}-image_crop_w").val(Math.min(#{instance.read_attribute(image.name.to_s+"_dimensions")["original"][0]},Math.floor(c.w)));
        	$("#form-cropimage-#{opts[:image].instance.id}-image_crop_h").val(Math.min(#{instance.read_attribute(image.name.to_s+"_dimensions")["original"][1]},Math.floor(c.h)));
        	$("#form-cropimage-#{opts[:image].instance.id}-image_crop_x").val(Math.floor(c.x));
        	$("#form-cropimage-#{opts[:image].instance.id}-image_crop_y").val(Math.floor(c.y));
        };
      </script>
      )+output
    end
    
    output
  end
  
  def neon_panel_withfooter(opts={},&block)
    raw %(
    <div class="col-sm-#{opts[:size]}" style="margin-bottom:17px;">
      <div class="panel panel-primary" data-collapsed="0" style="margin-bottom:0px;">
       	<div class="panel-body" style="margin:0px;padding:0px;">
        	<article class="album" style="margin-bottom:0px;border-width:0px;">
        		<header>
              <a href="#{opts[:action_url]}">
                <img src="#{opts[:image_url]}" />
        			</a>
        		</header>
           	<div class="panel-heading">
              <input type="hidden" name="#{opts[:sort_key]}" value="">
           		<div class="panel-title ellipsis">
                #{opts[:title]}
              </div>
           	</div>
        		<footer>
            #{capture(&block)}
        		</footer>
        	</article>
       	</div>
      </div>
    </div>
    )
  end
  
  def neon_navigationpanel(opts={},&block)
    sub_navigations = raw %(
		<div class="album-images-count" style="padding-left:10px;padding-right:10px;">
			#{opts[:navigation].sub_navigations.count}
			<i class="entypo-folder"></i>
		</div>
    )
    dishes = raw %(
		<div class="album-images-count" style="padding-left:10px;padding-right:10px;">
			#{opts[:navigation].dishes.count}
			<i class="glyphicon glyphicon-cutlery"></i>
		</div>
    )
    neon_panel_withfooter(
      :size => "3",
      :sort_key => "navigation_ids[#{opts[:navigation].id}]",
      :title => opts[:navigation].title,
      :action_url => url_for(
        :controller => "menumalist", :action => "category",
        :menu_title => opts[:navigation].menu.title.gsub(" ","-"),
        :menu_id => opts[:navigation].menu.id,
        :navigation_title => opts[:navigation].title.gsub(" ","-"),
        :navigation_id => opts[:navigation].id
      ),
      :image_url => opts[:navigation].image.present? ? opts[:navigation].image.url(:cropped_default) : "http://placehold.it/828x552") {|p|
        raw %(#{sub_navigations if opts[:navigation].level == 0 && opts[:navigation].dishes.count == 0}
          #{dishes if opts[:navigation].sub_navigations.count == 0}
        	<div class="album-options">
        	  <a href="javascript:;" onclick="jQuery('#modal-editnavigation-#{opts[:navigation].id}').modal('show');">
        	  	<i class="entypo-cog"></i>
        	  </a>
        	</div>)}
  end
  
  def neon_dishpanel(opts={},&block)
    neon_panel_withfooter(
      :size => "3",
      :sort_key => "dish_ids[#{opts[:dish].id}]",
      :title => opts[:dish].title,
      :image_url => opts[:dish].image.present? ? opts[:dish].image.url(:cropped_default) : "http://placehold.it/1680x1120") {|p|
        raw %(<div class="album-options">
        	  <a href="javascript:;" onclick="jQuery('#modal-editdish-#{opts[:dish].id}').modal('show');">
        	  	<i class="entypo-cog"></i>
        	  </a>
        	</div>)}
  end
  
end
