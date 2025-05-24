/**
 * Users page functionality
 * Handles user profile and coach details interaction
 */

export function initializeUserForms() {
  const registerForm = document.getElementById('register');
  if (!registerForm) return;

  const isCoachDiv = document.getElementById("is_coach_div");
  if (!isCoachDiv) return;
  
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

export function initializePhotoPreview() {
  const avatarInput = document.getElementById('user_avatar');
  if (!avatarInput) return;

  avatarInput.addEventListener('change', function(event) {
    const file = event.target.files[0];
    if (file && file.type.startsWith('image/')) {
      const reader = new FileReader();
      
      reader.onload = function(e) {
        const previewContainer = document.getElementById('photo-preview');
        const previewImage = document.getElementById('preview-image');
        
        if (previewContainer && previewImage) {
          previewImage.src = e.target.result;
          previewContainer.classList.remove('hidden');
        }
      };
      
      reader.readAsDataURL(file);
    } else {
      // Hide preview if no valid image is selected
      const previewContainer = document.getElementById('photo-preview');
      if (previewContainer) {
        previewContainer.classList.add('hidden');
      }
    }
  });
}