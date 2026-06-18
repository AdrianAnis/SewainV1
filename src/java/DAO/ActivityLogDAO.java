package DAO;

import database.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.ActivityLog;

public class ActivityLogDAO {

    public boolean addLog(int userId, String action, String description) {
        String sql = "INSERT INTO activity_log (userId, action, description) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            if (userId == 0) {
                pstmt.setNull(1, Types.INTEGER);
            } else {
                pstmt.setInt(1, userId);
            }
            pstmt.setString(2, action);
            pstmt.setString(3, description);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // UML mandated methods
    public List<ActivityLog> getAllLogs() {
        return getLogs(null, null);
    }

    public List<ActivityLog> getLogsByAction(String action) {
        return getLogs(action, null);
    }

    // Existing method kept for compatibility with AdminActivityServlet
    public List<ActivityLog> getLogs(String actionType, String dateStr) {
        List<ActivityLog> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT l.*, COALESCE(u.name, 'System/Deleted') AS userName " +
            "FROM activity_log l " +
            "LEFT JOIN users u ON l.userId = u.userId " +
            "WHERE 1=1 "
        );
        List<Object> params = new ArrayList<>();

        if (actionType != null && !actionType.trim().isEmpty() && !"all".equalsIgnoreCase(actionType)) {
            sql.append("AND l.action = ? ");
            params.add(actionType.trim());
        }

        if (dateStr != null && !dateStr.trim().isEmpty()) {
            sql.append("AND DATE(l.timestamp) = ? ");
            params.add(dateStr.trim());
        }

        sql.append("ORDER BY l.timestamp DESC");

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ActivityLog log = new ActivityLog(
                        rs.getInt("logId"),
                        rs.getInt("userId"),
                        rs.getString("userName"),
                        rs.getString("action"),
                        rs.getTimestamp("timestamp"),
                        rs.getString("description")
                    );
                    list.add(log);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
