package DAO;

import database.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class WishlistDAO {

    public WishlistDAO() {
        initializeDatabase();
    }

    private void initializeDatabase() {
        try (Connection conn = DatabaseConnection.getConnection()) {
            if (conn != null) {
                try (java.sql.Statement stmt = conn.createStatement()) {
                    String sql = "CREATE TABLE IF NOT EXISTS wishlists (" +
                                 "wishlistId INT AUTO_INCREMENT PRIMARY KEY, " +
                                 "tenantId INT NOT NULL, " +
                                 "propertyId INT NOT NULL" +
                                 ")";
                    stmt.execute(sql);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean addToWishlist(int tenantId, int propertyId) {
        String sql = "INSERT INTO wishlists (tenantId, propertyId) VALUES (?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, tenantId);
            pstmt.setInt(2, propertyId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean removeFromWishlist(int tenantId, int propertyId) {
        String sql = "DELETE FROM wishlists WHERE tenantId = ? AND propertyId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, tenantId);
            pstmt.setInt(2, propertyId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public java.util.List<Integer> getWishlistPropertyIds(int tenantId) {
        java.util.List<Integer> list = new java.util.ArrayList<>();
        String sql = "SELECT propertyId FROM wishlists WHERE tenantId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, tenantId);
            try (java.sql.ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getInt("propertyId"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
