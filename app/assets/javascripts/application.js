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
//= require "bootstrap-datepicker"
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
//= require "daterangepicker/moment.min"
//= require "daterangepicker/daterangepicker"
//= require "toastr"

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
    if (t.hasClass("icheck-2-checkbox") && t.attr("type") == "checkbox"){
      f = "ifChanged"
    }
    t.one(f, function(){
      t.closest("form").find(t[0].tagName+"[name='"+t.attr("name")+"']").not(t).each(function(){
        if (t.hasClass("icheck-2-checkbox") && t.attr("type") == "checkbox"){
          if (t.parent().hasClass("checked")){
            $(this).iCheck("uncheck");
          }
          else{
            $(this).iCheck("check");
          }
        }
        else{
          $(this).val(t.val()).trigger("change");
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
  
  jQuery.validator.addMethod("filedimension", function(v,e){
    if ($(e).val() == null){
      return false;
    }
    return !$(e).data("file-size-error");
  }, "Image is too small.");
  
  jQuery.validator.addMethod("validaddress", function(v,e){
    if ($(e).val() == null){
      return false;
    }
    return !$(e).data("validaddress-error");
  }, "Please use a valid address.");
  
  /*
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
            file_input.attr("name","_fileerror").closest(".form-group").addClass("validate-has-error-file");
            file_input.parent().append("<span class=\"validate-has-error-file\">Image is too small.</span>");
            file_input.parent().find(".validate-has-error").hide();
          }
          else{
            file_input.closest(".form-group").removeClass("validate-has-error-file");
            file_input.parent().find("span.validate-has-error-file").remove();
            file_input.parent().find(".validate-has-error").show();
          }
        };
        img.src = _URL.createObjectURL(file);
      }
      else{
        file_input.closest(".form-group").removeClass("validate-has-error-file");
        file_input.parent().find("span.validate-has-error-file").remove();
        file_input.parent().find(".validate-has-error").show();
      }
    });
  });
  */
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
            file_input.data("file-size-error",true);
            //public_vars.$form_validations[file_input.closest("form").attr("id")].form();
            /*file_input.closest(".form-group").addClass("validate-has-error-file");
            file_input.parent().append("<span class=\"validate-has-error-file\">Image is too small.</span>");
            file_input.parent().find(".validate-has-error").hide();*/
            //validator.element("input[type='file',name='"+file_input.attr("name")+"']");
          }
          else{
            file_input.data("file-size-error",false);
            //public_vars.$form_validations[file_input.closest("form").attr("id")].form();
            /*file_input.closest(".form-group").removeClass("validate-has-error-file");
            file_input.parent().find("span.validate-has-error-file").remove();
            file_input.parent().find(".validate-has-error").show();*/
            //validator.element("input[type='file',name='"+file_input.attr("name")+"']");
          }
        };
        img.src = _URL.createObjectURL(file);
      }
      else{
        file_input.data("file-size-error",false);
        public_vars.$form_validations[file_input.closest("form").attr("id")].form();
        /*file_input.closest(".form-group").removeClass("validate-has-error-file");
        file_input.parent().find("span.validate-has-error-file").remove();
        file_input.parent().find(".validate-has-error").show();*/
        //validator.element("input[type='file',name='"+file_input.attr("name")+"']");
      }
    });
  });
});
function pl8es_i_ajaxform(f,a)
{
  var files;
  f.submit(function(e){
    e.preventDefault();
    
    function submit_ajax(){
      pl8es_i_ajax(f.attr("action"),d,function(r){
        a(r);
      });
    }
    if (f.hasClass("validate")
            && !f.valid()){
      public_vars.$form_validations[f.attr("id")].form();
    }
    /*if (f.hasClass("validate")
        && !f.valid()
        //&& public_vars.$form_validations[f.attr("id")].numberOfInvalids() > 0
    ){
      alert("submit-A-"+f.attr("action")+"-"+f.valid());
      return;
    }*/
    var d = f.serialize();
    var s2 = f.find("div.select2");
    d = new FormData(f[0]);
    if (s2.size() > 0)
    {
      var s2_id = s2.attr("id").split("s2id_form-")[1];
      var s2_e = s2.children("ul.select2-choices").children("li.select2-search-choice");
      s2_e.each(function(i){
        d.append(s2_id+"["+i+"]", $.trim($(this).text()));
      });
    }
    if (f.find("input[data-validate~='validaddress']").size() > 0){
      function addr_inputval(n){
        return $(f).find("input[name='"+n+"']").val().replace(" ","+")+",";
      }
      google_url = "http://maps.googleapis.com/maps/api/geocode/json?address="+addr_inputval("address")+addr_inputval("zip")+addr_inputval("city")+addr_inputval("country")+"&sensor=true&language=en"
      pl8es_i_ajax(google_url,null,function(r){
        if (r["results"].length == 1 &&
            r["results"][0]["geometry"]["location_type"] == "ROOFTOP"){
          f.find("input[name='address']").data("validaddress-error",false);
          f.valid();
          submit_ajax();
        }
        else{
          f.find("input[name='address']").data("validaddress-error",true);
          f.valid();
        }
      });
    }
    else{
      submit_ajax();
    }
  });
}
function pl8es_i_ajax(u,d,s)
{
  show_loading_bar({
  	pct: 78,
  	delay: 0.4,
		finish: function()
		{
      method = "POST";
      if (d == null){
        method = "GET";
      }
    	$.ajax({
    		url: u,
    		method: method,
    		dataType: "json",
    		data: d,
        contentType: false,
        processData: false,
    		error: function(e,r,t)
    		{
          var opts = {
          	"closeButton": true,
          	"debug": false,
          	"positionClass": "toast-top-right",
          	"onclick": null,
          	"showDuration": "100",
          	"hideDuration": "100",
          	"timeOut": "2000",
          	"extendedTimeOut": "1000",
          	"showEasing": "swing",
          	"hideEasing": "linear",
          	"showMethod": "fadeIn",
          	"hideMethod": "fadeOut"
          };
          toastr.error("The administrator was contacted.", "An error occured", opts);
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
  pl8es_i_ajax("/a/menu/duplicate",d,function(){
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
  pl8es_i_ajax("/a/menu/delete",d,function(){
    location.reload();
  });
}
function pl8es_f_revertdeletemenu(){
  $(".pl8es_c_initdeletemenu").show();
  $(".pl8es_c_confirmdeletemenu").hide();
}