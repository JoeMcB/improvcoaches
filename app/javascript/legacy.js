// This file imports all the legacy JS files
// Add specific imports below as needed

// Import the schedules functionality
document.addEventListener('DOMContentLoaded', function() {
  // Schedules functionality (originally in schedules.js)
  const scheduleEditor = document.getElementById('schedule_editor');
  if (scheduleEditor) {
    // Implement a basic selectable functionality
    let isMouseDown = false;
    let startedSelection = false;
    
    // Get all time blocks
    const timeBlocks = scheduleEditor.querySelectorAll('.time_block');
    
    // Add mouse event listeners to each time block
    timeBlocks.forEach(block => {
      // Single click toggles the selection
      block.addEventListener('click', function(e) {
        this.classList.toggle('success');
      });
      
      // Handle mouse interactions for drag selection
      block.addEventListener('mousedown', function(e) {
        isMouseDown = true;
        this.classList.toggle('success'); // Toggle on mousedown
        startedSelection = this.classList.contains('success');
        
        // Prevent text selection
        e.preventDefault();
        return false;
      });
      
      block.addEventListener('mouseenter', function(e) {
        if (isMouseDown) {
          // When dragging, set class to match what we started with
          if (startedSelection) {
            this.classList.add('success');
          } else {
            this.classList.remove('success');
          }
        }
      });
    });
    
    // Stop selection on mouseup anywhere on the document
    document.addEventListener('mouseup', function() {
      isMouseDown = false;
    });
  }

  // Search functionality (originally in search.js)
  const searchOptions = document.getElementById('search-options');
  if (searchOptions) {
    // Handle manual collapse functionality
    const toggleButton = document.querySelector("#search .panel-heading .pull-right");
    if (toggleButton) {
      toggleButton.addEventListener('click', function(e) {
        e.preventDefault();
        const glyphicon = document.querySelector("#search .panel-heading .glyphicon");
        if (glyphicon) {
          glyphicon.classList.toggle('glyphicon-collapse-up');
          glyphicon.classList.toggle('glyphicon-collapse-down');
        }
      });
    }
  }

  // Spaces functionality (originally in spaces.js)
  const carouselWrappers = document.querySelectorAll('.jcarousel-wrapper');
  carouselWrappers.forEach(wrapper => {
    // Empty initialization for now
  });

  // Users functionality (originally in users.js)
  const registerForm = document.getElementById('register');
  if (registerForm) {
    const isCoachDiv = document.getElementById("is_coach_div");
    if (isCoachDiv) {
      isCoachDiv.addEventListener('click', function(event) {
        if (event.target.tagName === 'INPUT') {
          const coachDetails = document.getElementById("coach_details");
          if (coachDetails) {
            if (event.target.value === "1") {
              // Slide down animation equivalent
              coachDetails.style.height = 'auto';
              coachDetails.style.overflow = 'visible';
              coachDetails.style.opacity = '1';
              coachDetails.style.display = 'block';
            } else {
              // Slide up animation equivalent
              coachDetails.style.height = '0';
              coachDetails.style.overflow = 'hidden';
              coachDetails.style.opacity = '0';
              setTimeout(() => {
                coachDetails.style.display = 'none';
              }, 300); // Match animation duration
            }
          }
        }
      });
    }
  }

  // Handle tabs
  const tabElements = document.querySelectorAll('.tabs');
  tabElements.forEach(tab => {
    tab.addEventListener('click', function(e) {
      e.preventDefault();
      // Manual tab handling
      const targetSelector = this.getAttribute('data-bs-target') || this.getAttribute('href');
      if (targetSelector) {
        // Hide all tab content
        document.querySelectorAll('.tab-pane').forEach(pane => {
          pane.classList.remove('active', 'show');
        });
        // Show the selected tab content
        const targetTab = document.querySelector(targetSelector);
        if (targetTab) {
          targetTab.classList.add('active', 'show');
        }
        // Update active state on tab buttons
        document.querySelectorAll('.tabs').forEach(t => {
          t.classList.remove('active');
        });
        this.classList.add('active');
      }
    });
  });
});