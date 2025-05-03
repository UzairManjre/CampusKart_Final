document.addEventListener('DOMContentLoaded', function() {
    // Thumbnail image handling
    const mainImage = document.getElementById('mainImage');
    const thumbnails = document.querySelectorAll('.thumbnails img');
    const thumbnailContainer = document.querySelector('.thumbnails');
    const leftScroll = document.querySelector('.thumb-scroll-btn.left');
    const rightScroll = document.querySelector('.thumb-scroll-btn.right');

    // Thumbnail click handling
    thumbnails.forEach(thumb => {
        thumb.addEventListener('click', function() {
            // Update main image
            mainImage.src = this.src;
            
            // Update active state
            thumbnails.forEach(t => t.classList.remove('active'));
            this.classList.add('active');
        });
    });

    // Thumbnail scrolling
    leftScroll.addEventListener('click', () => {
        thumbnailContainer.scrollBy({
            left: -100,
            behavior: 'smooth'
        });
    });

    rightScroll.addEventListener('click', () => {
        thumbnailContainer.scrollBy({
            left: 100,
            behavior: 'smooth'
        });
    });

    // Color selection handling
    const colorOptions = document.querySelectorAll('.color-option');
    const selectedColorText = document.querySelector('.selected-color');

    colorOptions.forEach(option => {
        option.addEventListener('click', function() {
            // Update active state
            colorOptions.forEach(opt => opt.classList.remove('active'));
            this.classList.add('active');
            
            // Update selected color text
            selectedColorText.textContent = this.dataset.color;
        });
    });

    // Wishlist button handling
    const wishlistBtn = document.querySelector('.wishlist-btn');
    let isWishlisted = false;

    wishlistBtn.addEventListener('click', function() {
        isWishlisted = !isWishlisted;
        const icon = this.querySelector('i');
        
        if (isWishlisted) {
            icon.classList.remove('far');
            icon.classList.add('fas');
            icon.style.color = '#ff4444';
        } else {
            icon.classList.remove('fas');
            icon.classList.add('far');
            icon.style.color = '#000';
        }
    });

    // Share button handling
    const shareBtn = document.querySelector('.share-btn');
    
    shareBtn.addEventListener('click', function() {
        if (navigator.share) {
            navigator.share({
                title: document.querySelector('.product-name').textContent,
                text: document.querySelector('.product-description').textContent,
                url: window.location.href
            })
            .catch(console.error);
        } else {
            // Fallback for browsers that don't support Web Share API
            const dummy = document.createElement('textarea');
            document.body.appendChild(dummy);
            dummy.value = window.location.href;
            dummy.select();
            document.execCommand('copy');
            document.body.removeChild(dummy);
            
            alert('Link copied to clipboard!');
        }
    });

    // Add to Cart button handling
    const addToCartBtn = document.querySelector('.add-to-cart');
    
    addToCartBtn.addEventListener('click', function() {
        const product = {
            name: document.querySelector('.product-name').textContent,
            price: document.querySelector('.current-price').textContent,
            color: document.querySelector('.selected-color').textContent,
            quantity: 1
        };

        // Here you would typically send this to a cart management system
        console.log('Adding to cart:', product);
        
        // Add animation effect
        this.classList.add('adding');
        setTimeout(() => this.classList.remove('adding'), 1000);
    });
});

// Image Gallery
function changeImage(src) {
    document.getElementById('mainImage').src = src;
}

// Quantity Selector
function updateQuantity(change) {
    const quantityInput = document.getElementById('quantity');
    let newValue = parseInt(quantityInput.value) + change;
    
    // Ensure quantity doesn't go below 1
    if (newValue < 1) newValue = 1;
    
    quantityInput.value = newValue;
}

// Tab Switching
function switchTab(tabId) {
    // Hide all tab panes
    document.querySelectorAll('.tab-pane').forEach(pane => {
        pane.classList.remove('active');
    });
    
    // Deactivate all tab buttons
    document.querySelectorAll('.tab-button').forEach(button => {
        button.classList.remove('active');
    });
    
    // Show selected tab pane
    document.getElementById(tabId).classList.add('active');
    
    // Activate selected tab button
    document.querySelector(`[onclick="switchTab('${tabId}')"]`).classList.add('active');
}

// Add to Cart
document.querySelector('.add-to-cart').addEventListener('click', function() {
    const quantity = parseInt(document.getElementById('quantity').value);
    console.log(`Adding ${quantity} items to cart`);
    // Update cart badge
    if (window.updateCartBadge) {
        const currentCount = parseInt(document.querySelector('.nav-icon[data-type="cart"] .badge').textContent || '0');
        window.updateCartBadge(currentCount + quantity);
    }
});

// Add to Wishlist
document.querySelector('.add-to-wishlist').addEventListener('click', function() {
    console.log('Adding item to wishlist');
    // Update wishlist badge
    if (window.updateWishlistBadge) {
        const currentCount = parseInt(document.querySelector('.nav-icon[data-type="wishlist"] .badge').textContent || '0');
        window.updateWishlistBadge(currentCount + 1);
    }
}); 