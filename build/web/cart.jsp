<%@page import="campuskart_ver02.classes.Student"%>
<%@page import="campuskart_ver02.classes.Cart"%>
<%@page import="campuskart_ver02.classes.Product"%>
<%@page import="campuskart_ver02.classes.CartItem"%>
<%@page import="Database.StudentDAO"%>
<%@page import="Database.CartDAO"%>
<%@page import="Database.ProductDAO"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Student currentUser = (Student) session.getAttribute("user");
    Cart cart = null;
    int clientId = 0;
    
    if (currentUser != null) {
        currentUser = StudentDAO.getStudentByUsername(currentUser.getUsername());
        if (currentUser != null) {
            clientId = currentUser.getClientId();
            // Get active cart for the user
            cart = CartDAO.getActiveCartByClientId(clientId);
            if (cart == null) {
                // If no active cart exists, create a new one
                cart = CartDAO.createNewCart(clientId);
            }
            
            // Load cart items from database
            if (cart != null) {
                List<CartItem> cartItems = CartDAO.getCartItems(cart.getCartId());
                Map<Product, Integer> items = new HashMap<Product, Integer>();
                
                for (CartItem item : cartItems) {
                    Product product = ProductDAO.getProductById(item.getProductId());
                    if (product != null) {
                        items.put(product, item.getQuantity());
                    }
                }
                
                cart.setItems(items);
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart - CampusKart</title>
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <!-- Common styles -->
    <link rel="stylesheet" href="assets/css/common.css">
    <!-- Cart page specific styles -->
    <link rel="stylesheet" href="assets/css/style.css">
    <style>
        .cart-container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1rem;
        }
        
        .cart-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .cart-items {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            padding: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .cart-item {
            display: grid;
            grid-template-columns: 100px 1fr auto auto;
            gap: 1rem;
            align-items: center;
            padding: 1rem;
            border-bottom: 1px solid var(--border-color);
        }
        
        .cart-item:last-child {
            border-bottom: none;
        }
        
        .cart-item-image {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 8px;
        }
        
        .cart-item-details {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }
        
        .cart-item-name {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--text-color);
        }
        
        .cart-item-price {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--primary-color);
        }
        
        .quantity-controls {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .quantity-btn {
            width: 30px;
            height: 30px;
            border: 1px solid var(--border-color);
            background: white;
            border-radius: 4px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .quantity-input {
            width: 50px;
            text-align: center;
            border: 1px solid var(--border-color);
            border-radius: 4px;
            padding: 0.25rem;
        }
        
        .remove-btn {
            color: #dc3545;
            background: none;
            border: none;
            cursor: pointer;
            padding: 0.5rem;
        }
        
        .cart-summary {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            padding: 1.5rem;
            margin-top: 2rem;
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            padding: 0.5rem 0;
            border-bottom: 1px solid var(--border-color);
        }
        
        .summary-row:last-child {
            border-bottom: none;
        }
        
        .summary-total {
            font-weight: 700;
            font-size: 1.2rem;
            color: var(--primary-color);
        }
        
        .checkout-btn {
            width: 100%;
            padding: 1rem;
            background-color: var(--primary-color);
            color: white;
            border: none;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 1rem;
            transition: background-color 0.3s ease;
        }
        
        .checkout-btn:hover {
            background-color: var(--primary-dark);
        }
        
        .empty-cart {
            text-align: center;
            padding: 3rem;
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        .continue-shopping {
            display: inline-block;
            padding: 0.75rem 1.5rem;
            background-color: var(--primary-color);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            margin-top: 1rem;
            transition: background-color 0.3s ease;
        }
        
        .continue-shopping:hover {
            background-color: var(--primary-dark);
        }
    </style>
    <script>
        // Set the user ID from JSP to JavaScript
        window.userId = <%= clientId > 0 ? clientId : 0 %>;
    </script>
</head>
<body>
    <%@ include file="components/header.jsp" %>

    <main class="cart-container">
        <div class="cart-header">
            <h1>Shopping Cart</h1>
            <p>Review and manage your items</p>
        </div>

        <%
            if (cart != null && !cart.getItems().isEmpty()) {
        %>
        <div class="cart-items">
            <%
                for (Map.Entry<Product, Integer> entry : cart.getItems().entrySet()) {
                    Product product = entry.getKey();
                    int quantity = entry.getValue();
                    String imagePath = product.getImagePath();
                    if (imagePath == null || imagePath.trim().isEmpty()) {
                        imagePath = "assets/images/default-product.jpg";
                    } else if (!imagePath.startsWith("http") && !imagePath.startsWith("/") && !imagePath.startsWith("uploaded_images/")) {
                        imagePath = "uploaded_images/" + imagePath;
                    }
            %>
            <div class="cart-item">
                <img src="<%= imagePath %>" alt="<%= product.getProductName() %>" class="cart-item-image"
                     onerror="this.src='assets/images/default-product.jpg'">
                <div class="cart-item-details">
                    <h3 class="cart-item-name"><%= product.getProductName() %></h3>
                    <p class="cart-item-price">₹<%= String.format("%.2f", product.getPrice()) %></p>
                    <p class="cart-item-seller">Sold by: <%= product.getSeller() != null ? product.getSeller().getUsername() : "Unknown" %></p>
                </div>
                <div class="quantity-controls">
                    <button class="quantity-btn" onclick='updateQuantity("<%= product.getProductId() %>", "<%= quantity - 1 %>")'>-</button>
                    <input type="number" class="quantity-input" value="<%= quantity %>" min="1" 
                           onchange='updateQuantity("<%= product.getProductId() %>", this.value)'>
                    <button class="quantity-btn" onclick='updateQuantity("<%= product.getProductId() %>", "<%= quantity + 1 %>")'>+</button>
                </div>
                <button class="remove-btn" onclick='removeFromCart("<%= product.getProductId() %>")'>
                    <i class="fas fa-trash"></i>
                </button>
            </div>
            <% } %>
        </div>

        <div class="cart-summary">
            <div class="summary-row">
                <span>Subtotal</span>
                <span>₹<%= String.format("%.2f", cart.getTotalAmount()) %></span>
            </div>
            <div class="summary-row">
                <span>Shipping</span>
                <span>Free</span>
            </div>
            <div class="summary-row summary-total">
                <span>Total</span>
                <span>₹<%= String.format("%.2f", cart.getTotalAmount()) %></span>
            </div>
            <button class="checkout-btn" onclick="checkout()">Proceed to Checkout</button>
        </div>
        <%
            } else {
        %>
        <div class="empty-cart">
            <h2>Your cart is empty</h2>
            <p>Looks like you haven't added any items to your cart yet.</p>
            <a href="products.jsp" class="continue-shopping">Continue Shopping</a>
        </div>
        <%
            }
        %>
    </main>

    <!-- Include Footer -->
    <div id="footer-container"></div>

    <!-- Common JavaScript -->
    <script src="assets/js/common.js"></script>
    
    <!-- Cart specific JavaScript -->
    <script>
        // Function to load cart data
        function loadCartData() {
            if (!window.userId || window.userId <= 0) {
                console.log('User not logged in');
                const cartContainer = document.querySelector('.cart-items');
                if (cartContainer) {
                    cartContainer.innerHTML = `
                        <div class="empty-cart">
                            <h2>Please Login</h2>
                            <p>You need to be logged in to view your cart.</p>
                            <a href="login.jsp" class="continue-shopping">Login</a>
                        </div>`;
                }
                return;
            }

            fetch('CartServlet?action=getCart&c_id=' + window.userId)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.text();
                })
                .then(text => {
                    const cartItems = parseCartData(text);
                    updateCartUI(cartItems);
                })
                .catch(error => {
                    console.error('Error loading cart:', error);
                    alert('Error loading cart data. Please try again.');
                });
        }

        // Function to parse cart data from plain text
        function parseCartData(text) {
            if (!text.trim()) return [];
            
            const lines = text.split('\n');
            return lines
                .filter(line => line.trim())
                .map(line => {
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

        // Function to update cart UI
        function updateCartUI(cartItems) {
            const cartContainer = document.querySelector('.cart-items');
            if (!cartContainer) return;

            if (!cartItems || cartItems.length === 0) {
                cartContainer.innerHTML = `
                    <div class="empty-cart">
                        <h2>Your cart is empty</h2>
                        <p>Looks like you haven't added any items to your cart yet.</p>
                        <a href="products.jsp" class="continue-shopping">Continue Shopping</a>
                    </div>`;
                return;
            }

            let totalAmount = 0;
            const itemsHtml = cartItems.map(item => {
                const itemTotal = item.price * item.quantity;
                totalAmount += itemTotal;
                
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
                        <img src="${imagePath}" alt="${item.productName}" class="cart-item-image"
                             onerror="this.src='assets/images/default-product.jpg'">
                        <div class="cart-item-details">
                            <h3 class="cart-item-name">${item.productName}</h3>
                            <p class="cart-item-price">₹${item.price.toFixed(2)}</p>
                        </div>
                        <div class="quantity-controls">
                            <button class="quantity-btn" onclick="updateQuantity(${item.productId}, ${item.quantity - 1})">-</button>
                            <input type="number" class="quantity-input" value="${item.quantity}" min="1" 
                                   onchange="updateQuantity(${item.productId}, this.value)">
                            <button class="quantity-btn" onclick="updateQuantity(${item.productId}, ${item.quantity + 1})">+</button>
                        </div>
                        <button class="remove-btn" onclick="removeFromCart(${item.productId})">
                            <i class="fas fa-trash"></i>
                        </button>
                    </div>`;
            }).join('');

            cartContainer.innerHTML = itemsHtml;

            // Update summary
            const summaryTotal = document.querySelector('.summary-total span:last-child');
            if (summaryTotal) {
                summaryTotal.textContent = `₹${totalAmount.toFixed(2)}`;
            }
        }

        function updateQuantity(productId, newQuantity) {
            if (!window.userId || window.userId <= 0) {
                alert('Please login to update cart items');
                window.location.href = 'login.jsp';
                return;
            }

            if (newQuantity < 1) return;
            
            const formData = new URLSearchParams();
            formData.append('action', 'update');
            formData.append('c_id', window.userId);
            formData.append('product_id', productId);
            formData.append('quantity', newQuantity);

            fetch('CartServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: formData
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Failed to update quantity');
                }
                return response.text();
            })
            .then(text => {
                if (text.toLowerCase().includes('success')) {
                    loadCartData(); // Reload cart data instead of page refresh
                    updateCartBadge(); // Update the cart badge
                } else {
                    throw new Error(text);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error updating quantity: ' + error.message);
            });
        }

        function removeFromCart(productId) {
            if (!window.userId || window.userId <= 0) {
                alert('Please login to remove items from cart');
                window.location.href = 'login.jsp';
                return;
            }

            if (!confirm('Are you sure you want to remove this item from your cart?')) {
                return;
            }

            const formData = new URLSearchParams();
            formData.append('action', 'remove');
            formData.append('c_id', window.userId);
            formData.append('product_id', productId);

            fetch('CartServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: formData
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Failed to remove item');
                }
                return response.text();
            })
            .then(text => {
                if (text.toLowerCase().includes('success')) {
                    loadCartData(); // Reload cart data instead of page refresh
                    updateCartBadge(); // Update the cart badge
                } else {
                    throw new Error(text);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error removing item: ' + error.message);
            });
        }

        function checkout() {
            if (!window.userId || window.userId <= 0) {
                alert('Please login to proceed with checkout');
                window.location.href = 'login.jsp';
                return;
            }
            // TODO: Implement checkout functionality
            alert('Checkout functionality coming soon!');
        }

        // Load cart data when page loads
        document.addEventListener('DOMContentLoaded', () => {
            loadCartData();
        });
    </script>
</body>
</html> 