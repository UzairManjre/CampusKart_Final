function toggleLogoutPopup() {
    const popup = document.getElementById('logout-popup');
    popup.style.display = popup.style.display === 'flex' ? 'none' : 'flex';
    popup.style.display === 'flex' && popup.scrollIntoView({ behavior: 'smooth' });
  }
  
  function logout() {
    alert("Logged out successfully!");
    window.location.href = "login.html";
  }
  
// Wait for the DOM to be fully loaded
document.addEventListener('DOMContentLoaded', function() {
    // Initialize tab functionality
    initializeTabs();
    
    // Initialize form submissions
    initializeForms();
    
    // Initialize avatar upload
    initializeAvatarUpload();
    
    // Initialize notification toggles
    initializeNotificationToggles();
});

// Tab switching functionality
function initializeTabs() {
    const tabLinks = document.querySelectorAll('.profile-nav a');
    const tabPanes = document.querySelectorAll('.tab-pane');
    
    tabLinks.forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            
            // Remove active class from all links and panes
            tabLinks.forEach(l => l.classList.remove('active'));
            tabPanes.forEach(p => p.classList.remove('active'));
            
            // Add active class to clicked link
            link.classList.add('active');
            
            // Show corresponding tab pane
            const targetTab = document.querySelector(`#${link.dataset.tab}`);
            if (targetTab) {
                targetTab.classList.add('active');
            }
            
            // Update URL hash without scrolling
            history.pushState(null, '', link.getAttribute('href'));
        });
    });
    
    // Handle initial tab on page load
    const hash = window.location.hash;
    if (hash) {
        const activeTab = document.querySelector(`[href="${hash}"]`);
        if (activeTab) {
            activeTab.click();
        }
    }
}

// Form submission handling
function initializeForms() {
    const forms = document.querySelectorAll('.settings-form');
    
    forms.forEach(form => {
        form.addEventListener('submit', async (e) => {
            e.preventDefault();
            
            const formData = new FormData(form);
            const submitButton = form.querySelector('button[type="submit"]');
            const originalText = submitButton.textContent;
            
            try {
                // Show loading state
                submitButton.disabled = true;
                submitButton.textContent = 'Saving...';
                
                // Simulate API call (replace with actual API endpoint)
                await new Promise(resolve => setTimeout(resolve, 1000));
                
                // Show success message
                showNotification('Changes saved successfully!', 'success');
                
            } catch (error) {
                // Show error message
                showNotification('Failed to save changes. Please try again.', 'error');
                
            } finally {
                // Reset button state
                submitButton.disabled = false;
                submitButton.textContent = originalText;
            }
        });
    });
}

// Avatar upload functionality
function initializeAvatarUpload() {
    const avatarButton = document.querySelector('.edit-avatar');
    const avatarImg = document.querySelector('.profile-avatar img');
    
    if (avatarButton && avatarImg) {
        avatarButton.addEventListener('click', () => {
            // Create file input
            const fileInput = document.createElement('input');
            fileInput.type = 'file';
            fileInput.accept = 'image/*';
            
            fileInput.addEventListener('change', async (e) => {
                const file = e.target.files[0];
                if (file) {
                    try {
                        // Show loading state
                        avatarButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
                        
                        // Create preview
                        const reader = new FileReader();
                        reader.onload = function(e) {
                            avatarImg.src = e.target.result;
                        };
                        reader.readAsDataURL(file);
                        
                        // Simulate upload (replace with actual API call)
                        await new Promise(resolve => setTimeout(resolve, 1500));
                        
                        showNotification('Profile picture updated successfully!', 'success');
                        
                    } catch (error) {
                        showNotification('Failed to update profile picture.', 'error');
                        
                    } finally {
                        // Reset button state
                        avatarButton.innerHTML = '<i class="fas fa-camera"></i>';
                    }
                }
            });
            
            fileInput.click();
        });
    }
}

// Notification toggle functionality
function initializeNotificationToggles() {
    const toggles = document.querySelectorAll('.notification-option input[type="checkbox"]');
    
    toggles.forEach(toggle => {
        toggle.addEventListener('change', async (e) => {
            const isChecked = e.target.checked;
            const settingName = e.target.closest('.notification-option').querySelector('h4').textContent;
            
            try {
                // Simulate API call
                await new Promise(resolve => setTimeout(resolve, 500));
                
                showNotification(`${settingName} notifications ${isChecked ? 'enabled' : 'disabled'}.`, 'success');
                
            } catch (error) {
                // Revert toggle state on error
                e.target.checked = !isChecked;
                showNotification('Failed to update notification settings.', 'error');
            }
        });
    });
}

// Notification display function
function showNotification(message, type = 'success') {
    // Create notification element
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;
    notification.innerHTML = `
        <i class="fas fa-${type === 'success' ? 'check-circle' : 'exclamation-circle'}"></i>
        <span>${message}</span>
    `;
    
    // Add styles
    Object.assign(notification.style, {
        position: 'fixed',
        top: '20px',
        right: '20px',
        padding: '12px 24px',
        background: type === 'success' ? '#4caf50' : '#f44336',
        color: 'white',
        borderRadius: '8px',
        boxShadow: '0 2px 10px rgba(0,0,0,0.1)',
        display: 'flex',
        alignItems: 'center',
        gap: '8px',
        zIndex: '1000',
        opacity: '0',
        transform: 'translateY(-20px)',
        transition: 'all 0.3s ease'
    });
    
    // Add to DOM
    document.body.appendChild(notification);
    
    // Trigger animation
    setTimeout(() => {
        notification.style.opacity = '1';
        notification.style.transform = 'translateY(0)';
    }, 10);
    
    // Remove after delay
    setTimeout(() => {
        notification.style.opacity = '0';
        notification.style.transform = 'translateY(-20px)';
        setTimeout(() => notification.remove(), 300);
    }, 3000);
}

// Handle back/forward browser navigation
window.addEventListener('popstate', () => {
    const hash = window.location.hash;
    if (hash) {
        const activeTab = document.querySelector(`[href="${hash}"]`);
        if (activeTab) {
            activeTab.click();
        }
    }
});
  