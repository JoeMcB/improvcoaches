/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$(function() { 
	if ($('#register')) {
		$("#is_coach_div").delegate( "input", "click", function() {
			if(this.value === "1") {
				return $("#coach_details").slideDown();
			} else {
				return $("#coach_details").slideUp();
			}

		});
	}

	return $('.tabs').click( function(e) {
			e.preventDefault();
			return $(this).tab('show');
	});
});