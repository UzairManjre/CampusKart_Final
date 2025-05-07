<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="AbstactClasses.UserDetails" %>
<%
UserDetails user = (UserDetails) session.getAttribute("user");
if (user == null || !"Moderator".equalsIgnoreCase(user.getRole())) {
    response.sendRedirect("login.html");
    return;
}
String username = user.getUsername();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Moderator Dashboard - CampusKart</title>
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
        .moddash-container {
            max-width: 1100px;
            margin: 2rem auto;
            padding: 0 1rem;
        }
        .moddash-header {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.07);
            padding: 2rem 2.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2.5rem;
        }
        .moddash-header .welcome {
            font-size: 2rem;
            font-weight: 700;
            color: #111827;
        }
        .moddash-header .subtitle {
            color: #6b7280;
            font-size: 1.1rem;
            margin-top: 0.5rem;
        }
        .moddash-main {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
        }
        .mod-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.07);
            padding: 2.5rem 2rem 2rem 2rem;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            min-height: 220px;
            border-left: 8px solid #4f46e5;
            transition: box-shadow 0.2s;
        }
        .mod-card.secondary { border-left-color: #10b981; }
        .mod-card.accent { border-left-color: #f59e0b; }
        .mod-card.pink { border-left-color: #ec4899; }
        .mod-card .card-title {
            font-size: 1.3rem;
            font-weight: 700;
            color: #111827;
            margin-bottom: 0.5rem;
        }
        .mod-card .card-desc {
            color: #6b7280;
            font-size: 1rem;
            margin-bottom: 1.5rem;
        }
        .mod-card .card-btn {
            align-self: flex-start;
            background: #4f46e5;
            color: #fff;
            border: none;
            border-radius: 6px;
            padding: 0.7rem 1.7rem;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s;
            text-decoration: none;
            display: inline-block;
        }
        .mod-card.secondary .card-btn { background: #10b981; }
        .mod-card.accent .card-btn { background: #f59e0b; }
        .mod-card.pink .card-btn { background: #ec4899; }
        .mod-card .card-btn:hover { opacity: 0.9; }
        @media (max-width: 900px) {
            .moddash-main { grid-template-columns: 1fr; }
        }
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
    <div class="moddash-container">
        <div class="moddash-header">
            <div>
                <div class="welcome">Welcome back, <%= username %>!</div>
                <div class="subtitle">Manage your store and monitor activities</div>
            </div>
        </div>
        <div class="moddash-main">
            <div class="mod-card secondary">
                <div class="card-title">Product Management</div>
                <div class="card-desc">Add, edit, or remove products from your store.</div>
                <a href="mod-products.jsp" class="card-btn">Manage Products</a>
            </div>
            <div class="mod-card accent">
                <div class="card-title">Sales Analytics</div>
                <div class="card-desc">View detailed sales reports and statistics.</div>
                <a href="mod-analytics.jsp" class="card-btn">View Analytics</a>
            </div>
            <div class="mod-card">
                <div class="card-title">Transactions</div>
                <div class="card-desc">Monitor and manage all transactions.</div>
                <a href="mod-transactions.jsp" class="card-btn">View Transactions</a>
            </div>
            <div class="mod-card pink">
                <div class="card-title">Store Overview</div>
                <div class="card-desc">Get a quick overview of your store's performance.</div>
                <a href="mod-overview.jsp" class="card-btn">View Overview</a>
            </div>
        </div>
    </div>
</body>
</html> 