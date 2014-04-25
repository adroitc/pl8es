module NeonHelper
  
  def neon_modal(opts={},&block)
    if opts[:width]
      width = "width:#{opts[:width]};"
    end
    raw %(
    <div class="modal fade in" id="modal-#{opts[:id]}">
    	<div class="modal-dialog" style="#{width}">
    		<div class="modal-content">
    			 <div class="modal-header">
    			 	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    			 	<h4 class="modal-title">#{opts[:title]}</h4>
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
		<div class="fileinput fileinput-new" data-provides="fileinput">
			<span class="btn btn-info btn-file">
				<span class="fileinput-new">Select #{"different " if opts[:different] == true}image</span>
				<span class="fileinput-exists">Change</span>
				<input type="file" name="#{opts[:name]}">
			</span>
			<span class="fileinput-filename"></span>
			<a href="#" class="close fileinput-exists" data-dismiss="fileinput" style="float: none">&times;</a>
		</div>
    )
  end
  
  def neon_imagecrop(opts={},&block)
    image = opts[:image]
    instance = image.instance
    
    output = neon_imageinput :name => opts[:image].name, :different => opts[:image].present?
    if opts[:image].present?
      output = raw %(
  		<div class="thumbnail" style="width:100%;height:auto;" data-trigger="fileinput">
  			<img id="navigation-image-#{instance.id}" src="#{image.url(:crop)}">
  		</div>
      <input name="image_crop_w" type="hidden" id="form-modal-editdish-#{instance.id}-image_crop_w">
      <input name="image_crop_h" type="hidden" id="form-modal-editdish-#{instance.id}-image_crop_h">
      <input name="image_crop_x" type="hidden" id="form-modal-editdish-#{instance.id}-image_crop_x">
      <input name="image_crop_y" type="hidden" id="form-modal-editdish-#{instance.id}-image_crop_y">
      <script type="text/javascript">
    	  $("#navigation-image-#{instance.id}").Jcrop({
          aspectRatio: #{instance.image_dimensions["cropped"][0].to_f/instance.image_dimensions["cropped"][1].to_f},
          onSelect: updateCoords,
          trueSize: [#{instance.image_dimensions["original"][0]},#{instance.image_dimensions["original"][1]}],
          setSelect: [#{instance.image_crop_x}, #{instance.image_crop_y}, #{instance.image_crop_x}+#{instance.image_crop_w}, #{instance.image_crop_y}+#{instance.image_crop_h}],
          minSize: [#{instance.image_dimensions["cropped_retina"][0]},#{instance.image_dimensions["cropped_retina"][1]}]
        });
    	  function updateCoords(c)
    	  {
    	  	$("#form-modal-editdish-#{opts[:image].instance.id}-image_crop_w").val(Math.min(#{instance.image_dimensions["original"][0]},Math.floor(c.w)));
    	  	$("#form-modal-editdish-#{opts[:image].instance.id}-image_crop_h").val(Math.min(#{instance.image_dimensions["original"][1]},Math.floor(c.h)));
    	  	$("#form-modal-editdish-#{opts[:image].instance.id}-image_crop_x").val(Math.floor(c.x));
    	  	$("#form-modal-editdish-#{opts[:image].instance.id}-image_crop_y").val(Math.floor(c.y));
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
           		<div class="panel-title">
                 <input type="hidden" name="#{opts[:sort_key]}" value="">
                 <b>#{opts[:title]}</b>
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
      :image_url => opts[:navigation].image.present? ? opts[:navigation].image.url(:cropped) : "http://placehold.it/622x566") {|p|
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
      :image_url => opts[:dish].image.present? ? opts[:dish].image.url(:cropped) : "http://placehold.it/1516x1012") {|p|
        raw %(<div class="album-options">
        	  <a href="javascript:;" onclick="jQuery('#modal-editdish-#{opts[:dish].id}').modal('show');">
        	  	<i class="entypo-cog"></i>
        	  </a>
        	</div>)}
  end
  
end
