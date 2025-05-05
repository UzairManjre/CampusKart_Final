// Cart functionality
document.addEventListener('DOMContentLoaded', function() {
    loadCartData();
    const checkoutBtn = document.getElementById('checkoutBtn');
    if (checkoutBtn) {
        checkoutBtn.addEventListener('click', checkout);
    }
});

function loadCartData() {
    const userId = window.userId || sessionStorage.getItem('userId');
    if (userId) {
        // Logged-in user: fetch cart from backend
        fetch(`CartServlet?action=getCart&c_id=${encodeURIComponent(userId)}`)
            .then(response => response.text())
            .then(text => {
                const cartItems = parseCartData(text);
                renderCart(cartItems);
            })
            .catch(() => {
                showEmptyCart('Error loading cart. Please try again.');
            });
    } else {
        // Guest user: use localStorage
        const cartItems = JSON.parse(localStorage.getItem('cartItems')) || [];
        renderCart(cartItems);
    }
}

function parseCartData(text) {
    if (!text.trim()) return [];
    return text.trim().split('\n').map(line => {
        const [productId, productName, price, quantity, imagePath] = line.split('|');
        return {
            productId: parseInt(productId),
            productName: productName,
            price: parseFloat(price),
            quantity: parseInt(quantity),
            imagePath: imagePath
        };
    });
}

function renderCart(items) {
    const container = document.getElementById('cartItemsContainer');
    const summary = document.getElementById('cartSummary');
    const emptyCart = document.getElementById('emptyCart');
    if (!items.length) {
        container.innerHTML = '';
        summary.style.display = 'none';
        emptyCart.style.display = '';
        return;
    }
    emptyCart.style.display = 'none';
    summary.style.display = '';

    let subtotal = 0;
    container.innerHTML = items.map(item => {
        subtotal += item.price * item.quantity;
        let imagePath = item.imagePath || 'assets/images/default-product.jpg';
        if (
            imagePath &&
            !imagePath.startsWith('http') &&
            !imagePath.startsWith('/') &&
            !imagePath.startsWith('uploaded_images/')
        ) {
            imagePath = 'uploaded_images/' + imagePath;
        }
        return `
            <div class="cart-item">
                <div class="item-image">
                    <img src="${imagePath}" alt="${item.productName}" onerror="this.src='assets/images/default-product.jpg'">
                </div>
                <div class="item-details">
                    <h3>${item.productName}</h3>
                    <p class="item-price">₹${item.price.toFixed(2)}</p>
                    <div class="item-quantity">
                        <button onclick="updateQuantity(${item.productId}, ${item.quantity - 1})">-</button>
                        <input type="number" value="${item.quantity}" min="1" onchange="updateQuantity(${item.productId}, this.value)">
                        <button onclick="updateQuantity(${item.productId}, ${item.quantity + 1})">+</button>
                    </div>
                </div>
                <div class="item-actions">
                    <button class="remove-item" onclick="removeFromCart(${item.productId})">
                        <i class="fas fa-trash"></i>
                    </button>
                </div>
            </div>
        `;
    }).join('');
    document.getElementById('cartSubtotal').textContent = `₹${subtotal.toFixed(2)}`;
    document.getElementById('cartTotal').textContent = `₹${subtotal.toFixed(2)}`;
}

function showEmptyCart(message, link, linkText) {
    const emptyCart = document.getElementById('emptyCart');
    emptyCart.style.display = '';
    emptyCart.innerHTML = `
        <h2>${message}</h2>
        ${link ? `<a href="${link}" class="continue-shopping">${linkText}</a>` : ''}
    `;
    document.getElementById('cartItemsContainer').innerHTML = '';
    document.getElementById('cartSummary').style.display = 'none';
}

function updateQuantity(productId, newQuantity) {
    const userId = window.userId || sessionStorage.getItem('userId');
    if (!userId) {
        alert('Please login to update cart items');
        window.location.href = 'login.jsp';
        return;
    }
    if (newQuantity < 1) return;
    const formData = new URLSearchParams();
    formData.append('action', 'update');
    formData.append('c_id', userId);
    formData.append('product_id', productId);
    formData.append('quantity', newQuantity);

    fetch('CartServlet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: formData
    })
    .then(response => response.text())
    .then(text => {
        if (text.toLowerCase().includes('success')) {
            loadCartData();
            if (window.updateCartBadge) window.updateCartBadge();
        } else {
            throw new Error(text);
        }
    })
    .catch(error => alert('Error updating quantity: ' + error.message));
}

function removeFromCart(productId) {
    const userId = window.userId || sessionStorage.getItem('userId');
    if (!userId) {
        alert('Please login to remove items from cart');
        window.location.href = 'login.jsp';
        return;
    }
    if (!confirm('Are you sure you want to remove this item from your cart?')) return;
    const formData = new URLSearchParams();
    formData.append('action', 'remove');
    formData.append('c_id', userId);
    formData.append('product_id', productId);

    fetch('CartServlet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: formData
    })
    .then(response => response.text())
    .then(text => {
        if (text.toLowerCase().includes('success')) {
            loadCartData();
            if (window.updateCartBadge) window.updateCartBadge();
        } else {
            throw new Error(text);
        }
    })
    .catch(error => alert('Error removing item: ' + error.message));
}

function checkout() {
    const userId = window.userId || sessionStorage.getItem('userId');
    if (!userId) {
        alert('Please login to proceed with checkout');
        window.location.href = 'login.html';
        return;
    }
    // Redirect to checkout page
    window.location.href = 'checkout.jsp';
}

// Function to update quantity
function updateQuantity(button, change) {
    const input = button.parentElement.querySelector('input');
    let newValue = parseInt(input.value) + change;
    
    if (newValue < 1) newValue = 1;
    
    input.value = newValue;
    updateCartTotal();
}

// Function to remove item from cart
function removeItem(button) {
    const cartItem = button.closest('.cart-item');
    cartItem.remove();
    
    // Check if cart is empty
    checkEmptyCart();
    updateCartCount();
    updateCartTotal();
}

// Function to move item to wishlist
function moveToWishlist(button) {
    const cartItem = button.closest('.cart-item');
    const itemData = {
        name: cartItem.querySelector('h3').textContent,
        price: cartItem.querySelector('.item-price').textContent,
        image: cartItem.querySelector('img').src
    };
    
    // Add to wishlist (you'll need to implement wishlist functionality)
    console.log('Moving to wishlist:', itemData);
    
    // Remove from cart
    cartItem.remove();
    checkEmptyCart();
    updateCartCount();
    updateCartTotal();
}

// Function to check if cart is empty
function checkEmptyCart() {
    const cartItems = document.querySelector('.cart-items');
    const emptyCart = document.querySelector('.empty-cart');
    const cartContent = document.querySelector('.cart-content');
    
    if (cartItems.querySelectorAll('.cart-item').length === 0) {
        emptyCart.style.display = 'block';
        cartContent.style.display = 'none';
    } else {
        emptyCart.style.display = 'none';
        cartContent.style.display = 'grid';
    }
}

// Function to update cart total
function updateCartTotal() {
    let subtotal = 0;
    const cartItems = document.querySelectorAll('.cart-item');
    
    cartItems.forEach(item => {
        const price = parseFloat(item.querySelector('.item-price').textContent.replace('₹', ''));
        const quantity = parseInt(item.querySelector('input').value);
        subtotal += price * quantity;
    });
    
    const tax = subtotal * 0.1; // 10% tax
    const total = subtotal + tax;
    
    // Update summary
    document.querySelector('.summary-row:nth-child(1) span:last-child').textContent = `₹${subtotal.toFixed(2)}`;
    document.querySelector('.summary-row:nth-child(3) span:last-child').textContent = `₹${tax.toFixed(2)}`;
    document.querySelector('.summary-row.total span:last-child').textContent = `₹${total.toFixed(2)}`;
}

// Function to load cart items from localStorage
function loadCartItems() {
    const cartItems = JSON.parse(localStorage.getItem('cartItems')) || [];
    
    if (cartItems.length === 0) {
        checkEmptyCart();
        return;
    }
    
    // Clear existing items
    const cartContainer = document.querySelector('.cart-items');
    const existingItems = cartContainer.querySelectorAll('.cart-item');
    existingItems.forEach(item => item.remove());
    
    // Add items from localStorage
    cartItems.forEach(item => {
        const cartItem = createCartItem(item);
        cartContainer.insertBefore(cartItem, cartContainer.querySelector('.empty-cart'));
    });
    
    updateCartTotal();
}

// Function to create cart item element
function createCartItem(item) {
    const div = document.createElement('div');
    div.className = 'cart-item';
    div.innerHTML = `
        <div class="item-image">
            <img src="${item.image}" alt="${item.name}">
        </div>
        <div class="item-details">
            <h3>${item.name}</h3>
            <p class="item-price">₹${item.price}</p>
            <div class="item-quantity">
                <button onclick="updateQuantity(this, -1)">-</button>
                <input type="number" value="${item.quantity || 1}" min="1">
                <button onclick="updateQuantity(this, 1)">+</button>
            </div>
        </div>
        <div class="item-actions">
            <button class="remove-item" onclick="removeItem(this)">
                <i class="fas fa-trash"></i>
            </button>
            <button class="move-to-wishlist" onclick="moveToWishlist(this)">
                <i class="far fa-heart"></i>
            </button>
        </div>
    `;
    return div;
}

// Function to update cart count in header
function updateCartCount() {
    const cartItems = document.querySelectorAll('.cart-item');
    const cartCount = document.querySelector('.nav-icon[href="cart.jsp"] .badge');
    
    if (cartCount) {
        cartCount.textContent = cartItems.length;
        cartCount.style.display = cartItems.length > 0 ? 'block' : 'none';
    }
}

// Event listener for coupon application
document.querySelector('.coupon-section button')?.addEventListener('click', function() {
    const couponInput = document.querySelector('.coupon-section input');
    const couponCode = couponInput.value.trim();
    
    if (couponCode) {
        // Here you would typically validate the coupon with your backend
        console.log('Applying coupon:', couponCode);
        // Show success/error message
    }
}); 