package DAO;

import database.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import model.Flag;

public class FlagDAO {

    public boolean insert(Flag flag) {
        if (flag == null || flag.getProperty() == null) return false;
        String sql = "INSERT INTO flags (propertyId, reason, date) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, flag.getProperty().getPropertyId());
            pstmt.setString(2, flag.getReason());
            pstmt.setTimestamp(3, new java.sql.Timestamp(flag.getDate().getTime()));
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(String flagIdStr) {
        try {
            int flagId = Integer.parseInt(flagIdStr);
            String sql = "DELETE FROM flags WHERE flagId = ?";
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setInt(1, flagId);
                return pstmt.executeUpdate() > 0;
            } catch (SQLException e) {
                e.printStackTrace();
                return false;
            }
        } catch (NumberFormatException e) {
            return false;
        }
    }

    public boolean deleteByPropertyId(int propertyId) {
        String sql = "DELETE FROM flags WHERE propertyId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, propertyId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
