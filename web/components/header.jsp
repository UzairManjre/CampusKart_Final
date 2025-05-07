<%@ page import="AbstactClasses.UserDetails" %>
<%
UserDetails user = (UserDetails) session.getAttribute("user");
%>
<header class="main-header">
    <div class="header-container">
        <!-- Top Bar -->
        <div class="top-bar">
            <div class="contact-info">
                <a href="tel:+1234567890"><i class="fas fa-phone"></i> +1 (234) 567-890</a>
                <a href="mailto:support@campuskart.com"><i class="fas fa-envelope"></i> support@campuskart.com</a>
            </div>
        </div>

        <!-- Main Navigation -->
        <nav class="main-nav">
            <div class="nav-left">
                <a href="index.jsp" class="logo">
                    <h1>CampusKart</h1>
                </a>
            </div>

            <div class="nav-center">
                <div class="search-bar">
                    <input type="text" placeholder="Search for products...">
                    <button type="button">
                        <i class="fas fa-search"></i>
                    </button>
                </div>
            </div>

            <div class="nav-right">
                <div class="nav-icons">
                    <% if (user != null) { %>
                        <a href="profile.jsp" class="nav-icon">
                            <i class="far fa-user"></i>
                            <span><%= user.getUsername() %></span>
                        </a>
                        <a href="sell-product.jsp" class="nav-icon sell-button">
                            <i class="fas fa-tag"></i>
                            <span>Sell</span>
                        </a>
                    <% } else { %>
                        <a href="login.html" class="nav-icon">
                            <i class="far fa-user"></i>
                            <span>Login</span>
                        </a>
                    <% } %>
                    <a href="cart.jsp" class="nav-icon" data-type="cart">
                        <i class="fas fa-shopping-cart"></i>
                        <span>Cart</span>
                        <span class="badge">0</span>
                    </a>
                </div>
            </div>
        </nav>

        <!-- Category Navigation -->
        <div class="category-nav">
            <button class="mobile-menu-toggle">
                <i class="fas fa-bars"></i>
                <span>Menu</span>
            </button>
            <ul>
                <li><a href="#" onclick="goToCategory('Electronics'); event.preventDefault();">Electronics</a></li>
                <li><a href="#" onclick="goToCategory('Books'); event.preventDefault();">Books</a></li>
                <li><a href="#" onclick="goToCategory('Stationery'); event.preventDefault();">Stationery</a></li>
                <li><a href="#" onclick="goToCategory('Clothing'); event.preventDefault();">Clothing</a></li>
                <li><a href="#" onclick="goToCategory('Sports'); event.preventDefault();">Sports</a></li>
                <li><a href="#" onclick="goToCategory('Accessories'); event.preventDefault();">Accessories</a></li>
                <li><a href="#" onclick="goToCategory(''); event.preventDefault();">More</a></li>
            </ul>
        </div>
    </div>
</header> 