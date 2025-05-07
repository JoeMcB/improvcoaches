/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/main/docs/suggestions.md
 */
// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

//#This doesn't work, not sure why?

$(document).ready(function() {
  $('#search-options').on('hidden.bs.collapse shown.bs.collapse', function() {
    $("#search .panel-heading .glyphicon").toggleClass('glyphicon-collapse-up');
    return $("#search .panel-heading .glyphicon").toggleClass('glyphicon-collapse-down');
  });
});

