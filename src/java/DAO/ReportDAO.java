package DAO;

import database.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Report;

public class ReportDAO {

    public ReportDAO() {
        initializeDatabase();
    }

    private void initializeDatabase() {
        String createTableSql = "CREATE TABLE IF NOT EXISTS reports (" +
                "reportId INT AUTO_INCREMENT PRIMARY KEY, " +
                "propertyId INT, " +
                "tenantId INT, " +
                "issueType ENUM('Harga Tidak Sesuai', 'Gambar Tidak Sesuai', 'Indikasi Penipuan/Scam', 'Fasilitas Rusak', 'Lainnya') NOT NULL, " +
                "description TEXT NOT NULL, " +
                "status ENUM('Pending', 'Investigating', 'Resolved', 'Rejected') DEFAULT 'Pending', " +
                "reportDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                "FOREIGN KEY (propertyId) REFERENCES properties(propertyId) ON DELETE CASCADE" +
                ")";

        try (Connection conn = DatabaseConnection.getConnection()) {
            if (conn == null) {
                System.out.println("Warning: Database connection is null inside ReportDAO, skipping initialization.");
                return;
            }
            try (Statement stmt = conn.createStatement()) {
                stmt.execute(createTableSql);
                System.out.println("Table 'reports' initialized successfully.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    
    public boolean addReport(Report report) {
        return insertReport(report);
    }

    public boolean resolveReport(int reportId) {
        return updateReportStatus(reportId, "Resolved");
    }

    public Report getReportById(int reportId) {
        String sql = "SELECT r.reportId, r.propertyId, r.tenantId, r.issueType, " +
                     "r.description, r.reportDate, r.status, " +
                     "p.name AS propertyName, u.name AS tenantName " +
                     "FROM reports r " +
                     "LEFT JOIN properties p ON r.propertyId = p.propertyId " +
                     "LEFT JOIN users u ON r.tenantId = u.userId " +
                     "WHERE r.reportId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, reportId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Report report = new Report(
                        rs.getInt("reportId"),
                        rs.getInt("propertyId"),
                        rs.getInt("tenantId"),
                        rs.getString("issueType"),
                        rs.getString("description"),
                        rs.getTimestamp("reportDate"),
                        rs.getString("status")
                    );
                    report.setPropertyName(rs.getString("propertyName") != null ? rs.getString("propertyName") : "Properti Dihapus");
                    report.setTenantName(rs.getString("tenantName") != null ? rs.getString("tenantName") : "Tenant Dihapus");
                    return report;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertReport(Report report) {
        String sql = "INSERT INTO reports (propertyId, tenantId, issueType, description, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, report.getPropertyId());
            stmt.setInt(2, report.getTenantId());
            stmt.setString(3, report.getIssueType());
            stmt.setString(4, report.getDescription());
            stmt.setString(5, report.getStatus() != null ? report.getStatus() : "Pending");
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Report> getReportsByTenantId(int tenantId) {
        List<Report> list = new ArrayList<>();
        String sql = "SELECT r.reportId, r.propertyId, r.tenantId, r.issueType, " +
                     "r.description, r.reportDate, r.status, " +
                     "COALESCE(p.name, 'Properti Dihapus') AS propertyName " +
                     "FROM reports r " +
                     "LEFT JOIN properties p ON r.propertyId = p.propertyId " +
                     "WHERE r.tenantId = ? ORDER BY r.reportDate DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, tenantId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Report report = new Report(
                        rs.getInt("reportId"),
                        rs.getInt("propertyId"),
                        rs.getInt("tenantId"),
                        rs.getString("issueType"),
                        rs.getString("description"),
                        rs.getTimestamp("reportDate"),
                        rs.getString("status")
                    );
                    list.add(report);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Object[]> getReportRowsByTenantId(int tenantId) {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT r.reportId, COALESCE(p.name, 'Properti Dihapus') AS propertyName, " +
                     "r.issueType, r.description, r.reportDate, r.status " +
                     "FROM reports r " +
                     "LEFT JOIN properties p ON r.propertyId = p.propertyId " +
                     "WHERE r.tenantId = ? ORDER BY r.reportDate DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, tenantId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Object[] row = new Object[]{
                        rs.getInt("reportId"),
                        rs.getString("propertyName"),
                        rs.getString("issueType"),
                        rs.getString("description"),
                        rs.getTimestamp("reportDate"),
                        rs.getString("status")
                    };
                    list.add(row);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Report> getReportsByOwnerId(int ownerId) {
        List<Report> list = new ArrayList<>();
        String sql = "SELECT r.reportId, r.propertyId, r.tenantId, r.issueType, " +
                     "r.description, r.reportDate, r.status, " +
                     "p.name AS propertyName, u.name AS tenantName " +
                     "FROM reports r " +
                     "JOIN properties p ON r.propertyId = p.propertyId " +
                     "JOIN users u ON r.tenantId = u.userId " +
                     "WHERE p.ownerId = ? " +
                     "ORDER BY r.reportDate DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, ownerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Report report = new Report(
                        rs.getInt("reportId"),
                        rs.getInt("propertyId"),
                        rs.getInt("tenantId"),
                        rs.getString("issueType"),
                        rs.getString("description"),
                        rs.getTimestamp("reportDate"),
                        rs.getString("status")
                    );
                    report.setPropertyName(rs.getString("propertyName"));
                    report.setTenantName(rs.getString("tenantName"));
                    list.add(report);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getPendingReportsCount() {
        String sql = "SELECT COUNT(*) FROM reports WHERE status = 'Pending'";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Report> getAllReports() {
        List<Report> list = new ArrayList<>();
        String sql = "SELECT r.reportId, r.propertyId, r.tenantId, r.issueType, " +
                     "r.description, r.reportDate, r.status, " +
                     "p.name AS propertyName, u.name AS tenantName " +
                     "FROM reports r " +
                     "LEFT JOIN properties p ON r.propertyId = p.propertyId " +
                     "LEFT JOIN users u ON r.tenantId = u.userId " +
                     "ORDER BY r.reportDate DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Report report = new Report(
                    rs.getInt("reportId"),
                    rs.getInt("propertyId"),
                    rs.getInt("tenantId"),
                    rs.getString("issueType"),
                    rs.getString("description"),
                    rs.getTimestamp("reportDate"),
                    rs.getString("status")
                );
                report.setPropertyName(rs.getString("propertyName") != null ? rs.getString("propertyName") : "Properti Dihapus");
                report.setTenantName(rs.getString("tenantName") != null ? rs.getString("tenantName") : "Tenant Dihapus");
                list.add(report);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateReportStatus(int reportId, String status) {
        String sql = "UPDATE reports SET status = ? WHERE reportId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, status);
            pstmt.setInt(2, reportId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}