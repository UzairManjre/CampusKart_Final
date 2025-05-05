<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Shopping Cart - CampusKart</title>
    <link rel="stylesheet" href="assets/css/common.css">
    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="stylesheet" href="assets/css/cart.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>
    <%@ include file="components/header.jsp" %>
    <% String emptyParam = request.getParameter("empty"); %>
    <main class="cart-container">
        <div class="cart-header">
            <h1>Your Shopping Cart</h1>
            <% if ("1".equals(emptyParam)) { %>
                <div class="cart-warning" style="color: #d9534f; font-weight: bold; margin-top: 10px;">Your cart is empty. Please add items before checking out.</div>
            <% } %>
        </div>
        <div class="cart-items" id="cartItemsContainer">
            <!-- Cart items will be rendered here by JS -->
        </div>
        <div class="cart-summary" id="cartSummary" style="display:none;">
            <div class="summary-row">
                <span>Subtotal</span>
                <span id="cartSubtotal">₹0.00</span>
            </div>
            <div class="summary-row">
                <span>Shipping</span>
                <span>Free</span>
            </div>
            <div class="summary-row summary-total">
                <span>Total</span>
                <span id="cartTotal">₹0.00</span>
            </div>
            <button class="checkout-btn" id="checkoutBtn">Proceed to Checkout</button>
        </div>
        <div class="empty-cart" id="emptyCart" style="display:none;">
            <h2>Your cart is empty</h2>
            <p>Looks like you haven't added any items to your cart yet.</p>
            <a href="products.jsp" class="continue-shopping">Continue Shopping</a>
        </div>
    </main>
    <div id="footer-container"></div>
    <script src="assets/js/common.js"></script>
    <script src="assets/js/cart.js"></script>
</body>
</html> 