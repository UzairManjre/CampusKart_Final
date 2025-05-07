package campuskart_ver02.servlets;

import campuskart_ver02.classes.CartItem;
import campuskart_ver02.classes.Product;
import Database.CartDAO;
import Database.ProductDAO;
import Database.StudentDAO;
import Database.TransactionDAO;
import AbstactClasses.UserDetails;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import Database.DatabaseConnection;
import campuskart_ver02.classes.Cart;

@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("login.html");
            return;
        }
        UserDetails user = (UserDetails) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.html");
            return;
        }
        int clientId = StudentDAO.getStudentByUsername(user.getUsername()).getClientId();
        try {
            // Get cart items using cartId
            Cart cart = CartDAO.getActiveCartByClientId(clientId);
            System.out.println("DEBUG: Cart for clientId=" + clientId + " is " + cart);
            List<CartItem> cartItems = cart != null ? CartDAO.getCartItems(cart.getCartId()) : new java.util.ArrayList<>();
            System.out.println("DEBUG: Cart items size = " + (cartItems != null ? cartItems.size() : "null"));
            if (cartItems != null) {
                for (CartItem item : cartItems) {
                    System.out.println("DEBUG: CartItem: productId=" + item.getProductId() + ", qty=" + item.getQuantity());
                }
            }
            if (cartItems == null || cartItems.isEmpty()) {
                response.sendRedirect("cart.jsp?empty=1");
                return;
            }
            // Process each item in the cart
            for (CartItem item : cartItems) {
                Product product = ProductDAO.getProductById(item.getProductId());
                if (product != null) {
                    int sellerId = product.getSeller().getClientId();
                    // Repeat transaction for each unit
                    for (int i = 0; i < item.getQuantity(); i++) {
                        boolean transactionSuccess = TransactionDAO.addTransaction(
                            product.getProductId(),
                            clientId,
                            sellerId
                        );
                        if (!transactionSuccess) {
                            request.setAttribute("error", "Failed to process transaction for product: " + product.getProductName());
                            request.getRequestDispatcher("checkout.jsp").forward(request, response);
                            return;
                        }
                    }
                    int newQuantity = product.getQuantity() - item.getQuantity();
                    ProductDAO.updateProductQuantity(product.getProductId(), newQuantity);
                    CartDAO.removeFromCart(clientId, product.getProductId());
                }
            }
            // Clear the cart after successful checkout
            CartDAO.clearCart(clientId);
            // Set order items in session for confirmation page
            session.setAttribute("orderItems", cartItems);
            // Set user info for order confirmation
            session.setAttribute("orderFullName", user.getUsername());
            session.setAttribute("orderEnrollmentNumber", user.getEnrollmentNumber());
            session.setAttribute("orderEmail", user.getEmail());
            session.setAttribute("orderPhone", ""); // Not available in DB
            session.setAttribute("orderAddress", ""); // Not available in DB
            // Fetch payment method for the latest transaction (if any)
            String paymentMethod = "Cash"; // Default fallback
            try (Connection conn = DatabaseConnection.initializeDB();
                 PreparedStatement stmt = conn.prepareStatement(
                    "SELECT payment_method FROM Payment ORDER BY pay_id DESC LIMIT 1")) {
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    paymentMethod = rs.getString("payment_method");
                }
            } catch (Exception e) {
                System.err.println("Error fetching payment method: " + e.getMessage());
            }
            session.setAttribute("orderPaymentMethod", paymentMethod);
            // Redirect to confirmation page
            response.sendRedirect("order-confirmation.jsp");
        } catch (SQLException e) {
            request.setAttribute("error", "An error occurred during checkout: " + e.getMessage());
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
        }
    }
} 