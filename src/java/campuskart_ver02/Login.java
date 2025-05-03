package campuskart_ver02;

import AbstactClasses.UserDetails;
import Database.DatabaseSetup;
import Database.StudentDAO;
import Database.UserDAO;
import Database.CartDAO;
import campuskart_ver02.classes.Cart;
import java.util.logging.Level;
import java.util.logging.Logger;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/Login")
public class Login extends HttpServlet {
    private static final Logger logger = Logger.getLogger(Login.class.getName());
    private static boolean isDatabaseInitialized = false;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Initialize database only once
            if (!isDatabaseInitialized) {
                System.out.println("Initializing database for the first time...");
                DatabaseSetup.main(new String[]{});
                isDatabaseInitialized = true;
                System.out.println("Database initialization completed!");
            }
            
            // Get username from request
            String username = request.getParameter("username");
            System.out.println("Login attempt for username: " + username);
            
            if (username == null || username.trim().isEmpty()) {
                System.out.println("Empty username provided");
                response.sendRedirect("login.jsp?error=2");
                return;
            }

            // Attempt to login user
            System.out.println("Attempting to retrieve user details...");
            UserDetails user = UserDAO.loginUser(username);
            
            if (user != null) {
                System.out.println("User found! Username: " + user.getUsername() + 
                                 ", Role: " + user.getRole() + 
                                 ", Email: " + user.getEmail());
                // Create session and redirect to index.jsp
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                // Ensure user has an active cart
                int clientId = StudentDAO.getStudentByUsername(user.getUsername()).getClientId();
                Cart cart = Database.CartDAO.getActiveCart(clientId);
                if (cart == null) {
                    cart = Database.CartDAO.createNewCart(clientId);
                }
                session.setAttribute("cart", cart);
                System.out.println("Session created, redirecting to index.jsp...");
                response.sendRedirect("index.jsp");
            } else {
                System.out.println("User not found in database");
                response.sendRedirect("login.jsp?error=1");
            }
        } catch (Exception e) {
            System.out.println("Error during login process: " + e.getMessage());
            logger.log(Level.SEVERE, "Error during login process: ", e);
            response.sendRedirect("login.jsp?error=3");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }
}
