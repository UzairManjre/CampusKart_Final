<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="AbstactClasses.UserDetails" %>
<%@ page import="Database.ProductDAO" %>
<%@ page import="campuskart_ver02.classes.Product" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Comparator" %>
<%
UserDetails user = (UserDetails) session.getAttribute("user");
if (user == null || !"Moderator".equalsIgnoreCase(user.getRole())) {
    response.sendRedirect("login.html");
    return;
}
String username = user.getUsername();
String search = request.getParameter("search") != null ? request.getParameter("search").trim() : "";
String sort = request.getParameter("sort") != null ? request.getParameter("sort") : "name";
String filter = request.getParameter("filter") != null ? request.getParameter("filter") : "All Categories";

List<Product> allProducts = ProductDAO.getAllProducts();
List<Product> products = new ArrayList<Product>();

for (Product p : allProducts) {
    boolean matches = ("All Categories".equals(filter) || p.getCategory().equalsIgnoreCase(filter)) &&
                     (search.isEmpty() || p.getProductName().toLowerCase().contains(search.toLowerCase()) || 
                      p.getDescription().toLowerCase().contains(search.toLowerCase()));
    if (matches) {
        products.add(p);
    }
}

if ("price".equals(sort)) {
    Collections.sort(products, new Comparator<Product>() {
        public int compare(Product a, Product b) {
            return Double.compare(a.getPrice(), b.getPrice());
        }
    });
} else {
    Collections.sort(products, new Comparator<Product>() {
        public int compare(Product a, Product b) {
            return a.getProductName().compareToIgnoreCase(b.getProductName());
        }
    });
}

String[] categories = {"All Categories", "Electronics", "Fashion", "Home", "Sports", "Books", "Toys"};
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Management - CampusKart</title>
    <link rel="stylesheet" href="assets/css/common.css">
    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { 
            background: #f0f2f5; 
            margin: 0;
            padding: 0;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
        }
        .mod-header {
            background: #fff;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }
        .mod-header .logo {
            font-size: 1.5rem;
            font-weight: 700;
            color: #4f46e5;
            text-decoration: none;
        }
        .mod-header .user-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        .mod-header .username {
            color: #374151;
            font-weight: 500;
        }
        .mod-header .logout-btn {
            background: #eef2ff;
            color: #4f46e5;
            border: 1px solid #c7d2fe;
            border-radius: 6px;
            padding: 0.5rem 1rem;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
        }
        .mod-header .logout-btn:hover {
            background: #4f46e5;
            color: #fff;
        }
        .modprod-container { max-width: 1200px; margin: 2rem auto; padding: 0 1rem; }
        .modprod-header { background: #fff; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.07); padding: 1.5rem 2rem; display: flex; align-items: center; gap: 2rem; margin-bottom: 2rem; }
        .modprod-header .back-btn { background: #eef2ff; color: #4f46e5; border: 1px solid #c7d2fe; border-radius: 6px; padding: 0.6rem 1.5rem; font-size: 1rem; font-weight: 600; cursor: pointer; transition: all 0.2s; text-decoration: none; }
        .modprod-header .back-btn:hover { background: #4f46e5; color: #fff; }
        .modprod-header .title { font-size: 1.7rem; font-weight: 700; color: #111827; }
        .modprod-controls { background: #fff; border-radius: 10px; box-shadow: 0 1px 4px rgba(0,0,0,0.05); padding: 1.2rem 2rem; display: flex; flex-wrap: wrap; gap: 1.2rem; align-items: center; margin-bottom: 2rem; }
        .modprod-controls input, .modprod-controls select { padding: 0.6rem 1rem; border-radius: 6px; border: 1px solid #e5e7eb; font-size: 1rem; }
        .modprod-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(270px, 1fr)); gap: 2rem; }
        .modprod-card { background: #fff; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.07); padding: 1.5rem 1.2rem 1.2rem 1.2rem; display: flex; flex-direction: column; align-items: center; min-height: 420px; border: 1.5px solid #e5e7eb; transition: box-shadow 0.2s; }
        .modprod-card:hover { box-shadow: 0 4px 16px rgba(79,70,229,0.10); border-color: #4f46e5; }
        .modprod-card img { width: 180px; height: 180px; object-fit: cover; border-radius: 8px; margin-bottom: 1rem; background: #f3f4f6; }
        .modprod-card .prod-name { font-size: 1.1rem; font-weight: 700; color: #111827; margin-bottom: 0.3rem; text-align: center; }
        .modprod-card .prod-price { color: #10b981; font-weight: 600; margin-bottom: 0.2rem; }
        .modprod-card .prod-category { color: #6b7280; font-size: 0.95rem; margin-bottom: 0.7rem; }
        .modprod-card .prod-desc { color: #6b7280; font-size: 0.97rem; margin-bottom: 1.1rem; text-align: center; min-height: 40px; }
        .modprod-card .remove-btn { background: #ef4444; color: #fff; border: none; border-radius: 6px; padding: 0.6rem 1.5rem; font-size: 1rem; font-weight: 600; cursor: pointer; transition: background 0.2s; }
        .modprod-card .remove-btn:hover { background: #b91c1c; }
        .modprod-empty { text-align: center; color: #6b7280; font-size: 1.2rem; margin-top: 3rem; }
    </style>
</head>
<body>
    <div class="mod-header">
        <a href="moddash.jsp" class="logo">CampusKart Moderator</a>
        <div class="user-info">
            <span class="username"><%= username %></span>
            <form action="logout.jsp" method="post" style="margin:0;">
                <button type="submit" class="logout-btn">Logout</button>
            </form>
        </div>
    </div>
    <div class="modprod-container">
        <div class="modprod-header">
            <a href="moddash.jsp" class="back-btn"><i class="fas fa-arrow-left"></i> Back to Dashboard</a>
            <div class="title">Product Management</div>
        </div>
        <form class="modprod-controls" method="get" action="mod-products.jsp">
            <input type="text" name="search" placeholder="Search products..." value="<%= search %>">
            <select name="sort">
                <option value="name" <%= "name".equals(sort) ? "selected" : "" %>>Sort by Name</option>
                <option value="price" <%= "price".equals(sort) ? "selected" : "" %>>Sort by Price</option>
            </select>
            <select name="filter">
                <% for (String cat : categories) { %>
                    <option value="<%= cat %>" <%= cat.equals(filter) ? "selected" : "" %>><%= cat %></option>
                <% } %>
            </select>
            <button type="submit" class="back-btn" style="background:#4f46e5;color:#fff;border:none;">Apply</button>
        </form>
        <div class="modprod-grid">
            <% if (products.isEmpty()) { %>
                <div class="modprod-empty">
                    <div style="font-size:2.5rem;">📦</div>
                    No products found.<br>
                    <span style="font-size:1rem;">Try adjusting your search or filters.</span>
                </div>
            <% } else { 
                for (Product product : products) { 
                    String imagePath = product.getImagePath();
                    if (imagePath == null || imagePath.trim().isEmpty()) {
                        imagePath = "assets/images/default-product.jpg";
                    } else if (!imagePath.startsWith("uploaded_images/") && !imagePath.startsWith("http")) {
                        imagePath = "uploaded_images/" + imagePath;
                    }
            %>
            <div class="modprod-card">
                <img src="<%= imagePath %>" alt="<%= product.getProductName() %>" onerror="this.src='assets/images/default-product.jpg'">
                <div class="prod-name"><%= product.getProductName() %></div>
                <div class="prod-price">₹<%= String.format("%.2f", product.getPrice()) %></div>
                <div class="prod-category"><%= product.getCategory() %></div>
                <div class="prod-desc"><%= product.getDescription() %></div>
                <form method="post" action="RemoveProductServlet" onsubmit="return confirm('Are you sure you want to remove this product?');">
                    <input type="hidden" name="productId" value="<%= product.getProductId() %>">
                    <button type="submit" class="remove-btn">Remove</button>
                </form>
            </div>
            <% } } %>
        </div>
    </div>
</body>
</html> 