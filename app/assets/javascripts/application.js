// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
// jQuery is loaded from CDN in the layout
// jquery_ujs is added separately
//= require_tree .

// Noty
//= require noty/jquery.noty
//= require noty/layouts/top
//= require noty/themes/default

$(document).ready(function(){ //Initialization
	console.log("Document ready - starting initialization");

	// Initialize Bootstrap components
	$(".popover_trigger").popover();
	
	// Explicitly initialize all dropdown menus
	$('.dropdown-toggle').dropdown();
	console.log("Dropdown initialized", $('.dropdown-toggle').length, "dropdown elements found");
	
	// Debug info about navbar elements
	console.log("Navbar elements:", {
		"navbar": $('.navbar').length,
		"navbar-collapse": $('.navbar-collapse').length,
		"navbar-toggle": $('.navbar-toggle').length,
		"navbar-right": $('.navbar-right').length,
		"nav links": $('ul.nav li a').length
	});
	
	// Fix navbar collapse button for mobile
	$('.navbar-toggle').on('click', function() {
		console.log("Navbar toggle clicked");
		$('.navbar-collapse').toggleClass('in');
		console.log("Navbar collapse toggled", $('.navbar-collapse').hasClass('in'));
	});
	
	// Make navbar items super obvious for debugging
	$('.navbar').css('border', '3px solid lime');
	$('.navbar-right').css('border', '3px solid blue');
	$('ul.nav li a').css('text-decoration', 'underline');
	
	// Ensure all navigation elements are working
	$('.navbar-nav a').on('click', function(e) {
		console.log("Nav link clicked", this.href);
	});

	// This is now moved to the search.js file with document.ready wrapper
	// $("#search-options").on('hidden.bs.collapse shown.bs.collapse', function(e){
	//	$("#search .panel-heading .glyphicon").toggleClass('glyphicon-collapse-up');
	//	$("#search .panel-heading .glyphicon").toggleClass('glyphicon-collapse-down');
	//});
	
	console.log("Application.js initialization complete");
});