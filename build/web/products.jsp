<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="AbstactClasses.UserDetails" %>
<%@ page import="Database.ProductDAO" %>
<%@ page import="campuskart_ver02.classes.Product" %>
<%@ page import="campuskart_ver02.classes.Student" %>
<%@ page import="Database.StudentDAO" %>
<%@page import="java.util.List"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Comparator"%>
<%@ include file="components/header.jsp" %>
<%
    HttpSession currentSession = request.getSession(false);
    UserDetails currentUser = (UserDetails) currentSession.getAttribute("user");
    
    // Get filter parameters
    String selectedCategory = request.getParameter("category");
    String minPriceStr = request.getParameter("minPrice");
    String maxPriceStr = request.getParameter("maxPrice");
    String availability = request.getParameter("availability");
    String sortBy = request.getParameter("sortBy");
    
    // Get all products
    List<Product> products;
    if (selectedCategory != null && !selectedCategory.isEmpty()) {
        products = ProductDAO.getProductsByCategory(selectedCategory);
    } else {
        products = ProductDAO.getAllProducts();
    }
    
    // Apply filters
    if (products != null) {
        // Filter by price range
        if (minPriceStr != null && !minPriceStr.isEmpty()) {
            final double minPrice = Double.parseDouble(minPriceStr);
            for (int i = products.size() - 1; i >= 0; i--) {
                if (products.get(i).getPrice() < minPrice) {
                    products.remove(i);
                }
            }
        }
        if (maxPriceStr != null && !maxPriceStr.isEmpty()) {
            final double maxPrice = Double.parseDouble(maxPriceStr);
            for (int i = products.size() - 1; i >= 0; i--) {
                if (products.get(i).getPrice() > maxPrice) {
                    products.remove(i);
                }
            }
        }
        
        // Filter by availability
        if (availability != null && !availability.isEmpty()) {
            if ("available".equals(availability)) {
                for (int i = products.size() - 1; i >= 0; i--) {
                    if (products.get(i).getQuantity() <= 0) {
                        products.remove(i);
                    }
                }
            } else if ("sold".equals(availability)) {
                for (int i = products.size() - 1; i >= 0; i--) {
                    if (products.get(i).getQuantity() > 0) {
                        products.remove(i);
                    }
                }
            }
        }
        
        // Sort products
        if (sortBy != null && !sortBy.isEmpty()) {
            Comparator<Product> comparator = null;
            
            if ("price_asc".equals(sortBy)) {
                comparator = new Comparator<Product>() {
                    public int compare(Product p1, Product p2) {
                        return Double.compare(p1.getPrice(), p2.getPrice());
                    }
                };
            } else if ("price_desc".equals(sortBy)) {
                comparator = new Comparator<Product>() {
                    public int compare(Product p1, Product p2) {
                        return Double.compare(p2.getPrice(), p1.getPrice());
                    }
                };
            } else if ("name_asc".equals(sortBy)) {
                comparator = new Comparator<Product>() {
                    public int compare(Product p1, Product p2) {
                        return p1.getProductName().compareTo(p2.getProductName());
                    }
                };
            } else if ("name_desc".equals(sortBy)) {
                comparator = new Comparator<Product>() {
                    public int compare(Product p1, Product p2) {
                        return p2.getProductName().compareTo(p1.getProductName());
                    }
                };
            } else if ("newest".equals(sortBy)) {
                comparator = new Comparator<Product>() {
                    public int compare(Product p1, Product p2) {
                        return Integer.compare(p2.getProductId(), p1.getProductId());
                    }
                };
            }
            
            if (comparator != null) {
                Collections.sort(products, comparator);
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Campus Kart - All Products</title>
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
    <% if (currentUser != null) { 
        Student student = StudentDAO.getStudentByUsername(currentUser.getUsername());
        if (student != null) {
    %>
        window.userId = '<%= student.getClientId() %>';
        sessionStorage.setItem('userId', '<%= student.getClientId() %>');
        console.log('User ID set:', '<%= student.getClientId() %>');
    <% } } %>
    
    // Expose addToCart function globally
    window.addToCart = addToCart;
  </script>
  <style>
    .products-container {
      padding: 2rem;
      max-width: 1200px;
      margin: 0 auto;
    }
    .products-header {
      text-align: center;
      margin-bottom: 3rem;
    }
    .products-header h1 {
      font-size: 2.5rem;
      color: var(--primary-color);
      margin-bottom: 1rem;
    }
    .products-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
      gap: 2rem;
      padding: 1rem;
    }
    .product-card {
      background: white;
      border-radius: 12px;
      overflow: hidden;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
      transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    .product-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
    }
    .product-image-container {
      position: relative;
      width: 100%;
      height: 200px;
      background-color: #f5f5f5;
      overflow: hidden;
    }
    .product-image {
      width: 100%;
      height: 100%;
      object-fit: cover;
      transition: transform 0.3s ease;
    }
    .product-card:hover .product-image {
      transform: scale(1.05);
    }
    .product-details {
      padding: 1.5rem;
    }
    .product-name {
      font-size: 1.25rem;
      font-weight: 600;
      margin-bottom: 0.5rem;
      color: var(--text-color);
    }
    .product-price {
      font-size: 1.5rem;
      font-weight: 700;
      color: var(--primary-color);
      margin-bottom: 1rem;
    }
    .product-category {
      font-size: 0.9rem;
      color: var(--secondary-color);
      margin-bottom: 0.5rem;
    }
    .product-description {
      font-size: 0.95rem;
      color: var(--text-color);
      margin-bottom: 1rem;
      line-height: 1.5;
    }
    .product-seller {
      font-size: 0.9rem;
      color: var(--secondary-color);
      margin-bottom: 1rem;
    }
    .product-status {
      display: inline-block;
      padding: 0.25rem 0.75rem;
      border-radius: 20px;
      font-size: 0.85rem;
      font-weight: 500;
      margin-bottom: 1rem;
    }
    .status-available {
      background-color: #e6f7e6;
      color: #2e7d32;
    }
    .status-sold {
      background-color: #ffebee;
      color: #c62828;
    }
    .add-to-cart-btn {
      width: 100%;
      padding: 0.75rem;
      background-color: var(--primary-color);
      color: white;
      border: none;
      border-radius: 6px;
      font-weight: 600;
      cursor: pointer;
      transition: background-color 0.3s ease;
    }
    .add-to-cart-btn:hover {
      background-color: var(--primary-dark);
    }
    .add-to-cart-btn:disabled {
      background-color: #cccccc;
      cursor: not-allowed;
    }
    .no-products {
      text-align: center;
      padding: 3rem;
      color: var(--secondary-color);
    }
    /* Filter and Sort Section */
    .filter-section {
      background: white;
      padding: 1.5rem;
      border-radius: 12px;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
      margin-bottom: 2rem;
    }
    
    .filter-row {
      display: flex;
      flex-wrap: wrap;
      gap: 1rem;
      align-items: center;
      margin-bottom: 1rem;
    }
    
    .filter-group {
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }
    
    .filter-label {
      font-weight: 600;
      color: var(--text-color);
      white-space: nowrap;
    }
    
    .filter-select {
      padding: 0.5rem;
      border: 1px solid var(--border-color);
      border-radius: 6px;
      background: white;
      min-width: 150px;
    }
    
    .filter-select:focus {
      outline: none;
      border-color: var(--primary-color);
    }
    
    .price-range {
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }
    
    .price-input {
      width: 100px;
      padding: 0.5rem;
      border: 1px solid var(--border-color);
      border-radius: 6px;
    }
    
    .filter-btn {
      padding: 0.5rem 1rem;
      background-color: var(--primary-color);
      color: white;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      transition: background-color 0.3s ease;
    }
    
    .filter-btn:hover {
      background-color: var(--primary-dark);
    }
    
    .reset-btn {
      padding: 0.5rem 1rem;
      background-color: #f5f5f5;
      color: var(--text-color);
      border: 1px solid var(--border-color);
      border-radius: 6px;
      cursor: pointer;
      transition: all 0.3s ease;
    }
    
    .reset-btn:hover {
      background-color: #e0e0e0;
    }
  </style>
</head>
<body>
  <!-- Main Content -->
  <main class="products-container">
    <div class="products-header">
      <h1>All Products</h1>
      <p>Browse through our collection of campus essentials</p>
    </div>

    <!-- Filter and Sort Section -->
    <div class="filter-section">
      <form id="filterForm" method="get">
        <div class="filter-row">
          <div class="filter-group">
            <label class="filter-label">Category:</label>
            <select class="filter-select" name="category" onchange="this.form.submit()">
              <option value="">All Categories</option>
              <%
                  Set<String> categories = new HashSet<String>();
                  List<Product> allProducts = ProductDAO.getAllProducts();
                  for (Product p : allProducts) {
                      if (p.getCategory() != null && !p.getCategory().trim().isEmpty()) {
                          categories.add(p.getCategory());
                      }
                  }
                  for (String category : categories) {
              %>
              <option value="<%= category %>" <%= category.equals(selectedCategory) ? "selected" : "" %>>
                <%= category %>
              </option>
              <% } %>
            </select>
          </div>
          
          <div class="filter-group">
            <label class="filter-label">Price Range:</label>
            <div class="price-range">
              <input type="number" class="price-input" name="minPrice" placeholder="Min" min="0" 
                     value="<%= minPriceStr != null ? minPriceStr : "" %>" onchange="this.form.submit()">
              <span>to</span>
              <input type="number" class="price-input" name="maxPrice" placeholder="Max" min="0" 
                     value="<%= maxPriceStr != null ? maxPriceStr : "" %>" onchange="this.form.submit()">
            </div>
          </div>
          
          <div class="filter-group">
            <label class="filter-label">Availability:</label>
            <select class="filter-select" name="availability" onchange="this.form.submit()">
              <option value="">All</option>
              <option value="available" <%= "available".equals(availability) ? "selected" : "" %>>Available</option>
              <option value="sold" <%= "sold".equals(availability) ? "selected" : "" %>>Sold Out</option>
            </select>
          </div>
        </div>
        
        <div class="filter-row">
          <div class="filter-group">
            <label class="filter-label">Sort By:</label>
            <select class="filter-select" name="sortBy" onchange="this.form.submit()">
              <option value="">Default</option>
              <option value="price_asc" <%= "price_asc".equals(sortBy) ? "selected" : "" %>>Price: Low to High</option>
              <option value="price_desc" <%= "price_desc".equals(sortBy) ? "selected" : "" %>>Price: High to Low</option>
              <option value="name_asc" <%= "name_asc".equals(sortBy) ? "selected" : "" %>>Name: A to Z</option>
              <option value="name_desc" <%= "name_desc".equals(sortBy) ? "selected" : "" %>>Name: Z to A</option>
              <option value="newest" <%= "newest".equals(sortBy) ? "selected" : "" %>>Newest First</option>
            </select>
          </div>
          
          <div class="filter-group" style="margin-left: auto;">
            <button type="button" class="reset-btn" onclick="resetFilters()">Reset</button>
          </div>
        </div>
      </form>
    </div>

    <div class="products-grid" id="productsGrid">
      <%
      if (products != null && !products.isEmpty()) {
          for (Product product : products) {
              String imagePath = product.getImagePath();
              if (imagePath == null || imagePath.trim().isEmpty()) {
                  imagePath = "assets/images/default-product.jpg";
              } else {
                  if (imagePath.startsWith("uploaded_images/")) {
                      imagePath = imagePath;
                  } else if (!imagePath.startsWith("http") && !imagePath.startsWith("/")) {
                      imagePath = "uploaded_images/" + imagePath;
                  }
              }
      %>
      <div class="product-card" data-product-id="<%= product.getProductId() %>">
        <div class="product-image-container">
          <img src="<%= imagePath %>" alt="<%= product.getProductName() %>"
               onerror="this.src='assets/images/default-product.jpg'" />
        </div>
        <div class="product-details">
          <h3 class="product-name"><%= product.getProductName() %></h3>
          <p class="product-price">₹<%= String.format("%.2f", product.getPrice()) %></p>
          <p class="product-category"><%= product.getCategory() %></p>
          <p class="product-description"><%= product.getDescription() %></p>
          <p class="product-seller">Sold by: <%= product.getSeller() != null ? product.getSeller().getUsername() : "Unknown" %></p>
          <span class="product-status <%= product.getQuantity() > 0 ? "status-available" : "status-sold" %>">
            <%= product.getQuantity() > 0 ? "AVAILABLE" : "SOLD" %>
          </span>
          <button type="button" class="add-to-cart-btn"
                  onclick="addToCart(<%= product.getProductId() %>)"
                  <%= product.getQuantity() == 0 ? "disabled" : "" %>>
            Add to Cart
          </button>
        </div>
      </div>
      <% } } else { %>
      <div class="no-products">
        <p>No products found.</p>
      </div>
      <% } %>
    </div>
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

  <!-- Initialize cart badge after scripts are loaded -->
  <script>
    window.addEventListener('load', () => {
        if (window.userId) {
            updateCartBadge();
        }
    });

    // Function to reset all filters
    function resetFilters() {
        window.location.href = 'products.jsp';
    }
  </script>
</body>
</html>
