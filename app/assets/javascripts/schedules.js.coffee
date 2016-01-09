# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ () -> 
	schedule_form = $('form.schedule')

	if schedule_form
		
		$('.schedule_editor').selectable ({
			start: (event, ui) ->
				#console.log "started"
			filter: ".time_block"
			selected: (event, ui) ->
				$(ui.selected).toggleClass 'success'
			unselected: (event, ui) ->
				$(ui.selected).toggleClass 'success'
			stop: (event, ui) ->
				#console.log "finished"
		})

		$('.update_schedule').on 'click', (e) ->
			available_times = []
			selected_times = $('.schedule_editor .time_block.success').each (i, el) ->
				schedule_form.append $('<input>', {
						name: 'time_blocks['+i+'][day]'
						value: $('.day', el).text()
					})
				schedule_form.append $('<input>', {
						name: 'time_blocks['+i+'][hour]'
						value: $('.hour', el).text()
					})

				schedule_form.append $('<input>', {
						name: 'time_blocks['+i+'][minute]'
						value: $('.minute', el).text()
					})
			
			schedule_form.submit()