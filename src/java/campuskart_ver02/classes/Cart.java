package campuskart_ver02.classes;

import java.util.HashMap;
import java.util.Map;
import AbstactClasses.UserDetails;

public class Cart {
    private int cartId;
    private Student user;
    private Map<Product, Integer> items; // Product and quantity
    private double totalAmount;
    private String status; // ACTIVE, CHECKED_OUT, ABANDONED

    public Cart() {
        this.items = new HashMap<>();
        this.totalAmount = 0.0;
        this.status = "ACTIVE";
    }

    public Cart(Student user) {
        this();
        this.user = user;
    }

    // Getters and Setters
    public int getCartId() {
        return cartId;
    }

    public void setCartId(int cartId) {
        this.cartId = cartId;
    }

    public UserDetails getUser() {
        return user;
    }

    public void setUser(Student user) {
        this.user = user;
    }

    public Map<Product, Integer> getItems() {
        return items;
    }

    public void setItems(Map<Product, Integer> items) {
        this.items = items;
        calculateTotal();
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // Cart operations
    public void addItem(Product product, int quantity) {
        if (items.containsKey(product)) {
            int currentQuantity = items.get(product);
            items.put(product, currentQuantity + quantity);
        } else {
            items.put(product, quantity);
        }
        calculateTotal();
    }

    public void removeItem(Product product) {
        items.remove(product);
        calculateTotal();
    }

    public void updateQuantity(Product product, int quantity) {
        if (quantity <= 0) {
            removeItem(product);
        } else {
            items.put(product, quantity);
        }
        calculateTotal();
    }

    public void clearCart() {
        items.clear();
        totalAmount = 0.0;
    }

    private void calculateTotal() {
        totalAmount = 0.0;
        for (Map.Entry<Product, Integer> entry : items.entrySet()) {
            totalAmount += entry.getKey().getPrice() * entry.getValue();
        }
    }

    public int getItemCount() {
        return items.size();
    }

    public int getTotalQuantity() {
        int total = 0;
        for (int quantity : items.values()) {
            total += quantity;
        }
        return total;
    }
} 