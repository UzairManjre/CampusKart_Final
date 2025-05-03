// Initial setup
document.body.style.opacity = '0';
document.body.style.transition = 'opacity 0.5s ease';

// Fade in the body when page loads
window.addEventListener('load', () => {
    document.body.style.opacity = '1';
});

// Stagger animations for form elements
window.addEventListener('DOMContentLoaded', () => {
    // Animate illustration
    gsap.from('[data-gsap="fade-right"]', {
        x: -100,
        opacity: 0,
        duration: 1,
        ease: 'power3.out'
    });

    // Animate brand name
    gsap.from('[data-gsap="fade-down"]', {
        y: -50,
        opacity: 0,
        duration: 0.8,
        ease: 'power3.out'
    });

    // Create timeline for form elements
    const formTimeline = gsap.timeline({
        defaults: {
            duration: 0.5,
            ease: 'power2.out'
        }
    });

    // Animate form elements in sequence
    formTimeline
        .from('.title', {
            y: 30,
            opacity: 0
        })
        .from('.register-text, .login-text', {
            y: 20,
            opacity: 0
        }, '-=0.3')
        .from('.input-group', {
            y: 20,
            opacity: 0,
            stagger: 0.1
        }, '-=0.2')
        .from('.options-group', {
            y: 20,
            opacity: 0
        }, '-=0.2')
        .from('.login-btn, .register-btn', {
            y: 20,
            opacity: 0
        }, '-=0.1')
        .from('.divider', {
            scale: 0.8,
            opacity: 0
        }, '-=0.2')
        .from('.social-login', {
            y: 20,
            opacity: 0
        }, '-=0.1');

    // Add hover animations for buttons
    const buttons = document.querySelectorAll('.login-btn, .register-btn, .social-btn');
    buttons.forEach(button => {
        button.addEventListener('mouseenter', () => {
            if (button.classList.contains('login-btn') || button.classList.contains('register-btn')) {
                gsap.to(button, {
                    scale: 1.03,
                    y: -2,
                    duration: 0.3,
                    ease: 'power2.out',
                    boxShadow: '0 6px 15px rgba(0, 0, 51, 0.2)'
                });
            } else {
                gsap.to(button, {
                    scale: 1.05,
                    duration: 0.3,
                    ease: 'power2.out'
                });
            }
        });

        button.addEventListener('mouseleave', () => {
            if (button.classList.contains('login-btn') || button.classList.contains('register-btn')) {
                gsap.to(button, {
                    scale: 1,
                    y: 0,
                    duration: 0.3,
                    ease: 'power2.out',
                    boxShadow: 'none'
                });
            } else {
                gsap.to(button, {
                    scale: 1,
                    duration: 0.3,
                    ease: 'power2.out'
                });
            }
        });
    });

    // Add click animation for login/register button
    const mainButton = document.querySelector('.login-btn, .register-btn');
    if (mainButton) {
        mainButton.addEventListener('click', () => {
            gsap.to(mainButton, {
                scale: 0.95,
                duration: 0.1,
                ease: 'power2.in',
                yoyo: true,
                repeat: 1
            });
        });
    }

    // Add focus animations for input fields
    const inputs = document.querySelectorAll('input');
    inputs.forEach(input => {
        input.addEventListener('focus', () => {
            gsap.to(input.closest('.input-wrapper'), {
                scale: 1.02,
                boxShadow: '0 0 0 2px rgba(0, 0, 51, 0.1)',
                duration: 0.3,
                ease: 'power2.out'
            });
        });

        input.addEventListener('blur', () => {
            gsap.to(input.closest('.input-wrapper'), {
                scale: 1,
                boxShadow: 'none',
                duration: 0.3,
                ease: 'power2.out'
            });
        });
    });

    // Add shake animation for form validation
    const form = document.querySelector('form');
    form.addEventListener('submit', (e) => {
        e.preventDefault();
        
        // Example validation - you can modify this based on your needs
        const inputs = form.querySelectorAll('input[required]');
        let isValid = true;
        
        inputs.forEach(input => {
            if (!input.value) {
                isValid = false;
                gsap.to(input.closest('.input-wrapper'), {
                    x: [-10, 10, -10, 10, 0],
                    duration: 0.5,
                    ease: 'power2.out'
                });
            }
        });

        if (isValid) {
            // Add success animation
            gsap.to(form, {
                scale: 0.95,
                opacity: 0,
                duration: 0.5,
                ease: 'power2.in',
                onComplete: () => {
                    // Here you can add your form submission logic
                    console.log('Form submitted successfully!');
                }
            });
        }
    });

    // Page transition for links
    const links = document.querySelectorAll('a[href]');
    links.forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            const target = link.getAttribute('href');
            
            gsap.to('body', {
                opacity: 0,
                duration: 0.5,
                ease: 'power2.in',
                onComplete: () => {
                    window.location.href = target;
                }
            });
        });
    });
}); 