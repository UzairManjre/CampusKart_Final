// Order Confirmation functionality
document.addEventListener('DOMContentLoaded', function() {
    // Load order details from localStorage or URL parameters
    loadOrderDetails();
    
    // Update order items
    loadOrderItems();
});

// Function to load order details
function loadOrderDetails() {
    // Get order details from localStorage
    const orderData = JSON.parse(localStorage.getItem('orderData')) || {};
    
    // Update shipping address
    const shippingAddress = document.getElementById('shipping-address');
    if (shippingAddress && orderData.shipping) {
        const address = `
            ${orderData.shipping['full-name']}<br>
            ${orderData.shipping.address}<br>
            ${orderData.shipping.city}, ${orderData.shipping.state} ${orderData.shipping.zip}<br>
            ${orderData.shipping.country}
        `;
        shippingAddress.innerHTML = address;
    }
    
    // Update payment method
    const paymentMethod = document.getElementById('payment-method');
    if (paymentMethod && orderData.payment) {
        const method = orderData.payment['payment-method'] || 'Credit Card';
        paymentMethod.textContent = `Payment Method: ${method}`;
    }
    
    // Update payment amount
    const paymentAmount = document.getElementById('payment-amount');
    if (paymentAmount && orderData.total) {
        paymentAmount.textContent = `Amount Paid: ${orderData.total}`;
    }
}

// Function to load order items
function loadOrderItems() {
    const orderData = JSON.parse(localStorage.getItem('orderData')) || {};
    const orderItems = orderData.items || [];
    const orderItemsContainer = document.querySelector('.order-items');
    
    if (!orderItemsContainer || orderItems.length === 0) {
        return;
    }
    
    // Clear existing items
    orderItemsContainer.innerHTML = '';
    
    // Add items
    orderItems.forEach(item => {
        const orderItem = createOrderItem(item);
        orderItemsContainer.appendChild(orderItem);
    });
    
    // Update order total
    updateOrderTotal(orderData.total);
}

// Function to create order item element
function createOrderItem(item) {
    const div = document.createElement('div');
    div.className = 'order-item';
    div.innerHTML = `
        <img src="${item.image}" alt="${item.name}">
        <div class="order-item-details">
            <h4>${item.name}</h4>
            <p>₹${item.price} × ${item.quantity || 1}</p>
        </div>
    `;
    return div;
}

// Function to update order total
function updateOrderTotal(total) {
    const totalElement = document.querySelector('.summary-row.total span:last-child');
    if (totalElement && total) {
        totalElement.textContent = total;
    }
}

// Function to generate order number
function generateOrderNumber() {
    const timestamp = Date.now();
    const random = Math.floor(Math.random() * 1000);
    return `#ORD-${timestamp}${random}`;
}

// Clear order data from localStorage after displaying
window.addEventListener('beforeunload', function() {
    localStorage.removeItem('orderData');
}); 