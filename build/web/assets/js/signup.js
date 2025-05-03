document.addEventListener('DOMContentLoaded', function() {
    // Get all password toggle icons
    const togglePassword = document.querySelectorAll('.toggle-password');
    
    // Add click event to each toggle icon
    togglePassword.forEach(icon => {
        icon.addEventListener('click', function() {
            const input = this.previousElementSibling;
            
            // Toggle password visibility
            if (input.type === 'password') {
                input.type = 'text';
                this.classList.remove('fa-eye-slash');
                this.classList.add('fa-eye');
            } else {
                input.type = 'password';
                this.classList.remove('fa-eye');
                this.classList.add('fa-eye-slash');
            }
        });
    });

    // Form validation
    const form = document.querySelector('.signup-form');
    const password = document.getElementById('password');
    const confirmPassword = document.getElementById('confirm-password');

    form.addEventListener('submit', function(e) {
        e.preventDefault();

        // Basic validation
        if (password.value !== confirmPassword.value) {
            alert('Passwords do not match!');
            return;
        }

        if (password.value.length < 6) {
            alert('Password must be at least 6 characters long!');
            return;
        }

        // If validation passes, you can submit the form
        console.log('Form submitted successfully!');
        // Add your form submission logic here
    });
}); 