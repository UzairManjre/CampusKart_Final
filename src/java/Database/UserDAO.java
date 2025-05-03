package Database;

import AbstactClasses.UserDetails;
import campuskart_ver02.classes.Moderator;
import campuskart_ver02.classes.Student;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {

    // Method to add a new user (no password)
    public static boolean addUser(String username, String email) {
        String insertUserQuery = "INSERT INTO User (username, email) VALUES (?, ?)";

        try (Connection conn = DatabaseConnection.initializeDB();
             PreparedStatement pstmt = conn.prepareStatement(insertUserQuery, PreparedStatement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, username);
            pstmt.setString(2, email);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    int userId = rs.getInt(1);
                    // Store the user_id in the UserDetails object if needed
                    return true;
                }
            }
            return false;

        } catch (SQLException e) {
            System.err.println("Error adding user: " + e.getMessage());
            return false;
        }
    }

    // Method to login a user (no password check)
    public static UserDetails loginUser(String username) {
        String userQuery = "SELECT user_id, username, email FROM User WHERE username = ?";

        try (Connection conn = DatabaseConnection.initializeDB();
             PreparedStatement pstmt = conn.prepareStatement(userQuery)) {

            pstmt.setString(1, username);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                int userId = rs.getInt("user_id");
                String enrollmentNumber = null;

                // Check if the user is a Student or Moderator
                if (isStudent(username)) {
                    enrollmentNumber = getEnrollmentNumber(username, "Client");
                    String email = getEmail(username);
                    Student student = new Student(username, enrollmentNumber, email);
                    student.setUserId(userId);
                    return student;
                } else if (isModerator(username)) {
                    enrollmentNumber = getEnrollmentNumber(username, "Moderator");
                    String email = getEmail(username);
                    Moderator moderator = new Moderator(username, enrollmentNumber, email);
                    moderator.setUserId(userId);
                    return moderator;
                } else {
                    System.out.println("User found, but role not recognized.");
                }
            }
        } catch (SQLException e) {
            System.err.println("Login error: " + e.getMessage());
        }
        return null; // Login failed
    }

    // Helper method to get enrollment number
    private static String getEnrollmentNumber(String username, String tableName) {
        String query = "SELECT enrollment_number FROM " + tableName + " WHERE username = ?";

        try (Connection conn = DatabaseConnection.initializeDB();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getString("enrollment_number");
            }
        } catch (SQLException e) {
            System.err.println("Error fetching enrollment number: " + e.getMessage());
        }
        return null;
    }

    private static String getEmail(String username) {
        String query = "SELECT email FROM User WHERE username = ?";

        try (Connection conn = DatabaseConnection.initializeDB();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getString("email");
            }
        } catch (SQLException e) {
            System.err.println("Error fetching email: " + e.getMessage());
        }
        return null;
    }

    // Check if the username belongs to a student
    private static boolean isStudent(String username) {
        String query = "SELECT username FROM client WHERE username = ?";
        return checkRole(username, query);
    }

    // Check if the username belongs to a moderator
    private static boolean isModerator(String username) {
        String query = "SELECT username FROM Moderator WHERE username = ?";
        return checkRole(username, query);
    }

    // Helper method to check role in database
    private static boolean checkRole(String username, String query) {
        try (Connection conn = DatabaseConnection.initializeDB();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();
            return rs.next(); // Returns true if user exists in that table
        } catch (SQLException e) {
            System.err.println("Role check error: " + e.getMessage());
            return false;
        }
    }
}
