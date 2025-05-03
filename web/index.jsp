<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="AbstactClasses.UserDetails" %>
<%@ page import="Database.ProductDAO" %>
<%@ page import="campuskart_ver02.classes.Product" %>
<%@ page import="campuskart_ver02.classes.Student" %>
<%@ page import="Database.StudentDAO" %>
<%@page import="java.util.List"%>
<%@ include file="components/header.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Campus Kart - Home</title>
  <link rel="icon" href="assets/images/favicon.ico" type="image/x-icon" />
  <!-- Font Awesome for icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
  <!-- Common styles -->
  <link rel="stylesheet" href="assets/css/common.css" />
  <!-- Page specific styles -->
  <link rel="stylesheet" href="assets/css/style.css" />
  <!-- Common JavaScript -->
  <script src="assets/js/common.js"></script>
  <script>
    // Set userId in sessionStorage and window object after successful login
    <% if (user != null) { %>
        window.userId = <%= StudentDAO.getStudentByUsername(user.getUsername()).getClientId() %>;
        sessionStorage.setItem('userId', '<%= StudentDAO.getStudentByUsername(user.getUsername()).getClientId() %>');
        console.log('User ID set:', <%= StudentDAO.getStudentByUsername(user.getUsername()).getClientId() %>);
    <% } %>
    // Expose addToCart function globally
    window.addToCart = addToCart;
  </script>
  <style>
    .product-card img {
      width: 100%;
      height: 200px;
      object-fit: cover;
      border-radius: 8px;
    }
    .product-card {
      position: relative;
      overflow: hidden;
    }
    .product-image-container {
      position: relative;
      width: 100%;
      height: 200px;
      background-color: #f5f5f5;
    }
    .product-image-container img {
      transition: transform 0.3s ease;
    }
    .product-card:hover .product-image-container img {
      transform: scale(1.05);
    }
  </style>
</head>
<body>
  <!-- Main Content -->
  <main>
    <!-- Hero Section -->
    <section class="hero" id="home">
      <div class="hero-content">
        <% if (user != null) { %>
        <h1 class="hero-title" data-gsap="fade-up">Welcome, <%= user.getUsername() %>!</h1>
        <p class="hero-subtitle" data-gsap="fade-up">You are logged in as a <%= user.getRole() %></p>
        <% } else { %>
        <h1 class="hero-title" data-gsap="fade-up">Welcome to Campus Kart</h1>
        <p class="hero-subtitle" data-gsap="fade-up">Your Campus Marketplace</p>
        <% } %>
        <button class="cta" data-gsap="fade-up" data-scroll-to="products">Explore Now</button>
      </div>
    </section>

    <!-- Featured Products -->
    <section class="featured-products" id="products">
      <h2 data-gsap="fade-up">Trending Campus Essentials</h2>
      <div class="product-grid">
        <%
            List<Product> products = ProductDAO.getAllProducts();
            if (products != null && !products.isEmpty()) {
                int count = 0;
                for (Product product : products) {
                    if (count >= 6) break; // Only show 6 products
                    String imagePath = product.getImagePath();
                    // If image path is null or empty, use a default image
                    if (imagePath == null || imagePath.trim().isEmpty()) {
                        imagePath = "assets/images/default-product.jpg";
                    } else {
                        // Handle both relative and absolute paths
                        if (imagePath.startsWith("uploaded_images/")) {
                            // If it's already in the correct format, use as is
                            imagePath = imagePath;
                        } else if (!imagePath.startsWith("http") && !imagePath.startsWith("/")) {
                            // If it's a local path without the directory, add it
                            imagePath = "uploaded_images/" + imagePath;
                        }
                    }
        %>
        <div class="product-card" data-gsap="fade-up">
          <div class="product-image-container">
            <img src="<%= imagePath %>" alt="<%= product.getProductName() %>" 
                 onerror="this.src='assets/images/default-product.jpg'" />
          </div>
          <h3><%= product.getProductName() %></h3>
          <p><%= product.getDescription() %></p>
          <p class="price">₹<%= String.format("%.2f", product.getPrice()) %></p>
          <p class="quantity">Available: <%= product.getQuantity() %></p>
          <button type="button" class="add-to-cart-btn" 
                  onclick="addToCart(<%= product.getProductId() %>)"
                  <%= product.getQuantity() == 0 ? "disabled" : "" %>>
            Add to Cart
          </button>
        </div>
        <%
                    count++;
                }
            } else {
        %>
        <div class="no-products">
          <p>No products available at the moment.</p>
        </div>
        <%
            }
        %>
      </div>
      <%
          if (products != null && products.size() > 6) {
      %>
      <div class="view-more">
        <a href="products.jsp" class="view-more-btn">View All Products</a>
      </div>
      <%
          }
      %>
    </section>
  </main>

  <!-- Include Footer -->
  <div id="footer-container"></div>

  <!-- GSAP CDN -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.5/gsap.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.5/ScrollTrigger.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.5/ScrollToPlugin.min.js"></script>
  
  <!-- Animations -->
  <script src="assets/js/animations.js"></script>
  <!-- Page specific JavaScript -->
  <script src="assets/js/script.js"></script>
</body>
</html> 