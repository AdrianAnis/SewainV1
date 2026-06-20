package model;

import java.util.ArrayList;

public class Wishlist {

    private int wishlistId;
    private Tenant tenant;
    private ArrayList<Property> propertyList;

    public Wishlist() {
        propertyList = new ArrayList<>();
    }

    public Wishlist(int wishlistId, Tenant tenant, ArrayList<Property> propertyList) {
        this.wishlistId = wishlistId;
        this.tenant = tenant;
        this.propertyList = propertyList != null ? propertyList : new ArrayList<>();
    }

    public int getWishlistId() {
        return wishlistId;
    }

    public void setWishlistId(int wishlistId) {
        this.wishlistId = wishlistId;
    }

    public Tenant getTenant() {
        return tenant;
    }

    public void setTenant(Tenant tenant) {
        this.tenant = tenant;
    }

    public ArrayList<Property> getPropertyList() {
        return propertyList;
    }

    public void setPropertyList(ArrayList<Property> propertyList) {
        this.propertyList = propertyList;
    }

    public boolean addProperty(Property property) {
        if (propertyList == null) {
            propertyList = new ArrayList<>();
        }
        propertyList.add(property);
        if (this.tenant != null && this.tenant.getUserId() != null) {
            try {
                int tenantId = Integer.parseInt(this.tenant.getUserId());
                DAO.WishlistDAO dao = new DAO.WishlistDAO();
                return dao.addToWishlist(tenantId, property.getPropertyId());
            } catch (NumberFormatException e) {
                return false;
            }
        }
        return false;
    }

    public boolean removeProperty(Property property) {
        if (propertyList != null) {
            propertyList.remove(property);
        }
        if (this.tenant != null && this.tenant.getUserId() != null) {
            try {
                int tenantId = Integer.parseInt(this.tenant.getUserId());
                DAO.WishlistDAO dao = new DAO.WishlistDAO();
                return dao.removeFromWishlist(tenantId, property.getPropertyId());
            } catch (NumberFormatException e) {
                return false;
            }
        }
        return false;
    }

    public ArrayList<Property> getWishlist() {
        return propertyList;
    }

    public void loadWishlistFromDB() {
        if (this.tenant != null && this.tenant.getUserId() != null) {
            try {
                int tenantId = Integer.parseInt(this.tenant.getUserId());
                DAO.WishlistDAO dao = new DAO.WishlistDAO();
                java.util.List<Integer> ids = dao.getWishlistPropertyIds(tenantId);
                DAO.PropertyDAO pDao = new DAO.PropertyDAO();
                this.propertyList = new ArrayList<>(pDao.getPropertiesByIds(ids));
            } catch (NumberFormatException e) {}
        }
    }
}
