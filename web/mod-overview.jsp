<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="AbstactClasses.UserDetails" %>
<%@ page import="Database.ProductDAO" %>
<%@ page import="Database.TransactionDAO" %>
<%@ page import="campuskart_ver02.classes.Product" %>
<%@ page import="campuskart_ver02.classes.Transaction" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Comparator" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%
UserDetails user = (UserDetails) session.getAttribute("user");
if (user == null || !"Moderator".equalsIgnoreCase(user.getRole())) {
    response.sendRedirect("login.html");
    return;
}
String username = user.getUsername();
List<Product> products = ProductDAO.getAllProducts();
List<Transaction> transactions = TransactionDAO.getAllTransactions();
// Quick Stats
int totalProducts = products.size();
int totalTransactions = transactions.size();
double totalRevenue = 0;
for (int i = 0; i < transactions.size(); i++) {
    Transaction t = (Transaction) transactions.get(i);
    totalRevenue += t.getProduct().getPrice();
}
double avgOrderValue = totalTransactions > 0 ? totalRevenue / totalTransactions : 0;
// Inventory by Category
Map inventoryByCategory = new HashMap();
for (int i = 0; i < products.size(); i++) {
    Product p = (Product) products.get(i);
    String cat = p.getCategory();
    Integer count = (Integer) inventoryByCategory.get(cat);
    inventoryByCategory.put(cat, count == null ? 1 : count + 1);
}
// Price Distribution
Map priceRanges = new LinkedHashMap();
priceRanges.put("₹0 - ₹500", new Integer(0));
priceRanges.put("₹501 - ₹1000", new Integer(0));
priceRanges.put("₹1001 - ₹2000", new Integer(0));
priceRanges.put("₹2001 - ₹5000", new Integer(0));
priceRanges.put("Above ₹5000", new Integer(0));
for (int i = 0; i < products.size(); i++) {
    double price = ((Product) products.get(i)).getPrice();
    if (price <= 500) priceRanges.put("₹0 - ₹500", ((Integer) priceRanges.get("₹0 - ₹500")).intValue() + 1);
    else if (price <= 1000) priceRanges.put("₹501 - ₹1000", ((Integer) priceRanges.get("₹501 - ₹1000")).intValue() + 1);
    else if (price <= 2000) priceRanges.put("₹1001 - ₹2000", ((Integer) priceRanges.get("₹1001 - ₹2000")).intValue() + 1);
    else if (price <= 5000) priceRanges.put("₹2001 - ₹5000", ((Integer) priceRanges.get("₹2001 - ₹5000")).intValue() + 1);
    else priceRanges.put("Above ₹5000", ((Integer) priceRanges.get("Above ₹5000")).intValue() + 1);
}
// User Statistics (DB count)
int studentCount = 0;
int moderatorCount = 0;
try {
    Connection conn = Database.DatabaseConnection.initializeDB();
    Statement stmt = conn.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM Client");
    if (rs.next()) studentCount = rs.getInt(1);
    rs = stmt.executeQuery("SELECT COUNT(*) FROM Moderator");
    if (rs.next()) moderatorCount = rs.getInt(1);
    rs.close(); stmt.close(); conn.close();
} catch (SQLException e) { studentCount = 0; moderatorCount = 0; }
// Recent Activity (last 5 transactions)
List recentActivity = new ArrayList();
Collections.sort(transactions, new Comparator() {
    public int compare(Object a, Object b) {
        Transaction t1 = (Transaction) a;
        Transaction t2 = (Transaction) b;
        return t2.getTransactionDate().compareTo(t1.getTransactionDate());
    }
});
for (int i = 0; i < transactions.size() && i < 5; i++) {
    Transaction t = (Transaction) transactions.get(i);
    String entry = new java.text.SimpleDateFormat("MMM dd, yyyy").format(t.getTransactionDate()) + ": " +
        t.getBuyer().getUsername() + " bought " + t.getProduct().getProductName() + " for ₹" + String.format("%.2f", t.getProduct().getPrice());
    recentActivity.add(entry);
}
// Store Health
Map sellerSet = new HashMap();
for (int i = 0; i < transactions.size(); i++) {
    sellerSet.put(transactions.get(i).getSeller().getUsername(), Boolean.TRUE);
}
int activeSellers = sellerSet.size();
int categoryCount = inventoryByCategory.size();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Store Overview - CampusKart</title>
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
        .overview-container { max-width: 1100px; margin: 2rem auto; padding: 0 1rem; }
        .overview-header { background: #fff; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.07); padding: 2rem 2.5rem; margin-bottom: 2.5rem; }
        .overview-header .title { font-size: 2rem; font-weight: 700; color: #111827; }
        .overview-header .subtitle { color: #6b7280; font-size: 1.1rem; margin-top: 0.5rem; }
        .overview-main { display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; }
        .overview-card { background: #fff; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.07); padding: 2.5rem 2rem 2rem 2rem; display: flex; flex-direction: column; min-height: 220px; border-left: 8px solid #4f46e5; transition: box-shadow 0.2s; }
        .overview-card.secondary { border-left-color: #10b981; }
        .overview-card.accent { border-left-color: #f59e0b; }
        .overview-card.pink { border-left-color: #ec4899; }
        .overview-card.purple { border-left-color: #8b5cf6; }
        .overview-card.danger { border-left-color: #ef4444; }
        .overview-card .card-title { font-size: 1.3rem; font-weight: 700; color: #111827; margin-bottom: 0.5rem; }
        .overview-card .card-desc { color: #6b7280; font-size: 1rem; margin-bottom: 1.5rem; }
        .overview-card ul { margin: 0; padding-left: 1.2rem; }
        .overview-card li { color: #374151; font-size: 1rem; margin-bottom: 0.5rem; }
        @media (max-width: 900px) { .overview-main { grid-template-columns: 1fr; } }
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
    <div class="overview-container">
        <div class="overview-header">
            <div class="title">Store Overview</div>
            <div class="subtitle">Comprehensive view of your store's performance</div>
        </div>
        <div class="overview-main">
            <div class="overview-card">
                <div class="card-title">📊 Quick Stats</div>
                <div class="card-desc">
                    Total Products: <b><%= totalProducts %></b><br>
                    Total Students: <b><%= studentCount %></b><br>
                    Total Transactions: <b><%= totalTransactions %></b><br>
                    Total Revenue: <b>₹<%= String.format("%.2f", totalRevenue) %></b>
                </div>
            </div>
            <div class="overview-card secondary">
                <div class="card-title">📦 Inventory by Category</div>
                <ul>
                <% 
                List topCats = new ArrayList(inventoryByCategory.entrySet());
                Collections.sort(topCats, new Comparator() {
                    public int compare(Object a, Object b) {
                        Map.Entry e1 = (Map.Entry) a;
                        Map.Entry e2 = (Map.Entry) b;
                        Comparable v1 = (Comparable) e1.getValue();
                        Comparable v2 = (Comparable) e2.getValue();
                        return v2.compareTo(v1);
                    }
                });
                if (topCats.size() > 6) topCats = topCats.subList(0, 6);
                for (int i = 0; i < topCats.size(); i++) { Map.Entry entry = (Map.Entry) topCats.get(i); %>
                    <li><%= entry.getKey() %>: <%= entry.getValue() %> items</li>
                <% } %>
                </ul>
            </div>
            <div class="overview-card accent">
                <div class="card-title">💰 Price Distribution</div>
                <ul>
                <% List priceDist = new ArrayList(priceRanges.entrySet()); for (int i = 0; i < priceDist.size(); i++) { Map.Entry entry = (Map.Entry) priceDist.get(i); %>
                    <li><%= entry.getKey() %>: <%= entry.getValue() %> products</li>
                <% } %>
                </ul>
            </div>
            <div class="overview-card pink">
                <div class="card-title">👥 User Statistics</div>
                <ul>
                    <li>Students: <%= studentCount %> users</li>
                    <li>Moderators: <%= moderatorCount %> users</li>
                </ul>
            </div>
            <div class="overview-card purple">
                <div class="card-title">🕒 Recent Activity</div>
                <ul>
                <% for (int i = 0; i < recentActivity.size(); i++) { %>
                    <li><%= recentActivity.get(i) %></li>
                <% } %>
                </ul>
            </div>
            <div class="overview-card danger">
                <div class="card-title">❤️ Store Health</div>
                <div class="card-desc">
                    Active Products: <b><%= totalProducts %></b><br>
                    Active Sellers: <b><%= activeSellers %></b><br>
                    Avg. Order Value: <b>₹<%= String.format("%.2f", avgOrderValue) %></b><br>
                    Product Categories: <b><%= categoryCount %></b>
                </div>
            </div>
        </div>
    </div>
</body>
</html> 