package servlets;

import Database.ModeratorDAO;
import Database.StudentDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username").trim();
        String email = request.getParameter("email").trim();
        String enrollment = request.getParameter("enrollment").trim();
        String role = request.getParameter("role");

        // Validate input
        if (username.isEmpty() || email.isEmpty() || enrollment.isEmpty()) {
            response.sendRedirect("registration.jsp?error=Please fill in all fields");
            return;
        }

        if (!isValidEmail(email)) {
            response.sendRedirect("registration.jsp?error=Please enter a valid email address");
            return;
        }

        boolean success = false;
        if ("Moderator".equals(role)) {
            success = ModeratorDAO.addModerator(username, email, enrollment);
        } else {
            success = StudentDAO.addStudent(username, email, enrollment);
        }

        if (success) {
            response.sendRedirect("registration.jsp?success=true");
        } else {
            response.sendRedirect("registration.jsp?error=Registration failed. Username may already exist.");
        }
    }

    private boolean isValidEmail(String email) {
        return email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");
    }
} 