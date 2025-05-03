package Database;

import java.io.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

public class DatabaseConnection {
    // Updated URL without SSL and with proper settings
    private static String URL = "jdbc:mysql://localhost:4030/campuskart?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&verifyServerCertificate=false";
    private static String USER = "root";
    private static String PASSWORD = "12345";
    private static final String CONFIG_FILE = "sqlcon.txt";

    public static Connection initializeDB() {
        Connection conn = null;
        try {
            // First, try to connect without database
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("Attempting to connect to MySQL on port 4030...");
            String baseUrl = "jdbc:mysql://localhost:4030?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&verifyServerCertificate=false";
            
            // Try to connect to MySQL server
            try {
                System.out.println("Trying to connect with URL: " + baseUrl);
                conn = DriverManager.getConnection(baseUrl, USER, PASSWORD);
                System.out.println("Successfully connected to MySQL server!");
            } catch (SQLException e) {
                System.err.println("Failed to connect to MySQL server. Please check:");
                System.err.println("1. Is MySQL server running?");
                System.err.println("2. Is the port number correct? (4030)");
                System.err.println("3. Are the credentials correct?");
                System.err.println("4. Is SSL disabled in MySQL configuration?");
                System.err.println("Error details: " + e.getMessage());
                e.printStackTrace();
                return null;
            }
            
            // Create database if it doesn't exist
            try (Statement stmt = conn.createStatement()) {
                System.out.println("Attempting to create database 'campuskart'...");
                stmt.executeUpdate("CREATE DATABASE IF NOT EXISTS campuskart");
                System.out.println("Database 'campuskart' created or already exists");
            } catch (SQLException e) {
                System.err.println("Failed to create database. Error: " + e.getMessage());
                e.printStackTrace();
                return null;
            }
            
            // Close initial connection
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing initial connection: " + e.getMessage());
            }
            
            // Now connect to the specific database
            System.out.println("Attempting to connect to 'campuskart' database...");
            try {
                System.out.println("Trying to connect with URL: " + URL);
                conn = DriverManager.getConnection(URL, USER, PASSWORD);
                System.out.println("Successfully connected to 'campuskart' database!");
            } catch (SQLException e) {
                System.err.println("Failed to connect to 'campuskart' database. Error: " + e.getMessage());
                e.printStackTrace();
                return null;
            }
            
            // Run database setup
            System.out.println("Setting up database tables...");
            try {
                DatabaseSetup.setupDatabase(conn);
                System.out.println("Database setup completed successfully!");
            } catch (SQLException e) {
                System.err.println("Failed to setup database tables. Error: " + e.getMessage());
                e.printStackTrace();
                return null;
            }
            
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found! " + e.getMessage());
            System.err.println("Please add MySQL JDBC driver to your project's libraries.");
            e.printStackTrace();
        }
        return conn;
    }

    public static void setURL(String URL) {
        DatabaseConnection.URL = URL;
    }

    public static void setUSER(String USER) {
        DatabaseConnection.USER = USER;
    }

    public static void setPASSWORD(String PASSWORD) {
        DatabaseConnection.PASSWORD = PASSWORD;
    }

    public static String getURL() {
        return URL;
    }

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC Driver not found", e);
        }
    }

    public static Connection getConnectionWithoutDB() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:4030?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&verifyServerCertificate=false";
            return DriverManager.getConnection(url, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC Driver not found", e);
        }
    }
}
