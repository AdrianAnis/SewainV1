package DAO;

import database.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.OwnerRequest;
import model.Tenant;

public class OwnerRequestDAO {

    public OwnerRequestDAO() {
        initializeDatabase();
    }

    private void initializeDatabase() {
        String createTableSql = "CREATE TABLE IF NOT EXISTS owner_requests (" +
                "request_id INT PRIMARY KEY AUTO_INCREMENT, " +
                "tenant_id INT NOT NULL, " +
                "status VARCHAR(20) DEFAULT 'pending', " +
                "request_date DATETIME DEFAULT CURRENT_TIMESTAMP, " +
                "reason TEXT, " +
                "ktp_photo_url VARCHAR(500) NOT NULL, " +
                "reject_reason TEXT, " +
                "FOREIGN KEY (tenant_id) REFERENCES users(userId)" +
                ")";

        try (Connection conn = DatabaseConnection.getConnection()) {
            if (conn == null) return;
            try (Statement stmt = conn.createStatement()) {
                stmt.execute(createTableSql);
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
    }

    public boolean insert(OwnerRequest request) {
        String insertSql = "INSERT INTO owner_requests (tenant_id, status, reason, ktp_photo_url, request_date) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
            
            insertStmt.setInt(1, Integer.parseInt(request.getTenant().getUserId()));
            insertStmt.setString(2, request.getStatus());
            insertStmt.setString(3, request.getReason());
            insertStmt.setString(4, request.getKtpPhotoUrl());
            insertStmt.setTimestamp(5, new java.sql.Timestamp(request.getDate().getTime()));
            
            return insertStmt.executeUpdate() > 0;
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            return false;
        }
    }

    public OwnerRequest findLatestByTenantId(String tenantId) {
        String sql = "SELECT r.*, u.name as user_name, u.email as user_email FROM owner_requests r JOIN users u ON r.tenant_id = u.userId WHERE r.tenant_id = ? ORDER BY r.request_date DESC LIMIT 1";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            stmt.setInt(1, Integer.parseInt(tenantId));
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return extractRequestFromResultSet(rs);
            }
        } catch (SQLException | NumberFormatException e) { 
            e.printStackTrace(); 
        }
        return null;
    }

    public OwnerRequest findById(String requestId) {
        String sql = "SELECT r.*, u.name as user_name, u.email as user_email FROM owner_requests r JOIN users u ON r.tenant_id = u.userId WHERE r.request_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            stmt.setInt(1, Integer.parseInt(requestId));
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return extractRequestFromResultSet(rs);
            }
        } catch (SQLException | NumberFormatException e) { 
            e.printStackTrace(); 
        }
        return null;
    }

    public List<OwnerRequest> findByStatus(String status) {
        List<OwnerRequest> list = new ArrayList<>();
        String sql = "SELECT r.*, u.name as user_name, u.email as user_email FROM owner_requests r JOIN users u ON r.tenant_id = u.userId WHERE r.status = ? ORDER BY r.request_date ASC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            stmt.setString(1, status);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(extractRequestFromResultSet(rs));
                }
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return list;
    }

    public List<OwnerRequest> findAll() {
        List<OwnerRequest> list = new ArrayList<>();
        String sql = "SELECT r.*, u.name as user_name, u.email as user_email FROM owner_requests r JOIN users u ON r.tenant_id = u.userId ORDER BY r.request_date DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
             
            while (rs.next()) {
                list.add(extractRequestFromResultSet(rs));
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return list;
    }

    public boolean updateStatus(String requestId, String status, String rejectReason) {
        String updateRequestSql = "UPDATE owner_requests SET status = ?, reject_reason = ? WHERE request_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(updateRequestSql)) {
             
            stmt.setString(1, status);
            stmt.setString(2, rejectReason);
            stmt.setInt(3, Integer.parseInt(requestId));
            return stmt.executeUpdate() > 0;
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateUserRoleToOwner(String tenantId) {
        String updateUserRoleSql = "UPDATE users SET role = 'owner' WHERE userId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(updateUserRoleSql)) {
             
            stmt.setInt(1, Integer.parseInt(tenantId));
            return stmt.executeUpdate() > 0;
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            return false;
        }
    }

    private OwnerRequest extractRequestFromResultSet(ResultSet rs) throws SQLException {
        OwnerRequest req = new OwnerRequest();
        req.setRequestId(String.valueOf(rs.getInt("request_id")));
        req.setStatus(rs.getString("status"));
        req.setDate(rs.getTimestamp("request_date"));
        req.setReason(rs.getString("reason"));
        req.setKtpPhotoUrl(rs.getString("ktp_photo_url"));
        req.setRejectReason(rs.getString("reject_reason"));
        
        Tenant tenant = new Tenant();
        tenant.setUserId(String.valueOf(rs.getInt("tenant_id")));
        
        try {
            tenant.setName(rs.getString("user_name"));
            tenant.setEmail(rs.getString("user_email"));
        } catch (SQLException ignore) {
        }
        
        req.setTenant(tenant);
        
        return req;
    }
}
