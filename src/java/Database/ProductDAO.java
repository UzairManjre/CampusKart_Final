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




import campuskart_ver02.classes.Product;
import campuskart_ver02.classes.Student;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import static Database.StudentDAO.getStudentById;
import static Database.StudentDAO.getStudentByUsername;

public class ProductDAO {
    
public static boolean addProduct(Product product) {
    String insertProductQuery = "INSERT INTO Products (pname, pdesc, p_price, qty, category, status, image_path, s_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    System.out.println("Seller ID: " + product.getSeller().getClientId());

    try (Connection conn = DatabaseConnection.initializeDB();
         PreparedStatement pstmt = conn.prepareStatement(insertProductQuery, PreparedStatement.RETURN_GENERATED_KEYS)) {
        
        pstmt.setString(1, product.getProductName());
        pstmt.setString(2, product.getDescription());
        pstmt.setDouble(3, product.getPrice());
        pstmt.setInt(4, product.getQuantity());
        pstmt.setString(5, product.getCategory());
        pstmt.setString(6, "Available");  // Default status
        pstmt.setString(7, product.getImagePath()); // Set image path (can be null)
        pstmt.setInt(8, product.getSeller().getClientId()); // Seller's ID

        int rowsAffected = pstmt.executeUpdate();
        if (rowsAffected > 0) {
            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    int productId = generatedKeys.getInt(1);
                    product.setProductId(productId);
                    return true;
                }
            }
        }
    } catch (SQLException e) {
        System.err.println("Error adding product: " + e.getMessage());
    }
    return false;
}  // Method to fetch all products
    public static List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String query = "SELECT * FROM Products";

        try (Connection conn = DatabaseConnection.initializeDB();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                int sellerId = rs.getInt("s_id");
                Student seller = getStudentById(sellerId);
                if (seller == null) continue;

                Product product = new Product(
                        rs.getInt("pr_id"),
                        rs.getString("pname"),
                        rs.getString("pdesc"),
                        rs.getDouble("p_price"),
                        rs.getInt("qty"),
                        rs.getString("category"),
                        rs.getString("status"),
                        seller,
                        rs.getString("image_path")
                );
                products.add(product);
            }

        } catch (SQLException e) {
            System.err.println("Error fetching products: " + e.getMessage());
        }
        return products;
    }

    // Method to fetch a product by ID
    public static Product getProductById(int productId) {
        String query = "SELECT * FROM Products WHERE pr_id = ?";

        try (Connection conn = DatabaseConnection.initializeDB();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, productId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                int sellerId = rs.getInt("s_id");
                Student seller = getStudentById(sellerId);

                return new Product(
                        rs.getInt("pr_id"),
                        rs.getString("pname"),
                        rs.getString("pdesc"),
                        rs.getDouble("p_price"),
                        rs.getInt("qty"),
                        rs.getString("category"),
                        rs.getString("status"),
                        seller,
                        rs.getString("image_path")
                );
            }
        } catch (SQLException e) {
            System.err.println("Error fetching product: " + e.getMessage());
        }
        return null;
    }
    public static void deleteProduct(int productId) throws SQLException {
        Connection conn = DatabaseConnection.initializeDB();
        String sql = "DELETE FROM products WHERE pr_id = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, productId);
        stmt.executeUpdate();
    }


    public static List<Product> getProductsBySellerName(String sellerName) {
        List<Product> products = new ArrayList<>();

        String query = "SELECT p.* " +
                "FROM Products p " +
                "JOIN Client c ON p.s_id = c.c_id " +
                "JOIN User u ON c.username = u.username " +
                "WHERE u.username = ?";

        try (Connection conn = DatabaseConnection.initializeDB();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, sellerName);
            ResultSet rs = pstmt.executeQuery();

            // First, get the seller object using the name
            Student seller = getStudentByUsername(sellerName); // You must have this method defined

            while (rs.next()) {
                products.add(new Product(
                        rs.getInt("pr_id"),
                        rs.getString("pname"),
                        rs.getString("pdesc"),
                        rs.getDouble("p_price"),
                        rs.getString("category"),
                        rs.getInt("qty"),
                        seller
                ));
            }

        } catch (SQLException e) {
            System.err.println("Error fetching products by seller name: " + e.getMessage());
        }

        return products;
    }

    public static boolean updateProductQuantity(int productId, int newQuantity) {
        String updateQuery = "UPDATE Products SET qty = ?, status = CASE WHEN ? <= 0 THEN 'Sold' ELSE 'Available' END WHERE pr_id = ?";

        try (Connection conn = DatabaseConnection.initializeDB();
             PreparedStatement pstmt = conn.prepareStatement(updateQuery)) {

            pstmt.setInt(1, newQuantity);
            pstmt.setInt(2, newQuantity);
            pstmt.setInt(3, productId);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error updating product quantity: " + e.getMessage());
            return false;
        }
    }


    // Method to fetch all products by a specific seller
    public static List<Product> getProductsBySeller(int sellerId) {
        List<Product> products = new ArrayList<>();
        String query = "SELECT * FROM Products WHERE s_id = ?";

        try (Connection conn = DatabaseConnection.initializeDB();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, sellerId);
            ResultSet rs = pstmt.executeQuery();
            Student seller = getStudentById(sellerId);

            while (rs.next()) {
                products.add(new Product(
                        rs.getInt("pr_id"),
                        rs.getString("pname"),
                        rs.getString("pdesc"),
                        rs.getDouble("p_price"),
                        rs.getInt("qty"),
                        rs.getString("category"),
                        rs.getString("status"),
                        seller,
                        rs.getString("image_path")
                ));
            }

        } catch (SQLException e) {
            System.err.println("Error fetching seller's products: " + e.getMessage());
        }
        return products;
    }
    public static List<Product> getProductsByName(String name) {
        List<Product> products = new ArrayList<>();
        String query = "SELECT * FROM Products WHERE pname LIKE ?";

        try (Connection conn = DatabaseConnection.initializeDB();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, "%" + name + "%");
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                int sellerId = rs.getInt("s_id");
                Student seller = getStudentById(sellerId);

                if (seller != null) {
                    products.add(new Product(
                            rs.getInt("pr_id"),
                            rs.getString("pname"),
                            rs.getString("pdesc"),
                            rs.getDouble("p_price"),
                            rs.getInt("qty"),
                            rs.getString("category"),
                            rs.getString("status"),
                            seller,
                            rs.getString("image_path")
                    ));
                }
            }

        } catch (SQLException e) {
            System.err.println("Error searching products by name: " + e.getMessage());
        }
        return products;
    }

    // Method to fetch products by category
    public static List<Product> getProductsByCategory(String category) {
        List<Product> products = new ArrayList<>();
        String query = "SELECT * FROM Products WHERE category = ?";

        try (Connection conn = DatabaseConnection.initializeDB();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, category);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                int sellerId = rs.getInt("s_id");
                Student seller = getStudentById(sellerId);
                if (seller == null) continue;

                Product product = new Product(
                        rs.getInt("pr_id"),
                        rs.getString("pname"),
                        rs.getString("pdesc"),
                        rs.getDouble("p_price"),
                        rs.getInt("qty"),
                        rs.getString("category"),
                        rs.getString("status"),
                        seller,
                        rs.getString("image_path")
                );
                products.add(product);
            }

        } catch (SQLException e) {
            System.err.println("Error fetching products by category: " + e.getMessage());
        }
        return products;
    }

}
