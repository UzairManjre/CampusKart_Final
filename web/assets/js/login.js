document.addEventListener('DOMContentLoaded', function() {
    const loginForm = document.getElementById('loginForm');
    const passwordInput = document.getElementById('password');
    const passwordError = document.createElement('div');
    passwordError.className = 'error-message';
    passwordInput.parentNode.appendChild(passwordError);

    // Password validation function
    function validatePassword(password) {
        // At least 8 characters
        if (password.length < 8) {
            return 'Password must be at least 8 characters long';
        }
        
        // At least one number
        if (!/\d/.test(password)) {
            return 'Password must contain at least one number';
        }
        
        // At least one symbol (special character)
        if (!/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)) {
            return 'Password must contain at least one symbol';
        }
        
        return null; // No error
    }

    // Real-time password validation
    passwordInput.addEventListener('input', function() {
        const error = validatePassword(this.value);
        if (error) {
            passwordError.textContent = error;
            passwordError.style.display = 'block';
            this.style.borderColor = '#ff4444';
        } else {
            passwordError.style.display = 'none';
            this.style.borderColor = '#ddd';
        }
    });

    // Password visibility toggle
    const togglePassword = document.querySelector('.toggle-password');
    togglePassword.addEventListener('click', function() {
        // Toggle password visibility
        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            this.classList.remove('fa-eye-slash');
            this.classList.add('fa-eye');
        } else {
            passwordInput.type = 'password';
            this.classList.remove('fa-eye');
            this.classList.add('fa-eye-slash');
        }
    });

    // Form submission
    const form = document.querySelector('.login-form');
    const rememberMe = document.getElementById('remember');

    form.addEventListener('submit', function(e) {
        e.preventDefault();

        const email = document.getElementById('email').value;
        const password = passwordInput.value;
        const isRemembered = rememberMe.checked;

        // Basic validation
        if (!email || !password) {
            alert('Please fill in all fields');
            return;
        }

        // Here you would typically send the data to your backend
        console.log('Login attempt:', {
            email,
            password: '********',
            isRemembered
        });

        // For demo purposes
        console.log('Login successful!');
    });

    // Social login handlers
    const socialButtons = document.querySelectorAll('.social-btn');
    socialButtons.forEach(button => {
        button.addEventListener('click', function() {
            const provider = this.classList[1]; // facebook, apple, or google
            console.log(`Attempting to login with ${provider}`);
            // Implement social login logic here
        });
    });
});

document.addEventListener('DOMContentLoaded', () => {
    const form = document.querySelector('.login-form');
    const usernameInput = document.getElementById('username');

    form.addEventListener('submit', (e) => {
        e.preventDefault();  // Prevent default form submission

        const username = usernameInput.value.trim();

        // Basic validation
        if (username !== '') {
            // Animate and then submit the form
            gsap.to(form, {
                scale: 0.95,
                opacity: 0,
                duration: 0.5,
                ease: 'power2.in',
                onComplete: () => {
                    form.submit();  // ✅ This manually triggers the servlet call
                }
            });
        } else {
            alert("Please enter a valid username.");
        }
    });
});