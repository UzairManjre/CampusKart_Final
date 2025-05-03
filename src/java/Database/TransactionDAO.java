/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Database;

/**
 *
 * @author uzair
 */


import Database.DatabaseConnection;
import campuskart_ver02.classes.Product;
import campuskart_ver02.classes.Student;
import campuskart_ver02.classes.Transaction;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TransactionDAO {

    // Add a new transaction
    public static boolean addTransaction(int productId, int buyerId, int sellerId) {
        String sql = "INSERT INTO Transactions (p_id, buyer_id, seller_id) VALUES (?, ?, ?)";

        try (Connection conn = DatabaseConnection.initializeDB();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, productId);
            stmt.setInt(2, buyerId);
            stmt.setInt(3, sellerId);

            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                return false;
            }

            // Get transaction ID
            ResultSet generatedKeys = stmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                int transactionId = generatedKeys.getInt(1);

                // Add corresponding payment (default: Pending)
                return addPayment(transactionId, productId);
            }

        } catch (SQLException e) {
            System.err.println("Transaction Error: " + e.getMessage());
        }
        return false;
    }

    // Add a default payment entry for a transaction
    private static boolean addPayment(int transactionId, int productId) {
        String sql = "INSERT INTO Payment (t_id, amount, payment_status, payment_method) " +
                     "VALUES (?, (SELECT p_price FROM Products WHERE pr_id = ?), 'Pending', 'Cash')";

        try (Connection conn = DatabaseConnection.initializeDB();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, transactionId);
            stmt.setInt(2, productId);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Payment Error: " + e.getMessage());
        }
        return false;
    }

    // Get all transactions for a specific user
    // Get all transactions for a specific user
    public static List<Transaction> getUserTransactions(int userId) {
        List<Transaction> transactions = new ArrayList<>();
        String sql = "SELECT t.t_id, t.t_date, t.p_id, t.buyer_id, t.seller_id, " +
                "p.pname, c1.username AS buyer, c2.username AS seller " +
                "FROM Transactions t " +
                "JOIN Products p ON t.p_id = p.pr_id " +
                "JOIN Client c1 ON t.buyer_id = c1.c_id " +
                "JOIN Client c2 ON t.seller_id = c2.c_id " +
                "WHERE t.buyer_id = ? OR t.seller_id = ?";

        try (Connection conn = DatabaseConnection.initializeDB();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                int t_id = rs.getInt("t_id");
                Timestamp t_date = rs.getTimestamp("t_date");
                Product product = ProductDAO.getProductById(rs.getInt("p_id"));
                Student buyer = StudentDAO.getStudentById(rs.getInt("buyer_id"));
                Student seller = StudentDAO.getStudentById(rs.getInt("seller_id"));

                Transaction transaction = new Transaction(t_id, t_date, buyer, seller, product);
                transactions.add(transaction);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching user transactions: " + e.getMessage());
        }
        return transactions;
    }

    // Get all transactions (For Moderators)
    public static List<Transaction> getAllTransactions() {
        List<Transaction> transactions = new ArrayList<>();
        String sql = "SELECT t.t_id, t.t_date, t.p_id, t.buyer_id, t.seller_id, " +
                "p.pname, c1.username AS buyer, c2.username AS seller " +
                "FROM Transactions t " +
                "JOIN Products p ON t.p_id = p.pr_id " +
                "JOIN Client c1 ON t.buyer_id = c1.c_id " +
                "JOIN Client c2 ON t.seller_id = c2.c_id";

        try (Connection conn = DatabaseConnection.initializeDB();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                int t_id = rs.getInt("t_id");
                Timestamp t_date = rs.getTimestamp("t_date");
                Product product = ProductDAO.getProductById(rs.getInt("p_id"));
                Student buyer = StudentDAO.getStudentById(rs.getInt("buyer_id"));
                Student seller = StudentDAO.getStudentById(rs.getInt("seller_id"));

                Transaction transaction = new Transaction(t_id, t_date, buyer, seller, product);
                transactions.add(transaction);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching all transactions: " + e.getMessage());
        }
        return transactions;
    }



}
