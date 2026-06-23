package model;

public class Tenant extends User {

    public Tenant() {
        super();
    }

    public Tenant(String userId, String name, String email, String password, String phone, String role) {
        super(userId, name, email, password, phone, role);
    }

    public java.util.List<Property> viewProperty() {
        DAO.PropertyDAO dao = new DAO.PropertyDAO();
        return dao.searchProperties(null, null, null, null);
    }

    public boolean addToWishlist(int propertyId) {
        Wishlist wishlist = new Wishlist();
        wishlist.setTenant(this);
        Property prop = new Kost();
        prop.setPropertyId(propertyId);
        return wishlist.addProperty(prop);
    }

    public boolean removeFromWishlist(int propertyId) {
        Wishlist wishlist = new Wishlist();
        wishlist.setTenant(this);
        Property prop = new Kost();
        prop.setPropertyId(propertyId);
        return wishlist.removeProperty(prop);
    }

    public java.util.List<Object[]> viewReportHistory() {
        DAO.ReportDAO dao = new DAO.ReportDAO();
        int tId = 0;
        try {
            tId = Integer.parseInt(this.getUserId());
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid user ID: " + this.getUserId());
        }
        return dao.getReportRowsByTenantId(tId);
    }
}
