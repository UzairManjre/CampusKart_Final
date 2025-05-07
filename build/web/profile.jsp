<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="AbstactClasses.UserDetails" %>
<%@ page import="Database.UserDAO" %>
<%@ page import="Database.TransactionDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="campuskart_ver02.classes.Transaction" %>
<%@ include file="components/header.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - CampusKart</title>
    <link rel="stylesheet" href="./assets/css/common.css">
    <link rel="stylesheet" href="./assets/css/style.css">
    <link rel="stylesheet" href="./assets/css/profile.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Common JavaScript -->
    <script src="assets/js/common.js"></script>
    <script>
        // Set userId in sessionStorage and window object after successful login
        <% if (user != null) { %>
            window.userId = <%= user.getUserId() %>;
            sessionStorage.setItem('userId', '<%= user.getUserId() %>');
            console.log('User ID set:', <%= user.getUserId() %>);
        <% } %>
        // Expose addToCart function globally
        window.addToCart = addToCart;
    </script>
    <style>
        .profile-container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1rem;
        }

        .profile-header {
            background: #fff;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }

        .profile-info {
            display: flex;
            align-items: center;
            gap: 2rem;
        }

        .profile-avatar {
            width: 100px;
            height: 100px;
            background: #f0f0f0;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            color: #666;
        }

        .profile-details h2 {
            margin: 0;
            color: #333;
        }

        .profile-stats {
            display: flex;
            gap: 2rem;
            margin-top: 1rem;
        }

        .stat-item {
            text-align: center;
        }

        .stat-value {
            font-size: 1.5rem;
            font-weight: bold;
            color: #2c3e50;
        }

        .stat-label {
            color: #666;
            font-size: 0.9rem;
        }

        .profile-content {
            display: grid;
            grid-template-columns: 250px 1fr;
            gap: 2rem;
        }

        .profile-sidebar {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 1.5rem;
        }

        .profile-menu {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .profile-menu li {
            margin-bottom: 0.5rem;
        }

        .profile-menu a {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1rem;
            color: #666;
            text-decoration: none;
            border-radius: 5px;
            transition: all 0.3s ease;
        }

        .profile-menu a:hover,
        .profile-menu a.active {
            background: #f8f9fa;
            color: #2c3e50;
        }

        .profile-menu i {
            width: 20px;
        }

        .profile-main {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 2rem;
        }

        .tab-content {
            display: none;
        }

        .tab-content.active {
            display: block;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: #333;
        }

        .form-group input {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 1rem;
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 5px;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: #2c3e50;
            color: #fff;
        }

        .btn-primary:hover {
            background: #34495e;
        }

        .alert {
            padding: 1rem;
            border-radius: 5px;
            margin-bottom: 1rem;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .orders-list {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .order-item {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 1.5rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 1px solid #eee;
            gap: 2rem;
        }

        .order-id {
            font-weight: bold;
            color: #2c3e50;
            min-width: 120px;
        }

        .order-date {
            color: #666;
            font-size: 0.9rem;
            text-align: right;
        }

        .order-details {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 1rem;
        }

        .product-info h4 {
            margin: 0 0 0.5rem 0;
            color: #2c3e50;
        }

        .product-info p {
            margin: 0;
            color: #666;
        }

        .seller-info p {
            margin: 0;
            color: #666;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
<%
if (user == null) {
    response.sendRedirect("login.jsp");
    return;
}

// Get user's transactions
List<Transaction> userTransactions = TransactionDAO.getUserTransactions(user.getUserId());
int orderCount = userTransactions != null ? userTransactions.size() : 0;

// Handle profile update
if ("POST".equals(request.getMethod()) && "update_profile".equals(request.getParameter("action"))) {
    String enrollmentNumber = request.getParameter("enrollmentNumber");
    
    if (UserDAO.updateUserProfile(user.getUserId(), enrollmentNumber)) {
        response.sendRedirect("profile.jsp?success=profile");
    } else {
        response.sendRedirect("profile.jsp?error=profile");
    }
    return;
}
%>
    <div class="profile-container">
        <div class="profile-header">
            <div class="profile-info">
                <div class="profile-avatar">
                    <i class="fas fa-user"></i>
                </div>
                <div class="profile-details">
                    <h2><%= user.getUsername() %></h2>
                    <div class="profile-stats">
                        <div class="stat-item">
                            <div class="stat-value"><%= orderCount %></div>
                            <div class="stat-label">Orders</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="profile-content">
            <div class="profile-sidebar">
                <ul class="profile-menu">
                    <li><a href="#" class="active" data-tab="dashboard"><i class="fas fa-home"></i> Dashboard</a></li>
                    <li><a href="#" data-tab="orders"><i class="fas fa-shopping-bag"></i> Orders</a></li>
                    <li><a href="#" data-tab="settings"><i class="fas fa-cog"></i> Settings</a></li>
                </ul>
            </div>

            <div class="profile-main">
                <% if (request.getParameter("success") != null) { %>
                    <div class="alert alert-success">
                        Profile updated successfully!
                    </div>
                <% } %>
                <% if (request.getParameter("error") != null) { %>
                    <div class="alert alert-error">
                        Failed to update profile. Please try again.
                    </div>
                <% } %>

                <div id="dashboard" class="tab-content active">
                    <h3>Dashboard</h3>
                    <p>Welcome to your profile dashboard. Here you can manage your orders and account settings.</p>
                </div>

                <div id="orders" class="tab-content">
                    <h3>My Orders</h3>
                    <% if (orderCount > 0) { %>
                        <div class="orders-list">
                            <% for (Transaction transaction : userTransactions) { %>
                                <div class="order-item">
                                    <div class="order-header">
                                        <span class="order-id">Order #<%= transaction.getTransactionId() %></span>
                                        <span class="order-date"><%= transaction.getTransactionDate() %></span>
                                    </div>
                                    <div class="order-details">
                                        <div class="product-info">
                                            <h4><%= transaction.getProduct().getProductName() %></h4>
                                            <p>Price: &#8377;<%= String.format("%.2f", transaction.getProduct().getPrice()) %></p>
                                        </div>
                                        <div class="seller-info">
                                            <p>Seller: <%= transaction.getSeller().getUsername() %></p>
                                        </div>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                    <% } else { %>
                        <p>No orders found.</p>
                    <% } %>
                </div>

                <div id="settings" class="tab-content">
                    <h3>Account Settings</h3>
                    <form action="profile.jsp" method="POST">
                        <input type="hidden" name="action" value="update_profile">
                        <div class="form-group">
                            <label for="enrollmentNumber">Enrollment Number</label>
                            <input type="text" id="enrollmentNumber" name="enrollmentNumber" value="<%= user.getEnrollmentNumber() != null ? user.getEnrollmentNumber() : "" %>">
                        </div>
                        <button type="submit" class="btn btn-primary">Update Profile</button>
                    </form>
                    <div style="margin-top: 2rem; padding-top: 2rem; border-top: 1px solid #eee;">
                        <h4 style="margin-bottom: 1rem;">Account Actions</h4>
                        <a href="logout.jsp" class="btn" style="background: #dc3545; color: white;">Logout</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="components/footer.html" />

    <script>
        // Tab switching functionality
        document.querySelectorAll('.profile-menu a').forEach(link => {
            link.addEventListener('click', (e) => {
                e.preventDefault();
                
                // Remove active class from all links and tabs
                document.querySelectorAll('.profile-menu a').forEach(l => l.classList.remove('active'));
                document.querySelectorAll('.tab-content').forEach(tab => tab.classList.remove('active'));
                
                // Add active class to clicked link
                link.classList.add('active');
                
                // Show corresponding tab
                const tabId = link.getAttribute('data-tab');
                document.getElementById(tabId).classList.add('active');
            });
        });

        // Initialize cart badge
        document.addEventListener('DOMContentLoaded', () => {
            updateCartBadge();
        });
    </script>
</body>
</html> 