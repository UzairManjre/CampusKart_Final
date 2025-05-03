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
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.5/gsap.min.js"></script>
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