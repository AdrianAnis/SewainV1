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
            return new DAO.UserDAOImpl().updateUserStatus(user.getUserId(), user.getStatus());
        }
        return false;
    }

    public java.util.List<User> viewAllUsers() {
        return new DAO.UserDAOImpl().getAllUsers();
    }

    public User getUserById(String userId) {
        return new DAO.UserDAOImpl().getUserById(userId);
    }

    public boolean verifyProperty(Property property, String status, String reason) {
        if (property != null) {
            property.setVerificationStatus(status);
            if ("Approved".equalsIgnoreCase(status)) {
                reason = null;
            }
            DAO.PropertyDAO dao = new DAO.PropertyDAO();
            return dao.updateVerificationStatus(property.getPropertyId(), status, reason);
        }
        return false;
    }

    public java.util.List<Property> viewPendingProperties() {
        DAO.PropertyDAO dao = new DAO.PropertyDAO();
        return dao.getPendingProperties();
    }

    public java.util.List<Property> viewFlaggedProperties() {
        DAO.PropertyDAO dao = new DAO.PropertyDAO();
        return dao.getFlaggedProperties();
    }

    public boolean unflagProperty(int propertyId) {
        DAO.PropertyDAO dao = new DAO.PropertyDAO();
        return dao.updateFlagStatus(propertyId, "None", null);
    }

    public int getTotalUsersCount() {
        return new DAO.UserDAOImpl().getAllUsers().size();
    }

    public int getTotalPropertyCount() {
        return new DAO.PropertyDAO().getTotalPropertyCount();
    }

    public int getPendingPropertyCount() {
        return new DAO.PropertyDAO().getPendingPropertyCount();
    }

    public int getPendingReportsCount() {
        return new DAO.ReportDAO().getPendingReportsCount();
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
            return new DAO.ReportDAO().updateReportStatus(report.getReportId(), finalStatus);
        }
        return false;
    }

    public java.util.List<Report> viewAllReports() {
        return new DAO.ReportDAO().getAllReports();
    }

    public Report getReportById(int reportId) {
        return new DAO.ReportDAO().getReportById(reportId);
    }

    public boolean incrementPropertyFlagCount(Property prop, String reason) {
        int newCount = prop.getFlagCount() + 1;
        String newStatus = (newCount >= 3) ? "Banned" : "Flagged";
        
        prop.setFlagCount(newCount);
        prop.setFlagStatus(newStatus);
        prop.setFlagReason(reason);
        
        return new DAO.PropertyDAO().updateFlagAndCount(prop.getPropertyId(), newCount, newStatus, reason);
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
