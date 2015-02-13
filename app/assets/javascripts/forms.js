$(document).ready(function() {
	// –– changes button style when toggling a hidden checkbox
	$("#default-modal").on("click", ".form-group input[type='checkbox']", function() {
		$(this).siblings(".btn").toggleClass("btn-green btn-default");
	});
	
	// –– deleting a record requires a confirm - manage hiding & showing
	$("#default-modal").on("click", ".modal-delete button.delete", function() {
		$(this).hide();
		$(this).siblings(".cancel, .confirm").show();
	});
	$("#default-modal").on("click", ".modal-delete button.cancel", function() {
		$(this).siblings(".delete").show();
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
			$('#new-image-preview').attr('src', e.target.result);
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