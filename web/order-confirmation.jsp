<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="campuskart_ver02.classes.CartItem" %>
<%@ page import="campuskart_ver02.classes.Product" %>
<%@ page import="Database.ProductDAO" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Order Confirmation - CampusKart</title>
    <link rel="stylesheet" href="assets/css/common.css">
    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>
    <%@ include file="components/header.jsp" %>
    <main class="confirmation-container" style="max-width: 700px; margin: 40px auto; background: #fff; padding: 32px; border-radius: 12px; box-shadow: 0 2px 12px rgba(0,0,0,0.08);">
        <h1 style="color: #28a745;">Thank you for your order!</h1>
        <p>Your order has been placed successfully. Here are your order details:</p>
        <h2>Shipping Information</h2>
        <ul style="list-style: none; padding: 0;">
            <li><strong>Name:</strong> <%= session.getAttribute("orderFullName") != null ? session.getAttribute("orderFullName") : "" %></li>
            <li><strong>Enrollment Number:</strong> <%= session.getAttribute("orderEnrollmentNumber") != null ? session.getAttribute("orderEnrollmentNumber") : "" %></li>
            <li><strong>Email:</strong> <%= session.getAttribute("orderEmail") != null ? session.getAttribute("orderEmail") : "" %></li>
            <!-- <li><strong>Phone:</strong> <%= session.getAttribute("orderPhone") != null ? session.getAttribute("orderPhone") : "" %></li> -->
            <!-- <li><strong>Address:</strong> <%= session.getAttribute("orderAddress") != null ? session.getAttribute("orderAddress") : "" %></li> -->
        </ul>
        <h2>Payment Method</h2>
        <p><%= session.getAttribute("orderPaymentMethod") != null ? session.getAttribute("orderPaymentMethod") : "" %></p>
        <h2>Order Items</h2>
        <div class="order-items">
            <ul style="list-style: none; padding: 0;">
            <% 
                List<CartItem> orderItems = (List<CartItem>) session.getAttribute("orderItems");
                double total = 0.0;
                if (orderItems != null) {
                    for (CartItem item : orderItems) {
                        Product product = ProductDAO.getProductById(item.getProductId());
                        if (product != null) {
                            double itemTotal = product.getPrice() * item.getQuantity();
                            total += itemTotal;
            %>
                <li style="margin-bottom: 16px; border-bottom: 1px solid #eee; padding-bottom: 12px;">
                    <strong><%= product.getProductName() %></strong> (x<%= item.getQuantity() %>)<br>
                    Price: ₹<%= String.format("%.2f", product.getPrice()) %> | Subtotal: ₹<%= String.format("%.2f", itemTotal) %>
                </li>
            <%      }
                    }
                }
            %>
            </ul>
            <div style="margin-top: 20px; font-size: 18px; font-weight: bold;">Order Total: ₹<%= String.format("%.2f", total) %></div>
        </div>
        <div style="margin-top: 32px;">
            <a href="products.jsp" class="btn-primary" style="padding: 12px 32px; background: #007bff; color: #fff; border-radius: 6px; text-decoration: none;">Continue Shopping</a>
        </div>
    </main>
    <div id="footer-container"></div>
</body>
</html> 