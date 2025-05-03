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

import static Database.UserDAO.addUser;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ModeratorDAO  {
    public static boolean addModerator(String username, String email, String enrollmentNumber) {
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

        // Now, insert into Moderator table
        String insertModeratorQuery = "INSERT INTO Moderator (username, enrollment_number) VALUES (?, ?)";

        try (Connection conn = DatabaseConnection.initializeDB();
             PreparedStatement pstmt = conn.prepareStatement(insertModeratorQuery)) {

            pstmt.setString(1, username);
            pstmt.setString(2, enrollmentNumber);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("Error adding moderator: " + e.getMessage());
            return false;
        }
    }

}
