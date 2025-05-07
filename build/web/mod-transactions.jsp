<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="AbstactClasses.UserDetails" %>
<%@ page import="Database.TransactionDAO" %>
<%@ page import="campuskart_ver02.classes.Transaction" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
UserDetails user = (UserDetails) session.getAttribute("user");
if (user == null || !"Moderator".equalsIgnoreCase(user.getRole())) {
    response.sendRedirect("login.html");
    return;
}
String username = user.getUsername();
List<Transaction> transactions = TransactionDAO.getAllTransactions();
SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transaction History - CampusKart</title>
    <link rel="stylesheet" href="assets/css/common.css">
    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background: #f0f2f5; margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; }
        .mod-header { background: #fff; box-shadow: 0 2px 4px rgba(0,0,0,0.1); padding: 1rem 2rem; display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; }
        .mod-header .logo { font-size: 1.5rem; font-weight: 700; color: #4f46e5; text-decoration: none; }
        .mod-header .user-info { display: flex; align-items: center; gap: 1rem; }
        .mod-header .username { color: #374151; font-weight: 500; }
        .mod-header .logout-btn { background: #eef2ff; color: #4f46e5; border: 1px solid #c7d2fe; border-radius: 6px; padding: 0.5rem 1rem; font-size: 0.9rem; font-weight: 600; cursor: pointer; transition: all 0.2s; text-decoration: none; }
        .mod-header .logout-btn:hover { background: #4f46e5; color: #fff; }
        .transactions-container { max-width: 1200px; margin: 2rem auto; padding: 0 1rem; }
        .transactions-header { background: #fff; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.07); padding: 2rem 2.5rem; margin-bottom: 2.5rem; display: flex; justify-content: space-between; align-items: center; }
        .transactions-header .title { font-size: 2rem; font-weight: 700; color: #111827; }
        .transactions-header .subtitle { color: #6b7280; font-size: 1.1rem; margin-top: 0.5rem; }
        .transactions-header .search-box { display: flex; align-items: center; gap: 0.5rem; }
        .transactions-header input[type="text"] { padding: 0.6rem 1rem; border-radius: 6px; border: 1px solid #e5e7eb; font-size: 1rem; width: 250px; }
        .transactions-table-wrapper { background: #fff; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.07); padding: 2rem; overflow-x: auto; }
        table.transactions-table { width: 100%; border-collapse: collapse; }
        table.transactions-table th, table.transactions-table td { padding: 1rem; text-align: center; border-bottom: 1px solid #e5e7eb; }
        table.transactions-table th { background: #f3f4f6; color: #4f46e5; font-weight: 700; }
        table.transactions-table td { color: #374151; }
        table.transactions-table tr:last-child td { border-bottom: none; }
        @media (max-width: 900px) { .transactions-header { flex-direction: column; align-items: flex-start; gap: 1rem; } }
    </style>
    <script>
    function filterTable() {
        var input = document.getElementById('searchInput');
        var filter = input.value.toLowerCase();
        var table = document.getElementById('transactionsTable');
        var trs = table.getElementsByTagName('tr');
        for (var i = 1; i < trs.length; i++) {
            var tds = trs[i].getElementsByTagName('td');
            var show = false;
            for (var j = 0; j < tds.length; j++) {
                if (tds[j].innerText.toLowerCase().indexOf(filter) > -1) {
                    show = true;
                    break;
                }
            }
            trs[i].style.display = show ? '' : 'none';
        }
    }
    </script>
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
    <div class="transactions-container">
        <div class="transactions-header">
            <div>
                <div class="title">Transaction History</div>
                <div class="subtitle">View and manage all transactions</div>
            </div>
            <div class="search-box">
                <input type="text" id="searchInput" onkeyup="filterTable()" placeholder="Search transactions...">
                <i class="fas fa-search" style="color:#4f46e5;"></i>
            </div>
        </div>
        <div class="transactions-table-wrapper">
            <table class="transactions-table" id="transactionsTable">
                <thead>
                    <tr>
                        <th>Transaction ID</th>
                        <th>Date</th>
                        <th>Buyer</th>
                        <th>Seller</th>
                        <th>Product</th>
                        <th>Price (₹)</th>
                    </tr>
                </thead>
                <tbody>
                <% for (int i = 0; i < transactions.size(); i++) {
                    Transaction t = (Transaction) transactions.get(i);
                %>
                    <tr>
                        <td><%= t.getTransactionId() %></td>
                        <td><%= dateFormat.format(t.getTransactionDate()) %></td>
                        <td><%= t.getBuyer().getUsername() %></td>
                        <td><%= t.getSeller().getUsername() %></td>
                        <td><%= t.getProduct().getProductName() %></td>
                        <td><%= String.format("%.2f", t.getProduct().getPrice()) %></td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html> 