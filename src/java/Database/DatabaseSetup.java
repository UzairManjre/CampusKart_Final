package Database;

import static Database.DatabaseConnection.*;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DatabaseSetup {
    public static void setupDatabase(Connection conn) throws SQLException {
        try (Statement stmt = conn.createStatement()) {
            // Create Tables
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS User ("
                    + "user_id INT AUTO_INCREMENT PRIMARY KEY, "
                    + "username VARCHAR(50) UNIQUE NOT NULL, "
                    + "email VARCHAR(100) UNIQUE NOT NULL)");

            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS Client ("
                    + "c_id INT AUTO_INCREMENT PRIMARY KEY, "
                    + "username VARCHAR(50) UNIQUE NOT NULL, "
                    + "enrollment_number VARCHAR(20) UNIQUE NOT NULL, "
                    + "FOREIGN KEY (username) REFERENCES User(username) ON DELETE CASCADE)");

            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS Moderator ("
                    + "m_id INT AUTO_INCREMENT PRIMARY KEY, "
                    + "username VARCHAR(50) UNIQUE NOT NULL, "
                    + "enrollment_number VARCHAR(20) UNIQUE NOT NULL, "
                    + "FOREIGN KEY (username) REFERENCES User(username) ON DELETE CASCADE)");

            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS Products ("
                    + "pr_id INT AUTO_INCREMENT PRIMARY KEY, "
                    + "pname VARCHAR(100) NOT NULL, "
                    + "pdesc VARCHAR(500), "
                    + "p_price DECIMAL(10,2) NOT NULL, "
                    + "qty INT NOT NULL, "
                    + "category VARCHAR(50), "
                    + "status ENUM('Available', 'Sold') NOT NULL DEFAULT 'Available', "
                    + "p_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "
                    + "image_path VARCHAR(255), "  
                    + "s_id INT NOT NULL, "
                    + "FOREIGN KEY (s_id) REFERENCES Client(c_id) ON DELETE CASCADE)");

            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS Transactions ("
                    + "t_id INT AUTO_INCREMENT PRIMARY KEY, "
                    + "t_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "
                    + "p_id INT NOT NULL, "
                    + "buyer_id INT NOT NULL, "
                    + "seller_id INT NOT NULL, "
                    + "FOREIGN KEY (p_id) REFERENCES Products(pr_id) ON DELETE CASCADE, "
                    + "FOREIGN KEY (buyer_id) REFERENCES Client(c_id) ON DELETE CASCADE, "
                    + "FOREIGN KEY (seller_id) REFERENCES Client(c_id) ON DELETE CASCADE)");

            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS Payment ("
                    + "pay_id INT AUTO_INCREMENT PRIMARY KEY, "
                    + "t_id INT UNIQUE NOT NULL, "
                    + "amount DECIMAL(10,2) NOT NULL, "
                    + "payment_status ENUM('Completed', 'Pending', 'Failed') NOT NULL DEFAULT 'Pending', "
                    + "payment_method ENUM('Credit Card', 'UPI', 'Cash') NOT NULL, "
                    + "pay_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "
                    + "FOREIGN KEY (t_id) REFERENCES Transactions(t_id) ON DELETE CASCADE)");

            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS Reviews ("
                    + "r_id INT AUTO_INCREMENT PRIMARY KEY, "
                    + "u_id INT NOT NULL, "
                    + "p_id INT NOT NULL, "
                    + "rating TINYINT CHECK (rating BETWEEN 1 AND 5), "
                    + "comment VARCHAR(500), "
                    + "timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "
                    + "FOREIGN KEY (u_id) REFERENCES Client(c_id) ON DELETE CASCADE, "
                    + "FOREIGN KEY (p_id) REFERENCES Products(pr_id) ON DELETE CASCADE)");

            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS Favourites ("
                    + "c_id INT NOT NULL, "
                    + "product_id INT NOT NULL, "
                    + "PRIMARY KEY (c_id, product_id), "
                    + "FOREIGN KEY (c_id) REFERENCES Client(c_id) ON DELETE CASCADE, "
                    + "FOREIGN KEY (product_id) REFERENCES Products(pr_id) ON DELETE CASCADE)");

            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS Carts ("
                    + "cart_id INT AUTO_INCREMENT PRIMARY KEY, "
                    + "c_id INT NOT NULL, "
                    + "status ENUM('ACTIVE', 'CHECKED_OUT', 'ABANDONED') NOT NULL DEFAULT 'ACTIVE', "
                    + "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "
                    + "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, "
                    + "FOREIGN KEY (c_id) REFERENCES Client(c_id) ON DELETE CASCADE)");

            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS Cart_Items ("
                    + "cart_id INT NOT NULL, "
                    + "product_id INT NOT NULL, "
                    + "quantity INT NOT NULL DEFAULT 1, "
                    + "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "
                    + "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, "
                    + "PRIMARY KEY (cart_id, product_id), "
                    + "FOREIGN KEY (cart_id) REFERENCES Carts(cart_id) ON DELETE CASCADE, "
                    + "FOREIGN KEY (product_id) REFERENCES Products(pr_id) ON DELETE CASCADE)");

            System.out.println("All tables created successfully!");

            // Insert default data
            insertDefaultUsers(stmt);
            insertDefaultClients(stmt);
            insertDefaultProducts(stmt);
        }
    }

    public static void main(String[] args) {
        try (Connection conn = DatabaseConnection.initializeDB()) {
            if (conn != null) {
                System.out.println("Database setup completed successfully!");
            }
        } catch (SQLException e) {
            System.err.println("Error during database setup: " + e.getMessage());
        }
    }

    private static void insertDefaultUsers(Statement stmt) throws SQLException {
        String checkUserQuery = "SELECT COUNT(*) FROM User WHERE username IN ('Uzair', 'shlok', 'admin1')";
        ResultSet rs = stmt.executeQuery(checkUserQuery);
        if (rs.next() && rs.getInt(1) == 0) {
            stmt.executeUpdate("INSERT INTO User (username, email) VALUES "
                    + "('Uzair', 'uzair@example.com'), "
                    + "('shlok', 'shlok@example.com')");

            ModeratorDAO.addModerator("admin1","admin@example.com","12345567");
            System.out.println("Default users inserted successfully!");
        } else {
            System.out.println("Default users already exist. Skipping insertion.");
        }
    }

    private static void insertDefaultClients(Statement stmt) throws SQLException {
        String checkClientQuery = "SELECT COUNT(*) FROM Client WHERE username IN ('Uzair', 'shlok')";
        ResultSet rs = stmt.executeQuery(checkClientQuery);
        if (rs.next() && rs.getInt(1) == 0) {
            stmt.executeUpdate("INSERT INTO Client (username, enrollment_number) VALUES "
                    + "('Uzair', '1001'), "
                    + "('shlok', '1002')");
            System.out.println("Default clients inserted successfully!");
        } else {
            System.out.println("Default clients already exist. Skipping insertion.");
        }
    }

    private static void insertDefaultProducts(Statement stmt) throws SQLException {
        String checkClientCountQuery = "SELECT COUNT(*) FROM Client";
        ResultSet rs = stmt.executeQuery(checkClientCountQuery);
        if (rs.next() && rs.getInt(1) == 0) {
            System.out.println("No clients found. Skipping product insertion.");
            return;
        }

        String getFirstClientIdQuery = "SELECT c_id FROM Client ORDER BY c_id LIMIT 1";
        rs = stmt.executeQuery(getFirstClientIdQuery);
        int clientId = rs.next() ? rs.getInt(1) : -1;

        if (clientId == -1) {
            System.out.println("Could not determine a valid client ID. Skipping product insertion.");
            return;
        }

        String checkProductQuery = "SELECT COUNT(*) FROM Products";
        rs = stmt.executeQuery(checkProductQuery);
        if (rs.next() && rs.getInt(1) == 0) {
            stmt.executeUpdate("INSERT INTO Products (pname, pdesc, p_price, qty, category, status, s_id, image_path) VALUES "
                    + "('Laptop', 'Dell XPS 13 - 16GB RAM, 512GB SSD', 12000.00, 2, 'Electronics', 'Available', " + clientId + ", 'uploaded_images/laptop.jpg'), "
                    + "('Smartphone', 'iPhone 13 - 128GB', 9990.99, 5, 'Electronics', 'Available', " + clientId + ", 'uploaded_images/smartphone.jpg'), "
                    + "('Backpack', 'Nike Sport Backpack', 559.99, 10, 'Accessories', 'Available', " + clientId + ", 'uploaded_images/backpack.jpg'), "
                    + "('Bookshelf', 'Wooden bookshelf with 5 shelves', 2300.00, 3, 'Furniture', 'Available', " + clientId + ", 'uploaded_images/bookshelf.jpg'), "
                    + "('Headphones', 'Sony WH-1000XM4 Noise Cancelling', 1799.00, 4, 'Electronics', 'Available', " + clientId + ", 'uploaded_images/headphones.jpg'), "
                    + "('Study Table', 'Compact study table for small rooms', 1500.00, 2, 'Furniture', 'Available', " + clientId + ", 'uploaded_images/study_table.jpg'), "
                    + "('Cycle', 'Hercules gear cycle, 21-speed', 4999.00, 1, 'Sports', 'Available', " + clientId + ", 'uploaded_images/cycle.jpg'), "
                    + "('Power Bank', 'Mi 10000mAh fast charging', 799.00, 8, 'Electronics', 'Available', " + clientId + ", 'uploaded_images/powerbank.jpg'), "
                    + "('T-shirt Pack', 'Pack of 3 casual cotton T-shirts', 699.00, 6, 'Clothing', 'Available', " + clientId + ", 'uploaded_images/tshirt.jpg'), "
                    + "('Fan', 'Bajaj table fan, 3-speed', 1100.00, 3, 'Appliances', 'Available', " + clientId + ", 'uploaded_images/fan.jpg'), "
                    + "('Desk Lamp', 'LED study lamp with brightness control', 499.00, 7, 'Appliances', 'Available', " + clientId + ", 'uploaded_images/lamp.jpg'), "
                    + "('Pen Set', 'Premium ball pens, pack of 10', 199.00, 20, 'Stationery', 'Available', " + clientId + ", 'uploaded_images/pens.jpg'), "
                    + "('Water Bottle', 'Steel bottle - 1 litre', 349.00, 6, 'Accessories', 'Available', " + clientId + ", 'uploaded_images/bottle.jpg'), "
                    + "('Blanket', 'Double-bed comfort blanket', 1399.00, 2, 'Home', 'Available', " + clientId + ", 'uploaded_images/blanket.jpg'), "
                    + "('Desk Chair', 'Ergonomic office chair with wheels', 2899.00, 3, 'Furniture', 'Available', " + clientId + ", 'uploaded_images/chair.jpg'), "
                    + "('Router', 'TP-Link WiFi Router - Dual Band', 1699.00, 4, 'Electronics', 'Available', " + clientId + ", 'uploaded_images/router.jpg'), "
                    + "('Shoes', 'Adidas running shoes - size 9', 2499.00, 2, 'Clothing', 'Available', " + clientId + ", 'uploaded_images/shoes.jpg'), "
                    + "('Hoodie', 'Unisex fleece hoodie - black', 1099.00, 5, 'Clothing', 'Available', " + clientId + ", 'uploaded_images/hoodie.jpg'), "
                    + "('USB Drive', 'Sandisk 64GB USB 3.1 pendrive', 499.00, 10, 'Electronics', 'Available', " + clientId + ", 'uploaded_images/usb.jpg')");
            System.out.println("Default products inserted successfully!");
        } else {
            System.out.println("Default products already exist. Skipping insertion.");
        }
    }
}



