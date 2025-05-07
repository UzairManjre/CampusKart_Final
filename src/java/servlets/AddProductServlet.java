package servlets;

import Database.ProductDAO;
import campuskart_ver02.classes.Product;
import campuskart_ver02.classes.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

@WebServlet("/AddProductServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class AddProductServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("[DEBUG] AddProductServlet doPost called!");
        // Get current user from session
        HttpSession session = request.getSession(false);
        Student currentUser = (Student) session.getAttribute("user");
        System.out.println("[DEBUG] Current user (from session): " + currentUser);
        if (currentUser == null) {
            System.out.println("[DEBUG] No user in session. Redirecting to login.jsp");
            response.sendRedirect("login.jsp");
            return;
        }
        // Always get the latest Student object from DB
        currentUser = Database.StudentDAO.getStudentByUsername(currentUser.getUsername());
        System.out.println("[DEBUG] Current user (from DB): " + currentUser + ", clientId: " + (currentUser != null ? currentUser.getClientId() : "null"));

        // Get form fields
        String name = request.getParameter("productName");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String quantityStr = request.getParameter("quantity");
        String category = request.getParameter("category");
        System.out.println("[DEBUG] Form fields: name=" + name + ", desc=" + description + ", price=" + priceStr + ", qty=" + quantityStr + ", cat=" + category);

        // Validate fields
        if (name == null || name.trim().isEmpty() ||
            description == null || description.trim().isEmpty() ||
            priceStr == null || priceStr.trim().isEmpty() ||
            quantityStr == null || quantityStr.trim().isEmpty() ||
            category == null || category.trim().isEmpty()) {
            System.out.println("[DEBUG] Validation failed: missing field");
            response.sendRedirect("sell-product.jsp?error=1");
            return;
        }

        double price = 0;
        int quantity = 0;
        try {
            price = Double.parseDouble(priceStr);
            if (price <= 0) throw new NumberFormatException();
        } catch (NumberFormatException e) {
            System.out.println("[DEBUG] Invalid price: " + priceStr);
            response.sendRedirect("sell-product.jsp?error=1");
            return;
        }
        try {
            quantity = Integer.parseInt(quantityStr);
            if (quantity <= 0) throw new NumberFormatException();
        } catch (NumberFormatException e) {
            System.out.println("[DEBUG] Invalid quantity: " + quantityStr);
            response.sendRedirect("sell-product.jsp?error=1");
            return;
        }

        // Handle image upload
        Part imagePart = null;
        String imagePath = null;
        try {
            imagePart = request.getPart("productImages");
            if (imagePart != null && imagePart.getSize() > 0) {
                String fileName = new File(imagePart.getSubmittedFileName()).getName();
                String uploadDir = getServletContext().getRealPath("") + File.separator + "uploaded_images";
                File dir = new File(uploadDir);
                if (!dir.exists()) dir.mkdirs();
                File file = new File(dir, fileName);
                Files.copy(imagePart.getInputStream(), file.toPath(), StandardCopyOption.REPLACE_EXISTING);
                imagePath = "uploaded_images/" + fileName;
                System.out.println("[DEBUG] Image uploaded to: " + imagePath);
            } else {
                System.out.println("[DEBUG] No image uploaded");
                response.sendRedirect("sell-product.jsp?error=1");
                return;
            }
        } catch (Exception e) {
            System.out.println("[DEBUG] Exception during image upload: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("sell-product.jsp?error=1");
            return;
        }

        // Debug prints for troubleshooting
        System.out.println("Product Name: " + name);
        System.out.println("Description: " + description);
        System.out.println("Price: " + priceStr);
        System.out.println("Quantity: " + quantityStr);
        System.out.println("Category: " + category);
        System.out.println("Seller: " + currentUser);
        System.out.println("Seller ID: " + (currentUser != null ? currentUser.getClientId() : "null"));
        System.out.println("Image path: " + imagePath);

        // Create and save product
        System.out.println("[DEBUG] Creating Product object");
        Product product = new Product(name, description, price, category, quantity, currentUser);
        product.setImagePath(imagePath);

        System.out.println("[DEBUG] Calling ProductDAO.addProduct");
        boolean success = false;
        try {
            success = ProductDAO.addProduct(product);
            System.out.println("[DEBUG] ProductDAO.addProduct returned: " + success);
        } catch (Exception e) {
            System.out.println("[DEBUG] Exception in ProductDAO.addProduct: " + e.getMessage());
            e.printStackTrace();
        }
        if (success) {
            System.out.println("[DEBUG] Product added successfully. Redirecting with success.");
            response.sendRedirect("sell-product.jsp?success=1");
        } else {
            System.out.println("[DEBUG] Product add failed. Redirecting with error.");
            response.sendRedirect("sell-product.jsp?error=1");
        }
    }
} 