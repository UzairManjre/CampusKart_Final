package servlets;

import AbstactClasses.UserDetails;
import Database.ProductDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/RemoveProductServlet")
public class RemoveProductServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String productIdStr = request.getParameter("productId");
        try {
            int productId = Integer.parseInt(productIdStr);
            ProductDAO.deleteProduct(productId);
            HttpSession session = request.getSession();
            UserDetails user = (UserDetails) session.getAttribute("user");
            if (user != null && "Moderator".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect("mod-products.jsp?success=1");
            } else {
                response.sendRedirect("profile.jsp?success=1");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("profile.jsp?error=remove");
        }
    }
} 