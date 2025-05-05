package campuskart_ver02.servlets;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/AuthServlet")
public class AuthServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("verifySession".equals(action)) {
            verifySession(request, response);
        }
    }

    private void verifySession(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        String jsonResponse;
        Object userObj = (session != null) ? session.getAttribute("user") : null;
        if (userObj != null) {
            // Try to get clientId from the user object
            try {
                // Use reflection to getUsername (since UserDetails is abstract)
                String username = (String) userObj.getClass().getMethod("getUsername").invoke(userObj);
                // Get clientId using StudentDAO
                int clientId = Database.StudentDAO.getStudentByUsername(username).getClientId();
                jsonResponse = "{\"authenticated\":true,\"userId\":\"" + clientId + "\"}";
            } catch (Exception e) {
                jsonResponse = "{\"authenticated\":false}";
            }
        } else {
            jsonResponse = "{\"authenticated\":false}";
        }
        response.setContentType("application/json");
        response.getWriter().write(jsonResponse);
    }
} 