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

public interface ProductAction {
    void addProduct();
    void updateProduct(String newDescription, double newPrice, int newQuantity);
    void deleteProduct();
    void buyProduct();
    void sellProduct();

    int getProductId();
}