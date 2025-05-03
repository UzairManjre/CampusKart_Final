/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package campuskart_ver02.classes;
import AbstactClasses.UserDetails;
import Exceptions.ProductNotFoundException;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author uzair
 */



public class Storage {
    private static List<UserDetails> users = new ArrayList<>();
    private static List<Product> products = new ArrayList<>();
    private static List<Transaction> transactions = new ArrayList<>();

    public static void addUser(UserDetails user) {  // Now works for both Student & Moderator
        users.add(user);
        System.out.println(user.getUsername() + " added to the system.");
    }

    // Retrieve user by username
    public static UserDetails getUserByUsername(String username) {
        for (UserDetails user : users) {
            if (user.getUsername().equals(username)) {
                return user;
            }
        }
        return null;  // Return null if user not found
    }

    // Add a product
    public static void addProduct(Product product) {
        products.add(product);
        product.addProduct();
    }

    // Retrieve a product by ID
    public static Product getProductById(int productId) {
        for (Product product : products) {
            if (product.getProductId() == (productId)) {
                return product;
            }
        }
        return null;
    }

    // Get all products
    public static List<Product> getAllProducts() {
        return new ArrayList<>(products);
    }

    // Add a transaction
    public static void addTransaction(Transaction transaction) {
        transactions.add(transaction);
    }

    // Get all transactions
    public static List<Transaction> getTransactions() {
        return new ArrayList<>(transactions);
    }

    // Get orders of a particular user
    public static List<Transaction> getMyOrders(String username) {
        List<Transaction> userOrders = new ArrayList<>();
        for (Transaction t : transactions) {
            if (t.getBuyer().getUsername().equals(username)) {
                userOrders.add(t);
            }
        }
        return userOrders;
    }

    // Get products posted by a particular user
    public static List<Product> getMyProducts(String username) {
        List<Product> userProducts = new ArrayList<>();
        for (Product p : products) {
            if (p.getSeller().getUsername().equals(username)) {
                userProducts.add(p);
            }
        }
        return userProducts;
    }

    // Hardcoded test data
    public static void initializeTestData() {
        Student student1 = new Student("Alice", "S001",  "alice@mail.com");
        Student student2 = new Student("Bob", "S002",  "bob@mail.com");
        Moderator mod1 = new Moderator("Admin1", "M001",  "admin@mail.com");

        addUser(student1);
        addUser(student2);
        addUser(mod1);

        Product product1 = new Product("Laptop", "Gaming Laptop", 70000, "Electronics", 1, student1);
        Product product2 = new Product("Books", "CS Books", 2000, "Education", 5, student2);

        addProduct(product1);
        addProduct(product2);
    }

    public static void removeProduct(int productId) {

            try {
                Product product = getProductById(productId);
                if (product == null) {
                    throw new ProductNotFoundException("Product with ID " + productId + " not found!");
                }

                // Remove product from storage
                products.remove(product);
                System.out.println("Product '" + product.getProductName() + "' has been removed from storage.");

            } catch (ProductNotFoundException e) {
                System.out.println(e.getMessage());
            } catch (Exception e) {
                System.out.println("An unexpected error occurred: " + e.getMessage());
            }
        }

    }
