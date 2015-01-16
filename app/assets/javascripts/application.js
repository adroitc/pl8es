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
//
//= require "gsap/main-gsap"
// require turbolinks
//
//= require jquery
//= require jquery-ui
//= require jquery.dotdotdot.min
//= require jquery.ellipsize
//= require jquery.inputmask.bundle.min
//= require jquery.Jcrop.min
//= require jquery.multi-select
//= require jquery.nestable
//= require jquery.sparkline.min
//= require jquery.unveil
//= require jquery.validate.min
//
//= require bootstrap
//= require bootstrap-colorpicker.min
//= require bootstrap-datepicker
//= require bootstrap-switch.min
//= require bootstrap-tagsinput.min
//= require bootstrap-timepicker.min
//
//= require neon-api
//= require neon-custom
//= require neon-login
//= require neon-register
//
//= require daterangepicker/daterangepicker
//= require daterangepicker/moment.min
//
//= require cookies.min
//= require select2/select2
//
//= require icheck/icheck
//= require fileinput
//= require toastr
//= require joinable
//= require resizeable


$(document).ready(function()
{
  $(".pl8es_c_ajaxform").each(function(){
    var f = $(this);
    pl8es_i_ajaxform($(this),function(r){
      if (r["status"] == "invalid" && f.find(".form-invalid").length > 0){
        f.find(".form-invalid").css("display", "block");
      }
      else if (r["redirect"]
               && r["status"] == "success"
               && f.find(".form-valid").length > 0){
        f.find(".form-invalid").css("display", "none");
        f.find(".form-valid").css("display", "block");
      	show_loading_bar({
      		pct: 100,
      		delay: 0.2,
      		finish: function()
      		{
            window.location.href = r["redirect"];
      		}
      	});
      }
      else if (r["redirect"]){
        window.location.href = r["redirect"];
      }
      else{
        location.reload();
      }
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
  $("img.unveil").unveil(200);
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
    if (t.attr("type") != "radio"){
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
  
  jQuery.validator.addMethod("secpass", function(v,e){
    if ($(e).val().length == 0){
      return true;
    }
    return /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).*$/.test($(e).val());
  }, "Your password has to include lowercase, uppercase and a number.");
  
  jQuery.validator.addMethod("hexcolor", function(v,e){
    return /(^#[0-9A-F]{6}$)|(^#[0-9A-F]{3}$)/.test($(e).val())
  }, "Please enter a valid color code.");
  
  jQuery.validator.addMethod("time", function(v,e){
    return /(^(?:[01]?[0-9]|2[0-3]):[0-5][0-9]$)/.test($(e).val())
  }, "Please enter a valid time.");
  
  jQuery.validator.addMethod("price", function(v,e){
    return /(^[0-9\,]*$)/.test($(e).val())
  }, "Please enter a valid price.");
  
  jQuery.validator.addMethod("beverageamount", function(v,e){
    return /(^[0-9\,]*$)/.test($(e).val())
  }, "Please enter a valid amount.");
  
  $("input[type='file']").each(function(){
    var f = $(this).closest("form");
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
            f.valid();
          }
          else{
            file_input.data("file-size-error",false);
            f.valid();
          }
        };
        img.src = _URL.createObjectURL(file);
      }
      else{
        file_input.data("file-size-error",false);
        f.valid();
        public_vars.$form_validations[file_input.closest("form").attr("id")].form();
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

    f.find("input[name='address']").data("validaddress-error",false);
    
    if (f.hasClass("validate")
            && !f.valid()){
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
      });
    }
    if (f.find("input[data-validate*='validaddress']").size() > 0){
      function addr_inputval(n){
        return $(f).find("input[name='"+n+"']").val().replace(" ","+")+",";
      }
      google_url = "http://maps.googleapis.com/maps/api/geocode/json?address="+addr_inputval("address")+addr_inputval("zip")+addr_inputval("city")+addr_inputval("country")+"&sensor=true&language=en"
      pl8es_i_ajax(google_url,null,function(r){
        if (r["results"].length == 1 &&
            r["results"][0]["geometry"]["location_type"] == "ROOFTOP"){
          f.find("input[name='address']").data("validaddress-error",false);
          f.find("input[name='latitude']").val(r["results"][0]["geometry"]["location"]["lat"]);
          f.find("input[name='longitude']").val(r["results"][0]["geometry"]["location"]["lng"]);
          d = new FormData(f[0]);
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
  pl8es_i_ajax("menumalist/duplicate",d,function(){
	  location.reload();
	});
}
function pl8es_f_makedefaultmenu(e){
  var md = e.closest("form");
  
  md.find(".pl8es_c_toggledefaultmenu").show();
  md.find(".pl8es_c_makedefaultmenu").hide();
  md.find(".pl8es_c_revertdefaultmenu").show();
  md.find(".pl8es_c_defaultmenu input").removeAttr("disabled");
}
function pl8es_f_revertdefaultmenu(e){
  var md = e.closest("form");
  
  md.find(".pl8es_c_toggledefaultmenu").hide();
  md.find(".pl8es_c_makedefaultmenu").show();
  md.find(".pl8es_c_revertdefaultmenu").hide();
  md.find(".pl8es_c_defaultmenu input").attr("disabled","disabled");
}
function pl8es_f_initdelete(e){
  var md = e.closest(".pl8es-modal-delete");
  md.find(".pl8es-btn-delete").css("display","none");
  md.find(".pl8es-btn-delete-cancel").css("display","inline-block");
  md.find(".pl8es-btn-delete-confirm").css("display","inline-block");
  e.closest(".modal").on("hide.bs.modal",function(){
    pl8es_f_initdelete_cancel(e);
  });
}
function pl8es_f_initdelete_cancel(e){
  var md = e.closest(".pl8es-modal-delete");

  md.find(".pl8es-btn-delete").css("display","inline-block");
  md.find(".pl8es-btn-delete-cancel").css("display","none");
  md.find(".pl8es-btn-delete-confirm").css("display","none");
}
function pl8es_f_initdelete_confirm(e){
  var md = e.closest(".pl8es-modal-delete");

  md.find(".pl8es-input-delete").css("display","inline-block").removeAttr("disabled");
  md.closest("form").submit();
  md.find(".pl8es-input-delete").css("display","none").attr("disabled","disabled");
}