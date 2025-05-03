import campuskart_ver02.classes.Product;

import javax.swing.*;
import java.awt.*;
import java.io.File;

public abstract class ProductCardBase {
    protected JPanel createCard(Product product) {
        JPanel card = new JPanel();
        card.setLayout(new BoxLayout(card, BoxLayout.Y_AXIS));
        card.setPreferredSize(new Dimension(220, 320));
        card.setBackground(Color.WHITE);
        card.setBorder(BorderFactory.createCompoundBorder(
                BorderFactory.createLineBorder(new Color(180, 180, 180), 1),
                BorderFactory.createEmptyBorder(15, 15, 15, 15)
        ));

        // Add product image
        JLabel imageLabel = createImageLabel(product);
        imageLabel.setAlignmentX(Component.CENTER_ALIGNMENT);

        // Add product name
        JLabel name = new JLabel(product.getProductName());
        name.setFont(new Font("Arial", Font.BOLD, 16));
        name.setForeground(new Color(33, 37, 41));
        name.setAlignmentX(Component.CENTER_ALIGNMENT);

        // Add product price
        JLabel price = new JLabel("\u20B9" + product.getPrice());
        price.setForeground(new Color(25, 135, 84));
        price.setFont(new Font("Arial", Font.PLAIN, 14));
        price.setAlignmentX(Component.CENTER_ALIGNMENT);

        // Add product description
        JTextArea desc = new JTextArea(product.getDescription());
        desc.setFont(new Font("Arial", Font.PLAIN, 12));
        desc.setForeground(Color.DARK_GRAY);
        desc.setOpaque(false);
        desc.setLineWrap(true);
        desc.setWrapStyleWord(true);
        desc.setEditable(false);
        desc.setMaximumSize(new Dimension(180, 60));

        // Add 'Buy Now' button
        JButton buyNow = new JButton("Buy Now");
        buyNow.setAlignmentX(Component.CENTER_ALIGNMENT);
        buyNow.setBackground(new Color(0, 184, 148));
        buyNow.setForeground(Color.WHITE);
        buyNow.setFocusPainted(false);
        buyNow.setFont(new Font("Arial", Font.BOLD, 13));
        buyNow.setBorder(BorderFactory.createEmptyBorder(5, 15, 5, 15));
        buyNow.addActionListener(e -> JOptionPane.showMessageDialog(
                null,
                "Product purchased: " + product.getProductName(),
                "Purchase Successful",
                JOptionPane.INFORMATION_MESSAGE
        ));

        // Add components to the card
        card.add(imageLabel);
        card.add(Box.createVerticalStrut(10));
        card.add(name);
        card.add(price);
        card.add(Box.createVerticalStrut(5));
        card.add(desc);
        card.add(Box.createVerticalStrut(10));
        card.add(buyNow);

        return card;
    }

    // Abstract method to be implemented by concrete classes for image handling
    protected abstract JLabel createImageLabel(Product product);
}
