/**
 * Main entry point for the application's JavaScript
 * This file imports and initializes all modules
 */

// Import Turbo for Hotwire functionality
import "@hotwired/turbo-rails"

// Use jQuery from CDN instead of importing it
// jQuery will be loaded from the CDN in the application layout


// Import components
import { initializeTabs } from './components/tabs';

// Import page-specific functionality
import { initializeScheduleEditor } from './pages/schedules';
import { initializeUserForms, initializePhotoPreview } from './pages/users';
import { initializeSearchPage } from './pages/search';
import { initializeSpacePage } from './pages/spaces';

// Function to initialize all components
function initializeApp() {
  console.log('Initializing application...');
  
  
  // Initialize shared components
  initializeTabs();
  
  // Initialize page-specific functionality
  initializeScheduleEditor();
  initializeUserForms();
  initializePhotoPreview();
  initializeSearchPage();
  initializeSpacePage();
  
  console.log('Application initialization complete');
}

// Initialize the application when the DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
  console.log('Modern JavaScript with jQuery support now loaded!');
  initializeApp();
});

// Also initialize when Turbo loads a new page
document.addEventListener('turbo:load', function() {
  console.log('Turbo loaded new page, reinitializing...');
  initializeApp();
});