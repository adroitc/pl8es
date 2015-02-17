$(document).ajaxSend(function() {
	show_loading_bar({
		pct: 100,
		delay: 0.5
	});
});

$(document).ajaxSuccess(function(){
	setTimeout(function() {
		
	}, 200);
});

$(document).ready(function() {
	// –– changes button style when toggling a hidden checkbox
	$("#default-modal").on("click", ".form-group input[type='checkbox']", function() {
		$(this).siblings(".btn").toggleClass("btn-green btn-default");
	});
	
	// –– deleting a record requires a confirm - manage hiding & showing
	$("#default-modal").on("click", ".modal-delete button.btn-danger", function() {
		$(this).hide();
		$(this).siblings(".cancel, .confirm").show();
	});
	$("#default-modal").on("click", ".modal-delete button.cancel", function() {
		$(this).siblings(".btn-danger").show();
		$(this).hide();
		$(this).siblings(".confirm").hide();
	});
	
	$("#default-modal").on("change", "input[type='file']", function() {
		readURL(this);
	});
});

function readURL(input) {
	if (input.files && input.files[0]) {
		var reader = new FileReader();
		
		reader.onload = function (e) {
			$('#image-preview').attr('src', e.target.result);
		}
		
		show_image_preview();
		
		reader.readAsDataURL(input.files[0]);
	}
}

// & hide the select image box
function show_image_preview() {
	$(".border-div").hide();
	$("#new-image-preview").show();
	$(".gallery-image-edit-env").addClass("preview");
	$(".text-holder").text("change image");			
}