<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="components/header.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - CampusKart</title>
    <link rel="stylesheet" href="./assets/css/common.css">
    <link rel="stylesheet" href="./assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .register-container {
            max-width: 500px;
            margin: 2rem auto;
            padding: 2rem;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .register-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .register-header i {
            font-size: 3rem;
            color: #4f46e5;
            margin-bottom: 1rem;
        }

        .register-header h1 {
            font-size: 2rem;
            color: #111827;
            margin-bottom: 0.5rem;
        }

        .register-header p {
            color: #6b7280;
            font-size: 1rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: #111827;
            font-size: 0.9rem;
        }

        .form-control {
            width: 100%;
            padding: 0.75rem 1rem;
            font-size: 1rem;
            border: 1px solid #e5e7eb;
            border-radius: 5px;
            transition: border-color 0.2s;
        }

        .form-control:focus {
            outline: none;
            border-color: #4f46e5;
            box-shadow: 0 0 0 2px rgba(79, 70, 229, 0.1);
        }

        .role-select {
            width: 100%;
            padding: 0.75rem 1rem;
            font-size: 1rem;
            border: 1px solid #e5e7eb;
            border-radius: 5px;
            background-color: #fff;
            cursor: pointer;
        }

        .role-select:focus {
            outline: none;
            border-color: #4f46e5;
            box-shadow: 0 0 0 2px rgba(79, 70, 229, 0.1);
        }

        .btn-register {
            width: 100%;
            padding: 0.75rem;
            font-size: 1.1rem;
            font-weight: 600;
            color: #fff;
            background-color: #4f46e5;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.2s;
        }

        .btn-register:hover {
            background-color: #4338ca;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 1.5rem;
            color: #6b7280;
            text-decoration: none;
            font-size: 1rem;
            transition: color 0.2s;
        }

        .back-link:hover {
            color: #111827;
        }

        .alert {
            padding: 1rem;
            margin-bottom: 1rem;
            border-radius: 5px;
            font-size: 0.9rem;
        }

        .alert-danger {
            background-color: #fee2e2;
            color: #991b1b;
            border: 1px solid #fecaca;
        }

        .alert-success {
            background-color: #dcfce7;
            color: #166534;
            border: 1px solid #bbf7d0;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="register-header">
            <i class="fas fa-user-plus"></i>
            <h1>Create Account</h1>
            <p>Fill in your details to get started</p>
        </div>

        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger">
                <%= request.getParameter("error") %>
            </div>
        <% } %>

        <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success">
                Registration successful! Please login to continue.
            </div>
        <% } %>

        <form action="RegisterServlet" method="POST" onsubmit="return validateForm()">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" class="form-control" required>
            </div>

            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" class="form-control" required>
            </div>

            <div class="form-group">
                <label for="enrollment">Enrollment Number</label>
                <input type="text" id="enrollment" name="enrollment" class="form-control" required>
            </div>

            <div class="form-group">
                <label for="role">Role</label>
                <select id="role" name="role" class="role-select" required>
                    <option value="Student">Student</option>
                    <option value="Moderator">Moderator</option>
                </select>
            </div>

            <button type="submit" class="btn-register">Create Account</button>
        </form>

        <a href="index.jsp" class="back-link">← Back to Home</a>
    </div>

    <jsp:include page="components/footer.html" />

    <script>
        function validateForm() {
            const username = document.getElementById('username').value.trim();
            const email = document.getElementById('email').value.trim();
            const enrollment = document.getElementById('enrollment').value.trim();
            const role = document.getElementById('role').value;

            if (username === '') {
                alert('Please enter your username');
                return false;
            }

            if (email === '') {
                alert('Please enter your email');
                return false;
            }

            if (!isValidEmail(email)) {
                alert('Please enter a valid email address');
                return false;
            }

            if (enrollment === '') {
                alert('Please enter your enrollment number');
                return false;
            }

            return true;
        }

        function isValidEmail(email) {
            const emailRegex = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$/;
            return emailRegex.test(email);
        }
    </script>
</body>
</html> 