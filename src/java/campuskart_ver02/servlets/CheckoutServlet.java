package campuskart_ver02.servlets;

import campuskart_ver02.classes.CartItem;
import campuskart_ver02.classes.Product;
import Database.CartDAO;
import Database.ProductDAO;
import Database.StudentDAO;
import Database.TransactionDAO;
import AbstactClasses.UserDetails;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

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
            // Get cart items
            List<CartItem> cartItems = CartDAO.getCartItems(clientId);
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
            // Redirect to confirmation page
            response.sendRedirect("order-confirmation.jsp");
        } catch (SQLException e) {
            request.setAttribute("error", "An error occurred during checkout: " + e.getMessage());
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
        }
    }
} 