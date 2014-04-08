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
//= require "neon-login"
//= require "neon-register"
//= require "jquery.inputmask.bundle.min"

//= require "cookies.min"
//= require "bootstrap-timepicker.min"
//= require "select2/select2"
//= require "jquery.multi-select"
//= require "icheck/icheck"

//= require "neon-custom"
// require "neon-demo"

// require_tree .

$(document).ready(function()
{
  $("body").trigger("click");
  $(".pl8es_c_ajaxform").each(function(){
    var f = $(this);
    f.submit(function(e){
      e.preventDefault();
      
      show_loading_bar({
      	pct: 78,
      	delay: 0.4,
    		finish: function()
    		{
      		$.ajax({
      			url: f.attr("action"),
      			method: "POST",
      			dataType: "json",
      			data: f.serialize(),
      			error: function(e,r,t)
      			{
      				alert("An error occoured!");
              console.log(e);
              console.log(r);
              console.log(t);
      			},
      			success: function(response)
      			{
            	show_loading_bar({
            		pct: 100,
            		delay: 0.2,
            		finish: function()
            		{
            			location.reload()
            		}
            	});
      			}
      		});
        }
      });
    });
  });
});
function pl8es_f_duplicate(m){
	$.ajax({
		url: "/ajax/duplicatemenu",
		method: "POST",
		dataType: "json",
		data: {
		  menu_id: m
		},
		error: function(e,r,t)
		{
			alert("An error occoured!");
		},
		success: function(response)
		{
      location.reload();
		}
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
	$.ajax({
		url: "/ajax/deletemenu",
		method: "POST",
		dataType: "json",
		data: {
		  menu_id: m
		},
		error: function(e,r,t)
		{
			alert("An error occoured!");
		},
		success: function(response)
		{
      location.reload();
		}
	});
}
function pl8es_f_revertdeletemenu(){
  $(".pl8es_c_initdeletemenu").show();
  $(".pl8es_c_confirmdeletemenu").hide();
}