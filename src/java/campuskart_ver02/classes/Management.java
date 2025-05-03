/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package campuskart_ver02.classes;

import AbstactClasses.UserDetails;
import java.util.Scanner;

/**
 *
 * @author uzair
 */

public class Management {
    private static Scanner scanner = new Scanner(System.in);
    private static UserDetails loggedInUser = null;  // Track currently logged-in user

    // User login
    public static void login() {
        System.out.print("Enter username: ");
        String username = scanner.nextLine();
        System.out.print("Enter password: ");
        String password = scanner.nextLine();

        UserDetails user = Storage.getUserByUsername(username);
        if (user != null) {
            loggedInUser = user;
            System.out.println("Login successful! Welcome, " + loggedInUser.getUsername());
        } else {
            System.out.println("Invalid username or password.");
        }
    }

    // User logout
    public static void logout() {
        if (loggedInUser != null) {
            System.out.println(loggedInUser.getUsername() + " logged out.");
            loggedInUser = null;
        } else {
            System.out.println("No user is currently logged in.");
        }
    }

    // Register new user
    public static void registerUser() {
        System.out.print("Enter username: ");
        String username = scanner.nextLine();
        System.out.print("Enter enrollment number: ");
        String enrollmentNumber = scanner.nextLine();
        System.out.print("Enter email: ");
        String email = scanner.nextLine();
        System.out.print("Enter password: ");
        String password = scanner.nextLine();

        UserDetails newUser = new Student(username, enrollmentNumber, email);
        Storage.addUser(newUser);
        System.out.println("Registration successful! You can now log in.");
    }

    // Add a new product
    public static void addProduct() {
        if (loggedInUser instanceof Student) {
            System.out.print("Enter product name: ");
            String productName = scanner.nextLine();
            System.out.print("Enter description: ");
            String description = scanner.nextLine();
            System.out.print("Enter price: ");
            double price = scanner.nextDouble();
            System.out.print("Enter category: ");
            scanner.nextLine(); // Consume newline
            String category = scanner.nextLine();
            System.out.print("Enter quantity: ");
            int quantity = scanner.nextInt();

            Product newProduct = new Product(productName, description, price, category, quantity, (Student) loggedInUser);
            Storage.addProduct(newProduct);
            System.out.println("Product added successfully!");
        } else {
            System.out.println("Only students can add products.");
        }
    }

    // View all available products
    public static void viewProducts() {
        for (Product p : Storage.getAllProducts()) {
            System.out.println(p);
        }
    }

    // Purchase a product
    public static void purchaseProduct() {
        if (loggedInUser instanceof Student) {
            System.out.print("Enter product ID to buy: ");
            int productId = scanner.nextInt();
            scanner.nextLine(); // Consume newline

            Product product = Storage.getProductById(productId);
            if (product != null) {
                Student seller = product.getSeller(); // Fetching the seller from the product

                if (seller.equals(loggedInUser)) {
                    System.out.println("You cannot buy your own product.");
                    return;
                }

                Transaction newTransaction = new Transaction((Student) loggedInUser, seller, product);
                Storage.addTransaction(newTransaction);
                System.out.println("Purchase successful!");
            } else {
                System.out.println("Product not found.");
            }
        } else {
            System.out.println("Only students can buy products.");
        }
    }


    // View user’s own orders
    public static void viewMyOrders() {
        if (loggedInUser instanceof Student) {
            for (Transaction t : Storage.getMyOrders(loggedInUser.getUsername())) {
                System.out.println(t);
            }
        } else {
            System.out.println("Only students can view their orders.");
        }
    }

    // Moderator: View all transactions
    public static void viewAllTransactions() {
        if (loggedInUser instanceof Moderator) {
            for (Transaction t : Storage.getTransactions()) {
                System.out.println(t);
            }
        } else {
            System.out.println("Only moderators can view all transactions.");
        }
    }

    // Moderator: Remove product
    public static void removeProduct() {
        if (loggedInUser instanceof Moderator) {
            System.out.print("Enter product ID to remove: ");
            int productId = scanner.nextInt();
            Product product = Storage.getProductById(productId);

            if (product != null) {
                Storage.getAllProducts().remove(product);
                System.out.println("Product removed successfully.");
            } else {
                System.out.println("Product not found.");
            }
        } else {
            System.out.println("Only moderators can remove products.");
        }
    }
}
