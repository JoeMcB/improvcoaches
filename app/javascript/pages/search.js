/**
 * Search page functionality
 * Handles search options panel and collapse animation
 * Uses jQuery for Bootstrap 3 compatibility
 */

export function initializeSearchPage() {
  // Check if jQuery is available
  if (typeof $ === 'undefined') {
    console.error('jQuery is not loaded, search functionality may be limited');
    return;
  }
  
  // Get the search options element
  const $searchOptions = $('#search-options');
  if ($searchOptions.length === 0) return;
  
  // Store initial state (open by default)
  let isOpen = true;
  
  // Handle the toggle click manually
  $('.panel-heading .pull-right').on('click', function(e) {
    e.preventDefault();
    isOpen = !isOpen;
    
    if (isOpen) {
      // Show the panel
      $searchOptions.slideDown();
      // Change the icon
      $('.panel-heading .glyphicon')
        .removeClass('glyphicon-collapse-down')
        .addClass('glyphicon-collapse-up');
    } else {
      // Hide the panel
      $searchOptions.slideUp();
      // Change the icon
      $('.panel-heading .glyphicon')
        .removeClass('glyphicon-collapse-up')
        .addClass('glyphicon-collapse-down');
    }
  });
  
  // Make the whole heading clickable
  $('#search .panel-heading').on('click', function(e) {
    // Only trigger if not clicking on the arrow itself
    if (!$(e.target).hasClass('pull-right') && 
        !$(e.target).parent().hasClass('pull-right') &&
        !$(e.target).hasClass('glyphicon')) {
      // Trigger the arrow click
      $('.panel-heading .pull-right').click();
    }
  });
  
  console.log('Search functionality initialized with jQuery');
}