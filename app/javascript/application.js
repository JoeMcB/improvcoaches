/**
 * Main entry point for the application's JavaScript
 * This file imports and initializes all modules
 */

// Import Turbo for Hotwire functionality
import "@hotwired/turbo-rails"

// Use jQuery from CDN instead of importing it
// jQuery will be loaded from the CDN in the application layout

// Import utility modules
import { initializeBootstrapPolyfills, initializeBootstrapComponents } from './utils/bootstrap-polyfills';

// Import components
import { initializeTabs } from './components/tabs';

// Import page-specific functionality
import { initializeScheduleEditor } from './pages/schedules';
import { initializeUserForms } from './pages/users';
import { initializeSearchPage } from './pages/search';
import { initializeSpacePage } from './pages/spaces';

// Initialize the application when the DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
  console.log('Modern JavaScript with jQuery support now loaded!');
  console.log('Initializing application...');
  
  // Initialize Bootstrap polyfills
  initializeBootstrapPolyfills();
  
  // Initialize Bootstrap components - must be done first to ensure Navbar works
  initializeBootstrapComponents();
  
  // Initialize shared components
  initializeTabs();
  
  // Initialize page-specific functionality
  initializeScheduleEditor();
  initializeUserForms();
  initializeSearchPage();
  initializeSpacePage();
  
  // No extra navbar-toggle handler needed here, it's handled in bootstrap-polyfills.js
  
  // Debug info about navbar elements
  console.log("Navbar elements:", {
    "navbar": document.querySelectorAll('.navbar').length,
    "navbar-collapse": document.querySelectorAll('.navbar-collapse').length,
    "navbar-toggle": document.querySelectorAll('.navbar-toggle').length,
    "navbar-right": document.querySelectorAll('.navbar-right').length,
    "nav links": document.querySelectorAll('ul.nav li a').length
  });
  
  console.log('Application initialization complete');
});