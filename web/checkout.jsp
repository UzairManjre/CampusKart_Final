<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="campuskart_ver02.classes.CartItem" %>
<%@ page import="campuskart_ver02.classes.Product" %>
<%@ page import="java.util.List" %>
<%@ page import="Database.CartDAO" %>
<%@ page import="Database.ProductDAO" %>
<%@ page import="Database.StudentDAO" %>
<%@ page import="AbstactClasses.UserDetails" %>
<%@ page import="campuskart_ver02.classes.Cart" %>

<%
    UserDetails user = (UserDetails) session.getAttribute("user");
    Integer clientId = null;
    if (user == null) {
        response.sendRedirect("login.html");
        return;
    } else {
        clientId = Database.StudentDAO.getStudentByUsername(user.getUsername()).getClientId();
    }
    Cart cart = CartDAO.getActiveCartByClientId(clientId);
    List<CartItem> cartItems = cart != null ? CartDAO.getCartItems(cart.getCartId()) : new java.util.ArrayList();
    if (cartItems == null || cartItems.isEmpty()) {
        response.sendRedirect("cart.jsp?empty=1");
        return;
    }
    double subtotal = 0.0;
    for (CartItem item : cartItems) {
        Product product = ProductDAO.getProductById(item.getProductId());
        if (product != null) {
            subtotal += product.getPrice() * item.getQuantity();
        }
    }
    double tax = subtotal * 0.18;
    double total = subtotal + tax;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - CampusKart</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="assets/css/common.css">
    <link rel="stylesheet" href="assets/css/checkout.css">
</head>
<body>
    <div id="header-container"></div>
    <main class="checkout-container">
        <div class="checkout-breadcrumb">
            <a href="index.jsp">Home</a>
            <span class="separator">/</span>
            <a href="cart.jsp">Cart</a>
            <span class="separator">/</span>
            <span class="current">Checkout</span>
        </div>
        <div class="checkout-content">
            <h2>Your Cart Items</h2>
            <div class="order-items">
                <% for (CartItem item : cartItems) { 
                    Product product = ProductDAO.getProductById(item.getProductId());
                    if (product != null) { %>
                    <div class="order-item">
                        <img src="<%= product.getImagePath() %>" alt="<%= product.getProductName() %>" style="width:80px;height:80px;object-fit:cover;">
                        <div class="item-details">
                            <h4><%= product.getProductName() %></h4>
                            <p>Quantity: <%= item.getQuantity() %></p>
                            <p>Price: ₹<%= product.getPrice() %></p>
                        </div>
                    </div>
                <% }} %>
            </div>
            <div class="summary-details" style="margin-top:30px;">
                <div class="summary-row">
                    <span>Subtotal</span>
                    <span>₹<%= String.format("%.2f", subtotal) %></span>
                </div>
                <div class="summary-row">
                    <span>Tax (18%)</span>
                    <span>₹<%= String.format("%.2f", tax) %></span>
                </div>
                <div class="summary-row total">
                    <span>Total</span>
                    <span>₹<%= String.format("%.2f", total) %></span>
                </div>
            </div>
            <form action="CheckoutServlet" method="POST" style="margin-top:40px;text-align:center;">
                <input type="hidden" name="action" value="processCheckout">
                <input type="hidden" name="clientId" value="<%= clientId %>">
                <button type="submit" class="btn-primary" style="padding:16px 48px;font-size:18px;">Place Order</button>
            </form>
        </div>
    </main>
    <div id="footer-container"></div>
</body>
</html> 