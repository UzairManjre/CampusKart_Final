// Checkout functionality
document.addEventListener('DOMContentLoaded', function() {
    // Load cart items into order summary
    loadOrderItems();
    
    // Initialize payment method selection
    initPaymentMethods();
    
    // Initialize form validation
    initFormValidation();
});

// Function to handle step navigation
function nextStep(step) {
    const currentForm = document.querySelector('.checkout-form.active');
    const nextForm = document.querySelector(`#${getFormId(step)}`);
    
    if (validateForm(currentForm.id)) {
        updateSteps(step);
        currentForm.classList.remove('active');
        nextForm.classList.add('active');
        
        // Update review section if on last step
        if (step === 3) {
            updateReviewSection();
        }
    }
}

function prevStep(step) {
    const currentForm = document.querySelector('.checkout-form.active');
    const prevForm = document.querySelector(`#${getFormId(step)}`);
    
    updateSteps(step);
    currentForm.classList.remove('active');
    prevForm.classList.add('active');
}

function getFormId(step) {
    const forms = ['shipping-form', 'payment-form', 'review-form'];
    return forms[step - 1];
}

// Function to update step indicators
function updateSteps(currentStep) {
    const steps = document.querySelectorAll('.step');
    
    steps.forEach((step, index) => {
        const stepNumber = parseInt(step.dataset.step);
        
        if (stepNumber < currentStep) {
            step.classList.add('completed');
            step.classList.remove('active');
        } else if (stepNumber === currentStep) {
            step.classList.add('active');
            step.classList.remove('completed');
        } else {
            step.classList.remove('active', 'completed');
        }
    });
}

// Function to initialize payment method selection
function initPaymentMethods() {
    const paymentMethods = document.querySelectorAll('.payment-method');
    
    paymentMethods.forEach(method => {
        method.addEventListener('click', function() {
            // Remove active class from all methods
            paymentMethods.forEach(m => m.classList.remove('active'));
            
            // Add active class to clicked method
            this.classList.add('active');
            
            // Update radio button
            const radio = this.querySelector('input[type="radio"]');
            radio.checked = true;
        });
    });
}

// Function to load order items from backend for logged-in users
function loadOrderItems() {
    const userId = window.userId || sessionStorage.getItem('userId');
    const orderItemsContainer = document.querySelector('.order-items');
    const sidebarItemsContainer = document.querySelector('.order-summary-sidebar .order-items');

    if (userId) {
        // Fetch cart items from backend
        fetch(`CartServlet?action=getCart&c_id=${encodeURIComponent(userId)}`)
            .then(response => response.text())
            .then(text => {
                const cartItems = parseCartData(text);
                if (!cartItems.length) {
                    window.location.href = 'cart.jsp';
                    return;
                }
                // Clear existing items
                orderItemsContainer.innerHTML = '';
                sidebarItemsContainer.innerHTML = '';
                cartItems.forEach(item => {
                    const orderItem = createOrderItem(item);
                    orderItemsContainer.appendChild(orderItem.cloneNode(true));
                    sidebarItemsContainer.appendChild(orderItem);
                });
                updateOrderTotal(cartItems);
            });
    } else {
        // Guest user: fallback to localStorage
        const cartItems = JSON.parse(localStorage.getItem('cartItems')) || [];
        if (cartItems.length === 0) {
            window.location.href = 'cart.jsp';
            return;
        }
        orderItemsContainer.innerHTML = '';
        sidebarItemsContainer.innerHTML = '';
        cartItems.forEach(item => {
            const orderItem = createOrderItem(item);
            orderItemsContainer.appendChild(orderItem.cloneNode(true));
            sidebarItemsContainer.appendChild(orderItem);
        });
        updateOrderTotal(cartItems);
    }
}

function parseCartData(text) {
    if (!text.trim()) return [];
    return text.trim().split('\n').map(line => {
        const [productId, productName, price, quantity, imagePath] = line.split('|');
        return {
            productId: parseInt(productId),
            name: productName,
            price: parseFloat(price),
            quantity: parseInt(quantity),
            image: imagePath
        };
    });
}

function updateOrderTotal(cartItems) {
    let subtotal = 0;
    cartItems.forEach(item => {
        const price = parseFloat(item.price);
        const quantity = item.quantity || 1;
        subtotal += price * quantity;
    });
    const tax = subtotal * 0.1; // 10% tax
    const total = subtotal + tax;
    document.querySelectorAll('.summary-details').forEach(summary => {
        summary.querySelector('.summary-row:nth-child(1) span:last-child').textContent = `₹${subtotal.toFixed(2)}`;
        summary.querySelector('.summary-row:nth-child(3) span:last-child').textContent = `₹${tax.toFixed(2)}`;
        summary.querySelector('.summary-row.total span:last-child').textContent = `₹${total.toFixed(2)}`;
    });
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

// Function to initialize form validation
function initFormValidation() {
    const forms = document.querySelectorAll('.checkout-form');
    
    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            
            if (validateForm(form.id)) {
                if (form.id === 'review-form') {
                    placeOrder();
                }
            }
        });
    });
}

// Function to validate form
function validateForm(formId) {
    const form = document.getElementById(formId);
    const inputs = form.querySelectorAll('input[required], select[required]');
    let isValid = true;
    
    inputs.forEach(input => {
        if (!input.value.trim()) {
            isValid = false;
            input.classList.add('error');
        } else {
            input.classList.remove('error');
        }
    });
    
    return isValid;
}

// Function to update review section
function updateReviewSection() {
    const shippingForm = document.getElementById('shipping-form');
    const paymentForm = document.getElementById('payment-form');
    
    // Update shipping address
    const address = `
        ${shippingForm.querySelector('#full-name').value}<br>
        ${shippingForm.querySelector('#address').value}<br>
        ${shippingForm.querySelector('#city').value}, 
        ${shippingForm.querySelector('#state').value} 
        ${shippingForm.querySelector('#zip').value}<br>
        ${shippingForm.querySelector('#country').value}
    `;
    document.getElementById('shipping-address-display').innerHTML = address;
    
    // Update payment method
    const paymentMethod = paymentForm.querySelector('.payment-method.active label').textContent.trim();
    document.getElementById('payment-method-display').textContent = paymentMethod;
}

// Function to place order
function placeOrder() {
    // Here you would typically send the order data to your backend
    const orderData = {
        shipping: getFormData('shipping-form'),
        payment: getFormData('payment-form'),
        items: JSON.parse(localStorage.getItem('cartItems')) || [],
        total: document.querySelector('.summary-row.total span:last-child').textContent
    };
    
    console.log('Placing order:', orderData);
    
    // Clear cart
    localStorage.removeItem('cartItems');
    
    // Redirect to order confirmation page
    window.location.href = 'order-confirmation.html';
}

// Function to get form data
function getFormData(formId) {
    const form = document.getElementById(formId);
    const formData = {};
    
    form.querySelectorAll('input, select').forEach(input => {
        if (input.type !== 'radio' || input.checked) {
            formData[input.id] = input.value;
        }
    });
    
    return formData;
} 