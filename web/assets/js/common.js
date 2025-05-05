// Load Header and Footer
// async function loadComponent(containerId, componentPath) {
//     try {
//         const response = await fetch(componentPath);
//         const html = await response.text();
//         document.getElementById(containerId).innerHTML = html;
//     } catch (error) {
//         console.error(`Error loading ${componentPath}:`, error);
//     }
// }

// Header and Footer Functionality
// document.addEventListener('DOMContentLoaded', async function() {
//     // Load header and footer
//     await loadComponent('header-container', 'components/header.html');
//     await loadComponent('footer-container', 'components/footer.html');
//     ...
// });

// Sticky Header
const header = document.querySelector('.main-header');
if (header) {
    let lastScrollTop = 0;

    window.addEventListener('scroll', () => {
        let scrollTop = window.pageYOffset || document.documentElement.scrollTop;
        
        if (scrollTop > lastScrollTop && scrollTop > 100) {
            // Scrolling down and not at the top
            header.style.transform = 'translateY(-100%)';
        } else {
            // Scrolling up or at the top
            header.style.transform = 'translateY(0)';
        }
        lastScrollTop = scrollTop;
    });
}

// Search Bar Functionality
const searchInput = document.querySelector('.search-bar input');
const searchButton = document.querySelector('.search-bar button');

if (searchInput && searchButton) {
    searchButton.addEventListener('click', (e) => {
        e.preventDefault();
        performSearch();
    });

    searchInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') {
            e.preventDefault();
            performSearch();
        }
    });
}

function performSearch() {
    const query = searchInput.value.trim();
    if (query) {
        // Implement search functionality
        console.log('Searching for:', query);
        // You can add your search implementation here
    }
}

// Cart Badge Update
// Update Cart Badge
function updateCartBadge(count) {
    const cartBadge = document.querySelector('.nav-icon[data-type="cart"] .badge');
    if (cartBadge) {
        cartBadge.textContent = count;
        cartBadge.style.display = count > 0 ? 'block' : 'none';
    }
}

// Wishlist Badge Update
function updateWishlistBadge(count) {
    const wishlistBadge = document.querySelector('.nav-icon[data-type="wishlist"] .badge');
    if (wishlistBadge) {
        wishlistBadge.textContent = count;
        wishlistBadge.style.display = count > 0 ? 'block' : 'none';
    }
}

// Newsletter Form Submission
const newsletterForm = document.querySelector('.newsletter-form');
if (newsletterForm) {
    newsletterForm.addEventListener('submit', (e) => {
        e.preventDefault();
        const emailInput = newsletterForm.querySelector('input[type="email"]');
        const email = emailInput.value.trim();

        if (validateEmail(email)) {
            // Implement newsletter subscription
            console.log('Newsletter subscription for:', email);
            // Show success message
            showNewsletterMessage('Thank you for subscribing!', 'success');
            emailInput.value = '';
        } else {
            showNewsletterMessage('Please enter a valid email address.', 'error');
        }
    });
}

function validateEmail(email) {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
}

function showNewsletterMessage(message, type) {
    const existingMessage = document.querySelector('.newsletter-message');
    if (existingMessage) {
        existingMessage.remove();
    }

    const messageElement = document.createElement('div');
    messageElement.className = `newsletter-message ${type}`;
    messageElement.textContent = message;

    const form = document.querySelector('.newsletter-form');
    if (form) {
        form.insertAdjacentElement('afterend', messageElement);

        setTimeout(() => {
            messageElement.remove();
        }, 3000);
    }
}

// Mobile Menu Toggle
const mobileMenuButton = document.querySelector('.mobile-menu-toggle');
const categoryNav = document.querySelector('.category-nav');

if (mobileMenuButton && categoryNav) {
    mobileMenuButton.addEventListener('click', () => {
        categoryNav.classList.toggle('active');
        mobileMenuButton.classList.toggle('active');
    });
}

// Initialize badges
updateCartBadge(0);
updateWishlistBadge(0);

// Expose functions that might be needed by other scripts
window.updateCartBadge = updateCartBadge;
window.updateWishlistBadge = updateWishlistBadge;

// Add this function globally for category navigation
function goToCategory(category) {
    if (category) {
        window.location.href = 'products.jsp?category=' + encodeURIComponent(category);
    } else {
        window.location.href = 'products.jsp';
    }
}

// Add to Cart AJAX logic
function addToCart(productId) {
    console.log('Adding to cart, productId:', productId);
    
    // Get client ID from session storage or global variable
    const clientId = window.userId || sessionStorage.getItem('userId');
    
    if (!clientId) {
        alert('Please login to add items to cart');
        window.location.href = 'login.html';
        return;
    }

    if (!productId) {
        alert('Invalid product ID');
        return;
    }

    // Convert productId to number to ensure it's a valid integer
    productId = parseInt(productId, 10);
    if (isNaN(productId)) {
        alert('Invalid product ID');
        return;
    }

    const formData = new URLSearchParams();
    formData.append('action', 'add');
    formData.append('c_id', clientId);
    formData.append('product_id', productId);
    formData.append('quantity', '1');

    fetch('CartServlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: formData
    })
    .then(response => {
        if (!response.ok) {
            return response.text().then(text => {
                throw new Error(text || 'Failed to add to cart');
            });
        }
        return response.text();
    })
    .then(text => {
        if (text.toLowerCase().includes('success')) {
            alert('Added to cart successfully!');
            // Update cart badge after successful addition
            updateCartBadge();
        } else {
            throw new Error(text);
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('Error adding to cart: ' + error.message);
    });
}

// Initialize cart badge on page load
document.addEventListener('DOMContentLoaded', () => {
    updateCartBadge();
});

// Update cart badge
function updateCartBadge() {
    const clientId = window.userId || sessionStorage.getItem('userId');
    if (!clientId) return;

    fetch(`CartServlet?action=getCount&c_id=${encodeURIComponent(clientId)}`, {
        method: 'GET',
        headers: {
            'Accept': 'text/plain'
        }
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Failed to get cart count');
        }
        return response.text();
    })
    .then(count => {
        const badge = document.querySelector('.nav-icon[data-type="cart"] .badge');
        if (badge) {
            badge.textContent = count;
            badge.style.display = count > 0 ? 'block' : 'none';
        }
    })
    .catch(error => {
        console.error('Error updating cart badge:', error);
    });
}

