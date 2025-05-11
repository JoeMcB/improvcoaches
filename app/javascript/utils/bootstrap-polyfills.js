/**
 * Bootstrap 3 jQuery bridge
 * Uses jQuery to work with Bootstrap 3 components
 */

export function initializeBootstrapPolyfills() {
  console.log("Bootstrap jQuery bridge initialized");
  
  // Verify jQuery is available globally
  if (typeof $ === 'undefined' || typeof jQuery === 'undefined') {
    console.error('jQuery is not available globally - this should not happen!');
    return;
  }
  
  console.log('jQuery version:', $.fn.jquery);
}

export function initializeBootstrapComponents() {
  // Make sure jQuery is available
  if (typeof $ === 'undefined') {
    console.error('jQuery is not available globally');
    return;
  }
  
  // Check if Bootstrap's dropdown plugin is available
  const checkBootstrap = function() {
    // Test if Bootstrap's dropdown plugin is loaded
    if (typeof $.fn.dropdown === 'undefined') {
      console.log('Bootstrap dropdown not yet available, waiting...');
      setTimeout(checkBootstrap, 100);
      return;
    }
    
    console.log('Bootstrap dropdown plugin found, initializing components');
    
    // Let Bootstrap handle dropdowns as designed
    // This uses the built-in Bootstrap event handlers and functionality
    $('.dropdown-toggle').dropdown();
    
    // Initialize tooltips and popovers if available
    if (typeof $.fn.tooltip !== 'undefined') {
      $('[data-toggle="tooltip"]').tooltip();
    }
    
    if (typeof $.fn.popover !== 'undefined') {
      $('[data-toggle="popover"]').popover();
    }
    
    console.log('Bootstrap components initialized successfully');
  };
  
  // Start checking for Bootstrap
  $(document).ready(checkBootstrap);
}