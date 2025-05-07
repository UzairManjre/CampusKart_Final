<%@page import="AbstactClasses.UserDetails"%>
<%@page import="Database.StudentDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Campus Kart</title>
    <link rel="stylesheet" href="assets/css/common.css">
    <link rel="stylesheet" href="assets/css/login.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.5/gsap.min.js"></script>
    <style>
        .register-link {
            display: block;
            text-align: center;
            margin-top: 1rem;
            color: #4f46e5;
            text-decoration: none;
            font-size: 0.9rem;
            transition: color 0.2s;
        }

        .register-link:hover {
            color: #4338ca;
        }

        .register-link i {
            margin-right: 0.5rem;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-box">
            <h1>Login to Campus Kart</h1>
            <form class="login-form" action="Login" method="POST">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" required>
                </div>
                <button type="submit" class="login-btn">Login</button>
            </form>
            <a href="registration.jsp" class="register-link">
                <i class="fas fa-user-plus"></i>Don't have an account? Register here
            </a>
        </div>
    </div>

    <script>
        // Set userId in sessionStorage and window object after successful login
        <% 
        UserDetails user = (UserDetails) session.getAttribute("user");
        if (user != null) {
            int clientId = StudentDAO.getStudentByUsername(user.getUsername()).getClientId();
        %>
            window.userId = <%= clientId %>;
            sessionStorage.setItem('userId', '<%= clientId %>');
        <% } %>
    </script>
    <script src="assets/js/login.js"></script>
</body>
</html> 