# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$ () -> 
	if $('#register')
		$("#is_coach_div").delegate( "input", "click", () ->
			if(this.value == "1")
				$("#coach_details").slideDown()
			else
				$("#coach_details").slideUp()

		)

	$('.tabs').click( (e) ->
			e.preventDefault()
			$(this).tab('show')
	)