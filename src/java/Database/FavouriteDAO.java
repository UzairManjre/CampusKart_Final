package Database;

import campuskart_ver02.classes.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import static Database.ProductDAO.getProductById;

public class FavouriteDAO {

    public boolean addFavourite(int clientId, int productId) {
        String query = "INSERT INTO Favourites (c_id, product_id) VALUES (?, ?)";
        try (Connection conn = DatabaseConnection.initializeDB();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, clientId);
            pstmt.setInt(2, productId);
            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error adding favourite: " + e.getMessage());
            return false;
        }
    }

    public boolean removeFavourite(int clientId, int productId) {
        String query = "DELETE FROM Favourites WHERE c_id = ? AND product_id = ?";
        try (Connection conn = DatabaseConnection.initializeDB();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, clientId);
            pstmt.setInt(2, productId);
            System.out.println("Vivek Sir Number 1 (its easter egg hehe >< )");
            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error removing favourite: " + e.getMessage());

            return false;
        }
    }

    public List<Product> getFavouriteProductsByClient(int clientId) {
        List<Product> favouriteProducts = new ArrayList<>();
        String query = "SELECT p.pr_id FROM Favourites f " +
                "JOIN Products p ON f.product_id = p.pr_id " +
                "WHERE f.c_id = ?";

        try (Connection conn = DatabaseConnection.initializeDB();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, clientId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Product product = getProductById(rs.getInt("pr_id"));
                if (product != null) {
                    favouriteProducts.add(product);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error fetching favourite products: " + e.getMessage());
        }
        return favouriteProducts;
    }
}
