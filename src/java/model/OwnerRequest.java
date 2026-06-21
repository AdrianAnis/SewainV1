package model;

import java.util.Date;
import java.util.List;

public class OwnerRequest {
    private String requestId;
    private Tenant tenant;
    private String status; 
    private Date date;
    private String reason;
    private String ktpPhotoUrl;
    private String rejectReason;

    public OwnerRequest() {
    }

    public OwnerRequest(String requestId, Tenant tenant, String status, Date date, String reason, String ktpPhotoUrl, String rejectReason) {
        this.requestId = requestId;
        this.tenant = tenant;
        this.status = status;
        this.date = date;
        this.reason = reason;
        this.ktpPhotoUrl = ktpPhotoUrl;
        this.rejectReason = rejectReason;
    }

    

    public boolean submitRequest() {
        if (tenant == null || tenant.getUserId() == null) return false;
        
        DAO.OwnerRequestDAO dao = new DAO.OwnerRequestDAO();
        
        
        OwnerRequest existing = dao.findLatestByTenantId(tenant.getUserId());
        if (existing != null && "pending".equals(existing.getStatus())) {
            return false; 
        }
        
        
        if (reason == null || reason.trim().isEmpty() || ktpPhotoUrl == null || ktpPhotoUrl.trim().isEmpty()) {
            return false;
        }

        this.status = "pending";
        this.date = new Date();
        
        return dao.insert(this);
    }

    public boolean approve() {
        
        if (!isPending()) {
            return false;
        }

        this.status = "approved";
        
        DAO.OwnerRequestDAO dao = new DAO.OwnerRequestDAO();
        boolean updated = dao.updateStatus(this.requestId, "approved", null);
        
        if (updated) {
            
            return dao.updateUserRoleToOwner(this.tenant.getUserId());
        }
        return false;
    }

    public boolean reject(String reasonStr) {
        
        if (!isPending()) {
            return false;
        }
        
        if (reasonStr == null || reasonStr.trim().isEmpty()) {
            return false;
        }

        this.status = "rejected";
        this.rejectReason = reasonStr;
        
        DAO.OwnerRequestDAO dao = new DAO.OwnerRequestDAO();
        return dao.updateStatus(this.requestId, "rejected", this.rejectReason);
    }

    public boolean isPending() {
        return "pending".equals(this.status);
    }

    public boolean canBeReviewed() {
        return isPending();
    }

    public static OwnerRequest getLatestStatusForTenant(String tenantId) {
        DAO.OwnerRequestDAO dao = new DAO.OwnerRequestDAO();
        return dao.findLatestByTenantId(tenantId);
    }

    public static OwnerRequest getById(String requestId) {
        DAO.OwnerRequestDAO dao = new DAO.OwnerRequestDAO();
        return dao.findById(requestId);
    }

    public static List<OwnerRequest> getPendingRequests() {
        DAO.OwnerRequestDAO dao = new DAO.OwnerRequestDAO();
        return dao.findByStatus("pending");
    }

    public static List<OwnerRequest> getAllRequestHistory() {
        DAO.OwnerRequestDAO dao = new DAO.OwnerRequestDAO();
        return dao.findAll();
    }

    
    public String getRequestId() { return requestId; }
    public void setRequestId(String requestId) { this.requestId = requestId; }

    public Tenant getTenant() { return tenant; }
    public void setTenant(Tenant tenant) { this.tenant = tenant; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getDate() { return date; }
    public void setDate(Date date) { this.date = date; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public String getKtpPhotoUrl() { return ktpPhotoUrl; }
    public void setKtpPhotoUrl(String ktpPhotoUrl) { this.ktpPhotoUrl = ktpPhotoUrl; }

    public String getRejectReason() { return rejectReason; }
    public void setRejectReason(String rejectReason) { this.rejectReason = rejectReason; }
}
