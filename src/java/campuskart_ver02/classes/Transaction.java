/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package campuskart_ver02.classes;

import AbstactClasses.UserDetails;
import Exceptions.UnauthorizedActionException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author uzair
 */
import AbstactClasses.UserDetails;
import Exceptions.UnauthorizedActionException;
import java.sql.Timestamp;

public class Transaction {
    private int t_id;
    private Timestamp t_date;
    private Student buyer;
    private Student seller;
    private Product product;
    private static List<Transaction> transactionList = new ArrayList<>();
    // Constructor for new transactions (before DB insertion)
    public Transaction(Student buyer, Student seller, Product product) {
        this.buyer = buyer;
        this.seller = seller;
        this.product = product;
    }

    // Constructor for full initialization (from DB)
    public Transaction(int t_id, Timestamp t_date, Student buyer,
                       Student seller, Product product) {
        this.t_id = t_id;
        this.t_date = t_date;
        this.buyer = buyer;
        this.seller = seller;
        this.product = product;
    }

    // Getters
    public int getTransactionId() { return t_id; }
    public Timestamp getTransactionDate() { return t_date; }
    public Student getBuyer() { return buyer; }
    public Student getSeller() { return seller; }
    public Product getProduct() { return product; }

    // Setters (only for fields that might need modification)
    public void setTransactionId(int t_id) { this.t_id = t_id; }
    public void setTransactionDate(Timestamp t_date) { this.t_date = t_date; }

    public static List<Transaction> getAllTransactions(UserDetails user) throws UnauthorizedActionException {
        if (user instanceof Moderator) {  // Now valid check
            return new ArrayList<>(transactionList);
        }
        throw new UnauthorizedActionException("Unauthorized action! You do not have the required permissions to perform this action.");
    }


    @Override
    public String toString() {
        return "Transaction{" +
                "t_id=" + t_id +
                ", t_date=" + t_date +
                ", buyer=" + buyer.getUsername() +
                ", seller=" + seller.getUsername() +
                ", product=" + product.getProductName() +
                '}';
    }

}