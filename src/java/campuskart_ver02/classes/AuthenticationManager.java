/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package campuskart_ver02.classes;

import AbstactClasses.UserDetails;

/**
 *
 * @author uzair
 */
public class AuthenticationManager {
    public static UserDetails login(String username, String password) {
        UserDetails user = Storage.getUserByUsername(username);
        if (user != null ) {
            System.out.println("Login successful: " + user.getUsername());
            return user;
        } else {
            System.out.println("Invalid credentials.");
            return null;
        }
    }
}
