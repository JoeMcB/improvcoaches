/**
 * Schedule page functionality
 * Handles interactive scheduling and time block selection
 */

export function initializeScheduleEditor() {
  const scheduleEditor = document.querySelector('.schedule_editor');
  if (!scheduleEditor) return;

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
  
  // Handle the update schedule button click
  const updateButton = document.querySelector('.update_schedule');
  if (updateButton) {
    updateButton.addEventListener('click', function(e) {
      const scheduleForm = document.querySelector('form.schedule');
      if (!scheduleForm) return;
      
      // Clear any previous inputs
      scheduleForm.innerHTML = '';
      
      // Add the CSRF token
      const csrfToken = document.querySelector('meta[name="csrf-token"]');
      if (csrfToken) {
        const tokenInput = document.createElement('input');
        tokenInput.type = 'hidden';
        tokenInput.name = 'authenticity_token';
        tokenInput.value = csrfToken.content;
        scheduleForm.appendChild(tokenInput);
      }
      
      // Get all selected time blocks
      const selectedBlocks = document.querySelectorAll('.schedule_editor .time_block.success');
      
      // Add each selected time block to the form
      selectedBlocks.forEach((block, i) => {
        const dayInput = document.createElement('input');
        dayInput.type = 'hidden';
        dayInput.name = `time_blocks[${i}][day]`;
        dayInput.value = block.querySelector('.day').textContent;
        scheduleForm.appendChild(dayInput);
        
        const hourInput = document.createElement('input');
        hourInput.type = 'hidden';
        hourInput.name = `time_blocks[${i}][hour]`;
        hourInput.value = block.querySelector('.hour').textContent;
        scheduleForm.appendChild(hourInput);
        
        const minuteInput = document.createElement('input');
        minuteInput.type = 'hidden';
        minuteInput.name = `time_blocks[${i}][minute]`;
        minuteInput.value = block.querySelector('.minute').textContent;
        scheduleForm.appendChild(minuteInput);
      });
      
      // Submit the form
      scheduleForm.submit();
    });
  }
}