package campuskart_ver02.servlets;

import Database.CartDAO;
import Database.ProductDAO;
import campuskart_ver02.classes.Cart;
import campuskart_ver02.classes.CartItem;
import campuskart_ver02.classes.Product;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            int clientId = Integer.parseInt(request.getParameter("c_id"));
            
            if (clientId <= 0 || action == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Invalid request parameters.");
                return;
            }

            switch (action) {
                case "getCount":
                    handleGetCount(clientId, response);
                    break;
                case "getCart":
                    handleGetCart(clientId, response);
                    break;
                default:
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("Invalid action.");
                    return;
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Invalid number format: " + e.getMessage());
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("An error occurred: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private void handleGetCount(int clientId, HttpServletResponse response) throws IOException {
        int count = CartDAO.getCartItemCount(clientId);
        response.setContentType("text/plain");
        response.getWriter().write(String.valueOf(count));
    }

    private void handleGetCart(int clientId, HttpServletResponse response) throws IOException {
        try {
            Cart cart = CartDAO.getActiveCartByClientId(clientId);
            if (cart == null) {
                cart = CartDAO.createNewCart(clientId);
            }

            List<CartItem> cartItems = CartDAO.getCartItems(cart.getCartId());
            StringBuilder responseText = new StringBuilder();

            for (CartItem item : cartItems) {
                Product product = ProductDAO.getProductById(item.getProductId());
                if (product != null) {
                    String imagePath = product.getImagePath() != null ? product.getImagePath() : "";
                    System.out.println("CartServlet AJAX: " + product.getProductId() + " | " + product.getProductName() + " | " + product.getPrice() + " | " + item.getQuantity() + " | " + imagePath);
                    // Format: productId|productName|price|quantity|imagePath
                    responseText.append(product.getProductId())
                              .append("|")
                              .append(product.getProductName())
                              .append("|")
                              .append(product.getPrice())
                              .append("|")
                              .append(item.getQuantity())
                              .append("|")
                              .append(imagePath)
                              .append("\n");
                }
            }

            response.setContentType("text/plain");
            response.getWriter().write(responseText.toString());
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error fetching cart: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();
        
        try {
            String action = request.getParameter("action");
            int clientId = Integer.parseInt(request.getParameter("c_id"));
            
            if (clientId <= 0 || action == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.write("Invalid request parameters.");
                return;
            }

            int productId = Integer.parseInt(request.getParameter("product_id"));
            switch (action) {
                case "add":
                    int quantity = Integer.parseInt(request.getParameter("quantity"));
                    if (quantity <= 0) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        out.write("Invalid quantity.");
                        return;
                    }
                    CartDAO.addToCart(clientId, productId, quantity);
                    out.write("Success: Item added to cart");
                    break;
                case "remove":
                    CartDAO.removeFromCart(clientId, productId);
                    out.write("Success: Item removed from cart");
                    break;
                case "update":
                    int updatedQty = Integer.parseInt(request.getParameter("quantity"));
                    if (updatedQty <= 0) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        out.write("Invalid quantity.");
                        return;
                    }
                    CartDAO.updateCartItem(clientId, productId, updatedQty);
                    out.write("Success: Cart updated");
                    break;
                default:
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.write("Invalid action.");
                    return;
            }
            response.setStatus(HttpServletResponse.SC_OK);
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write("Invalid number format: " + e.getMessage());
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("An error occurred: " + e.getMessage());
            e.printStackTrace();
        } finally {
            out.close();
        }
    }
}

