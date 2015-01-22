$(document).ready(function() {
	$("#default-modal").on("click", ".form-group input[type='checkbox']", function() {
		$(this).siblings(".btn").toggleClass("btn-green btn-default");
	});
});