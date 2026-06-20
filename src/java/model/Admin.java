/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Lenovo
 */
public class Admin extends User {

    public Admin() {
        super();
    }

    public Admin(String userId, String name, String email, String password, String phone, String role) {
        super(userId, name, email, password, phone, role);
    }

    public boolean manageUser(User user, String action) {
        if (user != null) {
            if ("suspend".equalsIgnoreCase(action)) {
                user.setStatus("Suspended");
            } else if ("activate".equalsIgnoreCase(action)) {
                user.setStatus("Active");
            }
            return true;
        }
        return false;
    }

    public boolean verifyProperty(Property property, String status) {
        if (property != null) {
            property.setVerificationStatus(status);
            DAO.PropertyDAO dao = new DAO.PropertyDAO();
            return dao.updateVerificationStatus(property.getPropertyId(), status);
        }
        return false;
    }

    public java.util.List<Property> viewPendingProperties() {
        DAO.PropertyDAO dao = new DAO.PropertyDAO();
        return dao.getPendingProperties();
    }

    public Property getPropertyById(int propertyId) {
        DAO.PropertyDAO dao = new DAO.PropertyDAO();
        return dao.getPropertyById(propertyId);
    }

    public java.util.List<ActivityLog> monitorActivity(String actionType, String date) {
        return new ActivityLog().getLogs(actionType, date);
    }

    public boolean handleReport(Report report, String finalStatus) {
        if (report != null) {
            report.updateStatus(finalStatus);
            return true;
        }
        return false;
    }

    public Flag flagProperty(Property property, String reason) {
        if (property != null) {
            Flag flag = new Flag();
            boolean saved = flag.addFlag(property, reason);
            if (saved) return flag;
        }
        return null;
    }

    public boolean deleteProperty(int propertyId) {
        DAO.PropertyDAO dao = new DAO.PropertyDAO();
        return dao.deleteProperty(propertyId);
    }
}
