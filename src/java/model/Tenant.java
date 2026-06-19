package model;

public class Tenant extends User {

    public Tenant() {
        super();
    }

    public Tenant(String userId, String name, String email, String password, String phone, String role) {
        super(userId, name, email, password, phone, role);
    }
    public void viewProperty() {
        System.out.println("[Tenant] " + getName() + " (ID: " + getUserId() + ") membuka halaman daftar properti.");
    }

    public void addToWishlist() {
        System.out.println("[Tenant] " + getName() + " (ID: " + getUserId() + ") menambahkan properti ke wishlist.");
    }

    public void reportProperty() {
        System.out.println("[Tenant] " + getName() + " (ID: " + getUserId() + ") melaporkan sebuah properti.");
    }
}
