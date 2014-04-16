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
//= require "select2/select2"
//= require "jquery.multi-select"
//= require "icheck/icheck"
//= require "fileinput"

//= require "neon-custom"
// require "neon-demo"

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
});
function pl8es_i_ajaxform(f,a)
{
  f.submit(function(e){
    e.preventDefault();
    var d = f.serialize();
    var s2 = f.find("div.select2");
    if (s2.size() > 0)
    {
      var s2_id = s2.attr("id").split("s2id_form-")[1];
      var s2_e = s2.children("ul.select2-choices").children("li.select2-search-choice");
      s2_e.each(function(i){
        d = d+"&"+s2_id+"["+i+"]="+$(this).text();
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
  pl8es_i_ajax("/ajax/duplicatemenu",{
    authenticity_token: window._token,
	  menu_id: m
	},function(){
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
  pl8es_i_ajax("/ajax/deletemenu",{
    authenticity_token: window._token,
	  menu_id: m
	},function(){
   location.reload();
  });
}
function pl8es_f_revertdeletemenu(){
  $(".pl8es_c_initdeletemenu").show();
  $(".pl8es_c_confirmdeletemenu").hide();
}