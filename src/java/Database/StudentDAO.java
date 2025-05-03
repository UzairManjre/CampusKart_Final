/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Database;

/**
 *
 * @author uzair
 */



import campuskart_ver02.classes.Student;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class StudentDAO extends UserDAO {

    // Method to add a new Student (no password)
    public static boolean addStudent(String username, String email, String enrollmentNumber) {
        // First, add the user
        int userId = -1;
        try (Connection conn = DatabaseConnection.initializeDB();
             PreparedStatement pstmt = conn.prepareStatement("INSERT INTO User (username, email) VALUES (?, ?)", PreparedStatement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, username);
            pstmt.setString(2, email);
            pstmt.executeUpdate();
            
            ResultSet rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                userId = rs.getInt(1);
            } else {
                System.err.println("Failed to get generated user_id");
                return false;
            }
        } catch (SQLException e) {
            System.err.println("Error adding user: " + e.getMessage());
            return false;
        }

        // Now, insert into Client (Student) table
        String insertStudentQuery = "INSERT INTO Client (username, enrollment_number) VALUES (?, ?)";

        try (Connection conn = DatabaseConnection.initializeDB();
             PreparedStatement pstmt = conn.prepareStatement(insertStudentQuery)) {

            pstmt.setString(1, username);
            pstmt.setString(2, enrollmentNumber);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error adding student: " + e.getMessage());
            return false;
        }
    }

    // Method to get Student by username (no password needed)
    public static Student getStudentByUsername(String username) {
        String query = "SELECT c_id, User.username, email, enrollment_number FROM Client JOIN User ON Client.username = User.username WHERE User.username = ?";

        try (Connection conn = DatabaseConnection.initializeDB();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return new Student(
                        rs.getInt("c_id"),
                        rs.getString("username"),
                        rs.getString("enrollment_number"),
                        rs.getString("email")
                );
            }
        } catch (SQLException e) {
            System.err.println("Error fetching student: " + e.getMessage());
        }
        return null;
    }

    // Method to get Student by ID (no password needed)
    public static Student getStudentById(int clientId) {
        String query = "SELECT c_id, User.username, email, enrollment_number FROM Client JOIN User ON Client.username = User.username WHERE c_id = ?";

        try (Connection conn = DatabaseConnection.initializeDB();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, clientId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return new Student(
                        rs.getInt("c_id"),
                        rs.getString("username"),
                        rs.getString("enrollment_number"),
                        rs.getString("email")
                );
            } else {
                System.out.println("No student found with ID: " + clientId);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching student by ID: " + e.getMessage());
        }
        return null;
    }
}
