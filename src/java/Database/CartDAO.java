package Database;

import campuskart_ver02.classes.Cart;
import campuskart_ver02.classes.CartItem;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;





public class CartDAO {
// In CartDAO.java, change the method name to match the one used in your Login.java file
public static Cart getActiveCart(int clientId) {
    Cart cart = null;
    String query = "SELECT * FROM carts WHERE c_id = ? AND status = 'ACTIVE'";

    try (Connection conn = DatabaseConnection.initializeDB();
         PreparedStatement ps = conn.prepareStatement(query)) {
         
        ps.setInt(1, clientId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            cart = new Cart();
            cart.setCartId(rs.getInt("cart_id"));
            cart.setStatus(rs.getString("status"));
            cart.setUser(StudentDAO.getStudentById(clientId)); // Assuming Student constructor accepts clientId
        }

        rs.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }

    return cart;
}

    // Method to get the active cart for a user by clientId
    public static Cart getActiveCartByClientId(int clientId) {
        Cart cart = null;
        String query = "SELECT * FROM carts WHERE c_id = ? AND status = 'ACTIVE'";

        try (Connection conn = DatabaseConnection.initializeDB();
             PreparedStatement ps = conn.prepareStatement(query)) {
             
            ps.setInt(1, clientId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                cart = new Cart();
                cart.setCartId(rs.getInt("cart_id"));
                cart.setStatus(rs.getString("status"));
                cart.setUser(StudentDAO.getStudentById(clientId)); // Assuming Student constructor accepts clientId
            }

            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return cart;
    }

    // Method to create a new cart for a user by clientId
    public static Cart createNewCart(int clientId) {
        Cart newCart = new Cart(StudentDAO.getStudentById(clientId));
        String query = "INSERT INTO carts (c_id, status) VALUES (?, 'ACTIVE')";

        try (Connection conn = DatabaseConnection.initializeDB();
             PreparedStatement ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
             
            ps.setInt(1, clientId);
            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    newCart.setCartId(rs.getInt(1));
                }
                rs.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return newCart;
    }

    // Method to add an item to the cart
    public static void addToCart(int clientId, int productId, int quantity) throws SQLException {
        String query = "INSERT INTO cart_items (cart_id, product_id, quantity) VALUES (?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DatabaseConnection.initializeDB();
            conn.setAutoCommit(false); // Start transaction
             
            // Get or create cart
            Cart cart = getActiveCartByClientId(clientId);
            if (cart == null) {
                cart = createNewCart(clientId);
            }
            
            if (cart == null) {
                throw new SQLException("Failed to create or retrieve cart");
            }

            // Check if item already exists in cart
            String checkQuery = "SELECT quantity FROM cart_items WHERE cart_id = ? AND product_id = ?";
            ps = conn.prepareStatement(checkQuery);
            ps.setInt(1, cart.getCartId());
            ps.setInt(2, productId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Update existing item
                int currentQuantity = rs.getInt("quantity");
                String updateQuery = "UPDATE cart_items SET quantity = ? WHERE cart_id = ? AND product_id = ?";
                ps = conn.prepareStatement(updateQuery);
                ps.setInt(1, currentQuantity + quantity);
                ps.setInt(2, cart.getCartId());
                ps.setInt(3, productId);
            } else {
                // Add new item
                ps = conn.prepareStatement(query);
                ps.setInt(1, cart.getCartId());
                ps.setInt(2, productId);
                ps.setInt(3, quantity);
            }

            ps.executeUpdate();
            conn.commit(); // Commit transaction

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback transaction on error
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw e;
        } finally {
            if (ps != null) {
                try {
                    ps.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
                }
            }
        }
    }

    // Method to remove an item from the cart
    public static void removeFromCart(int clientId, int productId) {
        String query = "DELETE FROM cart_items WHERE cart_id = ? AND product_id = ?";

        try (Connection conn = DatabaseConnection.initializeDB();
             PreparedStatement ps = conn.prepareStatement(query)) {
             
            Cart cart = getActiveCartByClientId(clientId);
            if (cart != null) {
                ps.setInt(1, cart.getCartId());
                ps.setInt(2, productId);
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Method to update the quantity of a product in the cart
    public static void updateCartItem(int clientId, int productId, int quantity) {
        String query = "UPDATE cart_items SET quantity = ? WHERE cart_id = ? AND product_id = ?";

        try (Connection conn = DatabaseConnection.initializeDB();
             PreparedStatement ps = conn.prepareStatement(query)) {
             
            Cart cart = getActiveCartByClientId(clientId);
            if (cart != null) {
                ps.setInt(1, quantity);
                ps.setInt(2, cart.getCartId());
                ps.setInt(3, productId);
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Method to get all items in a cart
    public static List<CartItem> getCartItems(int cartId) {
        List<CartItem> items = new ArrayList<>();
        String query = "SELECT * FROM cart_items WHERE cart_id = ?";

        try (Connection conn = DatabaseConnection.initializeDB();
             PreparedStatement ps = conn.prepareStatement(query)) {
             
            ps.setInt(1, cartId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                CartItem item = new CartItem();
                item.setCartId(cartId);
                item.setProductId(rs.getInt("product_id"));
                item.setQuantity(rs.getInt("quantity"));
                items.add(item);
            }
            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return items;
    }

    // Method to get the total number of items in a cart
    public static int getCartItemCount(int clientId) {
        int count = 0;
        String query = "SELECT SUM(quantity) as total FROM cart_items ci " +
                      "JOIN carts c ON ci.cart_id = c.cart_id " +
                      "WHERE c.c_id = ? AND c.status = 'ACTIVE'";

        try (Connection conn = DatabaseConnection.initializeDB();
             PreparedStatement ps = conn.prepareStatement(query)) {
             
            ps.setInt(1, clientId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt("total");
            }
            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return count;
    }

    // Method to clear all items from a user's cart
    public static void clearCart(int clientId) throws SQLException {
        String query = "DELETE FROM cart_items WHERE cart_id IN (SELECT cart_id FROM carts WHERE c_id = ? AND status = 'ACTIVE')";

        try (Connection conn = DatabaseConnection.initializeDB();
             PreparedStatement ps = conn.prepareStatement(query)) {
             
            ps.setInt(1, clientId);
            ps.executeUpdate();
        }
    }
}
