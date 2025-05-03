/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Interfaces;

/**
 *
 * @author uzair
 */
public interface UserAction {
    void register();
    void login();
    void logout();
    void editProfile(); // Optional, can be used to update user details
}