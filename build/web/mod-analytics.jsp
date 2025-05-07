<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="AbstactClasses.UserDetails" %>
<%@ page import="Database.TransactionDAO" %>
<%@ page import="campuskart_ver02.classes.Transaction" %>
<%@ page import="campuskart_ver02.classes.Product" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Comparator" %>
<%
UserDetails user = (UserDetails) session.getAttribute("user");
if (user == null || !"Moderator".equalsIgnoreCase(user.getRole())) {
    response.sendRedirect("login.html");
    return;
}
String username = user.getUsername();
List<Transaction> transactions = TransactionDAO.getAllTransactions();

// Calculate stats
int totalTransactions = transactions.size();
double totalRevenue = 0;
Map productSales = new HashMap();
Map sellerRevenue = new HashMap();
Map categoryRevenue = new HashMap();
for (int i = 0; i < transactions.size(); i++) {
    Transaction t = (Transaction) transactions.get(i);
    Product p = t.getProduct();
    String productName = p.getProductName();
    String sellerName = t.getSeller().getUsername();
    String category = p.getCategory();
    double price = p.getPrice();
    totalRevenue += price;
    // Product sales
    Integer prodCount = (Integer) productSales.get(productName);
    productSales.put(productName, prodCount == null ? 1 : prodCount + 1);
    // Seller revenue
    Double sellerRev = (Double) sellerRevenue.get(sellerName);
    sellerRevenue.put(sellerName, sellerRev == null ? price : sellerRev + price);
    // Category revenue
    Double catRev = (Double) categoryRevenue.get(category);
    categoryRevenue.put(category, catRev == null ? price : catRev + price);
}
double avgOrderValue = totalTransactions > 0 ? totalRevenue / totalTransactions : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sales Analytics - CampusKart</title>
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
        .analytics-container { max-width: 1100px; margin: 2rem auto; padding: 0 1rem; }
        .analytics-header { background: #fff; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.07); padding: 2rem 2.5rem; margin-bottom: 2.5rem; }
        .analytics-header .title { font-size: 2rem; font-weight: 700; color: #111827; }
        .analytics-header .subtitle { color: #6b7280; font-size: 1.1rem; margin-top: 0.5rem; }
        .analytics-main { display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; }
        .analytics-card { background: #fff; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.07); padding: 2.5rem 2rem 2rem 2rem; display: flex; flex-direction: column; min-height: 220px; border-left: 8px solid #4f46e5; transition: box-shadow 0.2s; }
        .analytics-card.secondary { border-left-color: #10b981; }
        .analytics-card.accent { border-left-color: #f59e0b; }
        .analytics-card.pink { border-left-color: #ec4899; }
        .analytics-card .card-title { font-size: 1.3rem; font-weight: 700; color: #111827; margin-bottom: 0.5rem; }
        .analytics-card .card-desc { color: #6b7280; font-size: 1rem; margin-bottom: 1.5rem; }
        .analytics-card ul { margin: 0; padding-left: 1.2rem; }
        .analytics-card li { color: #374151; font-size: 1rem; margin-bottom: 0.5rem; }
        @media (max-width: 900px) { .analytics-main { grid-template-columns: 1fr; } }
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
    <div class="analytics-container">
        <div class="analytics-header">
            <div class="title">Sales Analytics</div>
            <div class="subtitle">Track your store's performance</div>
        </div>
        <div class="analytics-main">
            <div class="analytics-card">
                <div class="card-title">📊 Overview</div>
                <div class="card-desc">
                    Total Transactions: <b><%= totalTransactions %></b><br>
                    Total Revenue: <b>₹<%= String.format("%.2f", totalRevenue) %></b><br>
                    Average Order Value: <b>₹<%= String.format("%.2f", avgOrderValue) %></b>
                </div>
            </div>
            <div class="analytics-card secondary">
                <div class="card-title">🔥 Top Products</div>
                <ul>
                <% 
                List topProducts = new ArrayList(productSales.entrySet());
                Collections.sort(topProducts, new Comparator() {
                    public int compare(Object a, Object b) {
                        Map.Entry e1 = (Map.Entry) a;
                        Map.Entry e2 = (Map.Entry) b;
                        Comparable v1 = (Comparable) e1.getValue();
                        Comparable v2 = (Comparable) e2.getValue();
                        return v2.compareTo(v1);
                    }
                });
                if (topProducts.size() > 5) topProducts = topProducts.subList(0, 5);
                for (int i = 0; i < topProducts.size(); i++) { Map.Entry entry = (Map.Entry) topProducts.get(i); %>
                    <li><%= entry.getKey() %>: <%= entry.getValue() %> sales</li>
                <% } %>
                </ul>
            </div>
            <div class="analytics-card accent">
                <div class="card-title">👑 Top Sellers</div>
                <ul>
                <% 
                List topSellers = new ArrayList(sellerRevenue.entrySet());
                Collections.sort(topSellers, new Comparator() {
                    public int compare(Object a, Object b) {
                        Map.Entry e1 = (Map.Entry) a;
                        Map.Entry e2 = (Map.Entry) b;
                        Comparable v1 = (Comparable) e1.getValue();
                        Comparable v2 = (Comparable) e2.getValue();
                        return v2.compareTo(v1);
                    }
                });
                if (topSellers.size() > 5) topSellers = topSellers.subList(0, 5);
                for (int i = 0; i < topSellers.size(); i++) { Map.Entry entry = (Map.Entry) topSellers.get(i); %>
                    <li><%= entry.getKey() %>: ₹<%= String.format("%.2f", entry.getValue()) %></li>
                <% } %>
                </ul>
            </div>
            <div class="analytics-card pink">
                <div class="card-title">📦 Category Performance</div>
                <ul>
                <% 
                List topCategories = new ArrayList(categoryRevenue.entrySet());
                Collections.sort(topCategories, new Comparator() {
                    public int compare(Object a, Object b) {
                        Map.Entry e1 = (Map.Entry) a;
                        Map.Entry e2 = (Map.Entry) b;
                        Comparable v1 = (Comparable) e1.getValue();
                        Comparable v2 = (Comparable) e2.getValue();
                        return v2.compareTo(v1);
                    }
                });
                if (topCategories.size() > 5) topCategories = topCategories.subList(0, 5);
                for (int i = 0; i < topCategories.size(); i++) { Map.Entry entry = (Map.Entry) topCategories.get(i); %>
                    <li><%= entry.getKey() %>: ₹<%= String.format("%.2f", entry.getValue()) %></li>
                <% } %>
                </ul>
            </div>
        </div>
    </div>
</body>
</html> 