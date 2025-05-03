/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package campuskart_ver02.classes;

/**
 *
 * @author uzair
 */


public class Favourite {
    private int clientId;
    private int productId;

    // Constructor
    public Favourite(int clientId, int productId) {
        this.clientId = clientId;
        this.productId = productId;
    }

    // Getters
    public int getClientId() {
        return clientId;
    }

    public int getProductId() {
        return productId;
    }

    // Setters
    public void setClientId(int clientId) {
        this.clientId = clientId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    // ToString for debugging
    @Override
    public String toString() {
        return "Favourites{" +
                "clientId=" + clientId +
                ", productId=" + productId +
                '}';
    }
}
