document.addEventListener("DOMContentLoaded", function () {
    const form = document.querySelector("form");
  
    if (form) {
        form.addEventListener("submit", function (e) {
            e.preventDefault(); // stop form from refreshing page
  
            const email = form.querySelector('input[type="email"]').value.trim();
            const username = form.querySelector('input[type="text"]').value.trim();
            const password = form.querySelectorAll('input[type="password"]')[0].value.trim();
            const confirmPassword = form.querySelectorAll('input[type="password"]')[1].value.trim();
  
            if (!email || !username || !password || !confirmPassword) {
                alert("Please fill in all fields.");
                return;
            }
  
            if (password !== confirmPassword) {
                alert("Passwords do not match.");
                return;
            }
  
            // Simulate successful sign-up
            alert(`Welcome, ${username}! Your account has been created.`);
            form.reset(); // clear form
        });
    }
});
  
// n key navigation to products
document.addEventListener('keypress', (e) => {
    if (e.key.toLowerCase() === 'n') {
        window.location.href = '#products';
        document.querySelector('#products').scrollIntoView({
            behavior: 'smooth'
        });
    }
});

// Smooth scroll for all anchor links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        document.querySelector(this.getAttribute('href')).scrollIntoView({
            behavior: 'smooth'
        });
    });
});
