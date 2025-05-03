/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package AbstactClasses;

/**
 *
 * @author uzair
 */
public abstract class UserDetails {
    protected String username;
    protected String enrollmentNumber;
    protected String email;
    protected String role; // Student or Mod
    protected int userId;

    public UserDetails(String username, String enrollmentNumber, String email, String role) {
        this.username = username;
        this.enrollmentNumber = enrollmentNumber;
        this.email = email;
        this.role = role;
    }

    public abstract void displayUserDetails();

    public String getUsername() {
        return username;
    }

    public String getEmail() {
        return email;
    }

    public String getEnrollmentNumber() {
        return enrollmentNumber;
    }

    public String getRole() {
        return role;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }
}

