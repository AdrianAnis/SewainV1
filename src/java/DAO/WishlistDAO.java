package DAO;

import database.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class WishlistDAO {

    public WishlistDAO() {
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
