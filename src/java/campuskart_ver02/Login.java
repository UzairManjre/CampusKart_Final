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
                response.sendRedirect("login.html?error=2");
                return;
            }

            // Attempt to login user
            System.out.println("Attempting to retrieve user details...");
            UserDetails user = UserDAO.loginUser(username);
            
            if (user != null) {
                System.out.println("User found! Username: " + user.getUsername() + 
                                 ", Role: " + user.getRole() + 
                                 ", Email: " + user.getEmail());
                
                // Create session
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                
                // Handle role-based redirection
                String role = user.getRole();
                if (role != null) {
                    if (role.equalsIgnoreCase("Student")) {
                        try {
                            // Only for students: ensure user has an active cart
                            int clientId = StudentDAO.getStudentByUsername(user.getUsername()).getClientId();
                            Cart cart = CartDAO.getActiveCart(clientId);
                            if (cart == null) {
                                cart = CartDAO.createNewCart(clientId);
                            }
                            session.setAttribute("cart", cart);
                            System.out.println("Session created, redirecting to index.jsp...");
                            response.sendRedirect("index.jsp");
                        } catch (Exception e) {
                            logger.log(Level.SEVERE, "Error setting up student cart: ", e);
                            response.sendRedirect("login.html?error=cart");
                        }
                    } else if (role.equalsIgnoreCase("Moderator")) {
                        // For moderators: no cart logic needed
                        System.out.println("Session created, redirecting to moddash.jsp...");
                        response.sendRedirect("moddash.jsp");
                    } else {
                        // Unknown role
                        System.out.println("Unknown role: " + role);
                        response.sendRedirect("login.html?error=role");
                    }
                } else {
                    System.out.println("User role is null");
                    response.sendRedirect("login.html?error=role");
                }
            } else {
                System.out.println("User not found in database");
                response.sendRedirect("login.html?error=1");
            }
        } catch (Exception e) {
            System.out.println("Error during login process: " + e.getMessage());
            logger.log(Level.SEVERE, "Error during login process: ", e);
            response.sendRedirect("login.html?error=3");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("login.html");
    }
}
