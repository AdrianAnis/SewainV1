/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Lenovo
 */


public class Owner extends User {

    public Owner() {
        super();
    }

    public Owner(String userId, String name, String email, String password, String phone, String role) {
        super(userId, name, email, password, phone, role);
    }

    public java.util.List<model.Report> viewReport() {
        int ownerId = 0;
        try {
            ownerId = Integer.parseInt(this.getUserId());
        } catch (Exception e) {}
        DAO.ReportDAO dao = new DAO.ReportDAO();
        return dao.getReportsByOwnerId(ownerId);
    }

    public boolean addProperty(Property property) {
        if (property != null) {
            property.setVerificationStatus("Pending");
            property.setFlagStatus("None");
            
            int ownerId = 0;
            try {
                ownerId = Integer.parseInt(this.getUserId());
            } catch (Exception e) {}
            
            DAO.PropertyDAO dao = new DAO.PropertyDAO();
            return dao.addProperty(property, ownerId);
        }
        return false;
    }


    public java.util.List<Property> viewProperty() {
        int ownerId = 0;
        try {
            ownerId = Integer.parseInt(this.getUserId());
        } catch (Exception e) {}
        DAO.PropertyDAO dao = new DAO.PropertyDAO();
        return dao.getPropertiesByOwnerId(ownerId);
    }

    public boolean editProperty(Property property) {
        if (property != null) {
            DAO.PropertyDAO dao = new DAO.PropertyDAO();
            return dao.updateProperty(property);
        }
        return false;
    }

    public Property getPropertyById(int propertyId) {
        DAO.PropertyDAO dao = new DAO.PropertyDAO();
        return dao.getPropertyById(propertyId);
    }

    public boolean deleteProperty(int propertyId) {
        DAO.PropertyDAO dao = new DAO.PropertyDAO();
        return dao.deleteProperty(propertyId);
    }
}
