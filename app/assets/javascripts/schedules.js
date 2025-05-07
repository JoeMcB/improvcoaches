/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(function() { 
	const schedule_form = $('form.schedule');

	if (schedule_form) {
		
		$('.schedule_editor').selectable(({
			start(event, ui) {},
				//console.log "started"
			filter: ".time_block",
			selected(event, ui) {
				return $(ui.selected).toggleClass('success');
			},
			unselected(event, ui) {
				return $(ui.selected).toggleClass('success');
			},
			stop(event, ui) {}
				//console.log "finished"
		})
		);

		return $('.update_schedule').on('click', function(e) {
			const available_times = [];
			const selected_times = $('.schedule_editor .time_block.success').each(function(i, el) {
				schedule_form.append($('<input>', {
						name: 'time_blocks['+i+'][day]',
						value: $('.day', el).text()
					})
				);
				schedule_form.append($('<input>', {
						name: 'time_blocks['+i+'][hour]',
						value: $('.hour', el).text()
					})
				);

				return schedule_form.append($('<input>', {
						name: 'time_blocks['+i+'][minute]',
						value: $('.minute', el).text()
					})
				);
			});
			
			return schedule_form.submit();
		});
	}
});