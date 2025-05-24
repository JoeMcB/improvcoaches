/**
 * Schedule page functionality
 * Handles interactive scheduling and time block selection
 */

export function initializeScheduleEditor() {
  console.log('Initializing schedule editor...');
  
  // Remove any existing listeners first
  document.removeEventListener('mouseup', handleMouseUp);
  document.removeEventListener('touchend', handleTouchEnd);
  
  const scheduleEditor = document.querySelector('.schedule_editor');
  console.log('Schedule editor found:', scheduleEditor);
  if (!scheduleEditor) {
    console.log('No schedule editor found, skipping...');
    return;
  }

  // State variables
  let isMouseDown = false;
  let startedSelection = false;
  
  // Mouse up handler
  function handleMouseUp() {
    isMouseDown = false;
  }
  
  // Touch end handler  
  function handleTouchEnd() {
    isMouseDown = false;
  }
  
  // Get all time blocks
  const timeBlocks = scheduleEditor.querySelectorAll('.time_block');
  console.log('Found time blocks:', timeBlocks.length);
  
  // Remove existing listeners and add new ones
  timeBlocks.forEach((block, index) => {
    console.log(`Setting up block ${index}`);
    
    // Clone the block to remove all existing listeners
    const newBlock = block.cloneNode(true);
    block.parentNode.replaceChild(newBlock, block);
    
    // Handle mouse interactions for drag selection
    newBlock.addEventListener('mousedown', function(e) {
      console.log('Mouse down on block');
      isMouseDown = true;
      this.classList.toggle('success');
      startedSelection = this.classList.contains('success');
      
      // Update the visual indicator
      const indicator = this.querySelector('div');
      if (indicator) {
        indicator.className = this.classList.contains('success') ? 
          'w-2 h-2 sm:w-3 sm:h-3 mx-auto rounded-full bg-green-400 transition-colors duration-200' :
          'w-2 h-2 sm:w-3 sm:h-3 mx-auto rounded-full bg-gray-200 transition-colors duration-200';
      }
      
      e.preventDefault();
      return false;
    });
    
    // Touch start event (for mobile)
    newBlock.addEventListener('touchstart', function(e) {
      console.log('Touch start on block');
      this.classList.toggle('success');
      startedSelection = this.classList.contains('success');
      
      // Update the visual indicator
      const indicator = this.querySelector('div');
      if (indicator) {
        indicator.className = this.classList.contains('success') ? 
          'w-2 h-2 sm:w-3 sm:h-3 mx-auto rounded-full bg-green-400 transition-colors duration-200' :
          'w-2 h-2 sm:w-3 sm:h-3 mx-auto rounded-full bg-gray-200 transition-colors duration-200';
      }
      
      e.preventDefault();
    });
    
    newBlock.addEventListener('mouseenter', function() {
      if (isMouseDown) {
        console.log('Mouse enter while dragging');
        // When dragging, set class to match what we started with
        if (startedSelection) {
          this.classList.add('success');
        } else {
          this.classList.remove('success');
        }
        
        // Update the visual indicator
        const indicator = this.querySelector('div');
        if (indicator) {
          indicator.className = this.classList.contains('success') ? 
            'w-2 h-2 sm:w-3 sm:h-3 mx-auto rounded-full bg-green-400 transition-colors duration-200' :
            'w-2 h-2 sm:w-3 sm:h-3 mx-auto rounded-full bg-gray-200 transition-colors duration-200';
        }
      }
    });
    
    // Touch move/drag support
    newBlock.addEventListener('touchmove', function(e) {
      const touch = e.touches[0];
      const elementAtTouch = document.elementFromPoint(touch.clientX, touch.clientY);
      
      if (elementAtTouch && elementAtTouch.classList.contains('time_block')) {
        if (startedSelection) {
          elementAtTouch.classList.add('success');
        } else {
          elementAtTouch.classList.remove('success');
        }
        
        // Update the visual indicator
        const indicator = elementAtTouch.querySelector('div');
        if (indicator) {
          indicator.className = elementAtTouch.classList.contains('success') ? 
            'w-2 h-2 sm:w-3 sm:h-3 mx-auto rounded-full bg-green-400 transition-colors duration-200' :
            'w-2 h-2 sm:w-3 sm:h-3 mx-auto rounded-full bg-gray-200 transition-colors duration-200';
        }
      }
      
      e.preventDefault();
    });
  });
  
  // Add document-level listeners
  document.addEventListener('mouseup', handleMouseUp);
  document.addEventListener('touchend', handleTouchEnd);
  
  // Handle the update schedule button click
  const updateButton = document.querySelector('.update_schedule');
  if (updateButton) {
    // Remove existing listener
    const newUpdateButton = updateButton.cloneNode(true);
    updateButton.parentNode.replaceChild(newUpdateButton, updateButton);
    
    newUpdateButton.addEventListener('click', function() {
      console.log('Update schedule clicked');
      const scheduleForm = document.querySelector('form.schedule');
      if (!scheduleForm) return;
      
      // Clear any previous inputs except CSRF token
      const existingToken = scheduleForm.querySelector('input[name="authenticity_token"]');
      scheduleForm.innerHTML = '';
      if (existingToken) {
        scheduleForm.appendChild(existingToken);
      }
      
      // Add the CSRF token if not present
      if (!existingToken) {
        const csrfToken = document.querySelector('meta[name="csrf-token"]');
        if (csrfToken) {
          const tokenInput = document.createElement('input');
          tokenInput.type = 'hidden';
          tokenInput.name = 'authenticity_token';
          tokenInput.value = csrfToken.content;
          scheduleForm.appendChild(tokenInput);
        }
      }
      
      // Get all selected time blocks
      const selectedBlocks = document.querySelectorAll('.schedule_editor .time_block.success');
      console.log('Selected blocks:', selectedBlocks.length);
      
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
  
  console.log('Schedule editor initialization complete');
}