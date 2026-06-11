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

    // Getters and Setters
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

    public void addProperty(Property property) {
        if (propertyList == null) {
            propertyList = new ArrayList<>();
        }
        propertyList.add(property);
    }

    public void removeProperty(Property property) {
        if (propertyList != null) {
            propertyList.remove(property);
        }
    }

    public ArrayList<Property> getWishlist() {
        return propertyList;
    }
}
