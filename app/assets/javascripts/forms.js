// trigger form validation after ajax calls
$(document).ajaxSuccess(function(){
	if($('#default-modal form[data-validate]').length){
		$('#default-modal form[data-validate]').enableClientSideValidations();
	}
});

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
});