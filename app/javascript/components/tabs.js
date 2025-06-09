/**
 * Tabs component
 * Provides tab switching functionality across the application
 */

export function initializeTabs() {
  // Check if jQuery is available
  if (typeof $ === 'undefined') {
    console.error('jQuery is not loaded, tab functionality may be limited');
    return;
  }
  
  // Initialize tabs using jQuery
  $('.tabs').on('click', function(e) {
    e.preventDefault();
    
    // Get the target panel
    const targetSelector = $(this).attr('href');
    
    // Hide all tab content and remove active class from tabs
    $('.tab-pane').removeClass('active show');
    $('.tabs').removeClass('active');
    
    // Show the selected tab content and activate the tab
    $(targetSelector).addClass('active show');
    $(this).addClass('active');
  });
  
  console.log('Tabs initialized with jQuery');
}