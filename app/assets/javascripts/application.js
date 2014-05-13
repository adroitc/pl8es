// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//

//= require "gsap/main-gsap"

//= require i18n
//= require i18n/translations

//= require jquery.min
// require jquery_ujs
//= require jquery.ui.all
// require turbolinks

//= require "bootstrap"
//= require "joinable"
//= require "resizeable"
//= require "neon-api"
//= require "jquery.validate.min"
//= require "jquery.nestable"
//= require "neon-login"
//= require "neon-register"
//= require "jquery.inputmask.bundle.min"

//= require "cookies.min"
//= require "bootstrap-timepicker.min"
//= require "bootstrap-colorpicker.min"
//= require "bootstrap-switch.min"
//= require "select2/select2"
//= require "bootstrap-tagsinput.min"
//= require "jquery.multi-select"
//= require "icheck/icheck"
//= require "fileinput"
//= require "jcrop/jquery.Jcrop.min"
//= require "jquery.validate.min"

//= require "neon-custom"
// require "neon-demo"

//= require "jquery.ellipsize"
//= require "jquery.dotdotdot.min"

// require_tree .

$(document).ready(function()
{
  $(".pl8es_c_ajaxform").each(function(){
    pl8es_i_ajaxform($(this),function(){
      location.reload();
    })
  });
  $(".pl8es_c_ajaxform_noreload").each(function(){
    pl8es_i_ajaxform($(this),function(){
    })
  });
  $(".fileinput").on("change.bs.fileinput",function(){
    var f = $(this);
    if (f.find(".fileinput-preview img").size() > 0)
    {
    }
  });
  $(".ui-selectable").selectable({
    stop: function(event, id){
      $(event.target).children(".ui-selected").not(":first").removeClass("ui-selected");
      var s = $(this);
      //alert(s.parent().find("li").index(s.find(".ui-selected")));
    }
  });
  $(".ellipsis").dotdotdot({
    wrap: "letter",
    fallbackToLetter: true
  }).css("overflow", "hidden");

	$("input.icheck-2-checkbox").iCheck({
		checkboxClass: 'icheckbox_square-blue'
	});
  $('input.icheck-2-radio').iCheck({
  	radioClass: 'iradio_square-blue'
  });
  
  function pl8es_f_setupinputchanger(t){
    var f = "change";
    if (t.attr("type") == "checkbox"){
      f = "ifChanged"
    }
    t.one(f, function(){
      t.closest("form").find(t[0].tagName+"[name='"+t.attr("name")+"']").not(t).each(function(){
        if (t.attr("type") != "checkbox"){
          $(this).val(t.val()).trigger("change");
        }
        else if (t.attr("type") == "checkbox"){
          if (t.parent().hasClass("checked")){
            $(this).iCheck("uncheck");
          }
          else{
            $(this).iCheck("check");
          }
        }
      });
      pl8es_f_setupinputchanger(t);
    });
  }
  $("input[type!='checkbox'], select").each(function(){
    pl8es_f_setupinputchanger($(this));
  });
  $("input[type='checkbox']").each(function(){
    pl8es_f_setupinputchanger($(this));
  });
  
  $("input[type='file']").each(function(){
    var file_input = $(this);
    var file_input_name = file_input.attr("name");
    var _URL = window.URL || window.webkitURL;
    file_input.change(function(){
      var file, img;
      if ((file = this.files[0])) {
        img = new Image();
        img.onload = function (){
          var dim = file_input.attr("data-imgvalidation").split("x");
          if (this.width < dim[0]
              || this.height < dim[1]){
            file_input.attr("name","").closest(".form-group").append("<span class=\"validate-has-error\">Image is too small.</span>").addClass("validate-has-error");
            //alert("too small");
          }
          else{
            file_input.closest(".form-group").removeClass("validate-has-error").find("span.validate-has-error").remove();
          }
        };
        img.src = _URL.createObjectURL(file);
      }
      else{
        file_input.closest(".form-group").removeClass("validate-has-error").find("span.validate-has-error").remove();
      }
    });
  });
});
function pl8es_i_ajaxform(f,a)
{
  var files;
  f.submit(function(e){
    e.preventDefault();
    console.log(f.validate().errors());
    if (f.hasClass("validate")
        && f.validate().numberOfInvalids() > 0){
      return;
    }
    var d = f.serialize();
    var s2 = f.find("div.select2");
    d = new FormData(f[0]);
    if (s2.size() > 0)
    {
      var s2_id = s2.attr("id").split("s2id_form-")[1];
      var s2_e = s2.children("ul.select2-choices").children("li.select2-search-choice");
      s2_e.each(function(i){
        d.append(s2_id+"["+i+"]", $.trim($(this).text()));
        //d = d+"&"+s2_id+"["+i+"]="+$(this).text();
      });
    }
    pl8es_i_ajax(f.attr("action"),d,function(r){
      a(r);
    });
  });
}
function pl8es_i_ajax(u,d,s)
{
  show_loading_bar({
  	pct: 78,
  	delay: 0.4,
		finish: function()
		{
    	$.ajax({
    		url: u,
    		method: "POST",
    		dataType: "json",
    		data: d,
        contentType: false,
        processData: false,
    		error: function(e,r,t)
    		{
    			alert("An error occoured!");
          /*
          console.log(e);
          console.log(r);
          console.log(t);
          */
    		},
    		success: function(response)
    		{
        	show_loading_bar({
        		pct: 100,
        		delay: 0.2,
        		finish: function()
        		{
              s(response);
        		}
        	});
    		}
    	});
    }
  });
}
function pl8es_f_duplicate(m){
  var d = new FormData();
  d.append("authenticity_token", window._token);
  d.append("menu_id", m);
  pl8es_i_ajax("/ajax/duplicatemenu",d,function(){
	  location.reload();
	});
}
function pl8es_f_makedefaultmenu(){
  $(".pl8es_c_toggledefaultmenu").show();
  $(".pl8es_c_makedefaultmenu").hide();
  $(".pl8es_c_revertdefaultmenu").show();
}
function pl8es_f_revertdefaultmenu(){
  $(".pl8es_c_toggledefaultmenu").hide();
  $(".pl8es_c_makedefaultmenu").show();
  $(".pl8es_c_revertdefaultmenu").hide();
}
function pl8es_f_initdeletemenu(){
  $(".pl8es_c_initdeletemenu").hide();
  $(".pl8es_c_confirmdeletemenu").show();
}
function pl8es_f_initdeletemenu(){
  $(".pl8es_c_initdeletemenu").hide();
  $(".pl8es_c_confirmdeletemenu").show();
}
function pl8es_f_confirmdeletemenu(m){
  var d = new FormData();
  d.append("authenticity_token", window._token);
  d.append("menu_id", m);
  pl8es_i_ajax("/ajax/deletemenu",d,function(){
    location.reload();
  });
}
function pl8es_f_revertdeletemenu(){
  $(".pl8es_c_initdeletemenu").show();
  $(".pl8es_c_confirmdeletemenu").hide();
}