package DAO;

import database.DatabaseConnection;
import java.sql.*;
import java.util.*;
import model.*;

public class PropertyDAO {

    public PropertyDAO() {
        initializeDatabase();
    }

    private void initializeDatabase() {
            String createTableSql = "CREATE TABLE IF NOT EXISTS properties (" +
                "propertyId INT PRIMARY KEY AUTO_INCREMENT, " +
                "name VARCHAR(255) NOT NULL, " +
                "location VARCHAR(255) NOT NULL, " +
                "price DOUBLE NOT NULL, " +
                "propertyType VARCHAR(100) NOT NULL, " +
                "availability TINYINT NOT NULL DEFAULT 1, " +
                "verificationStatus VARCHAR(50) NOT NULL DEFAULT 'Pending', " +
                "flagStatus VARCHAR(50) NOT NULL DEFAULT 'None', " +
                "flagReason TEXT, " +
                "flagCount INT NOT NULL DEFAULT 0, " +
                "photos TEXT, " +
                "description TEXT, " +
                "facilities TEXT, " +
                "ownerId INT NOT NULL DEFAULT 1, " +
                "gender VARCHAR(50), " +
                "roomType VARCHAR(100), " +
                "jumlahKamar INT, " +
                "luasTanah DOUBLE, " +
                "durasiMinimum INT, " +
                "lantai INT, " +
                "nomorUnit VARCHAR(50), " +
                "tipeUnit VARCHAR(50)" +
                ")";

        try (Connection conn = DatabaseConnection.getConnection()) {
            if (conn == null) {
                System.out.println("Warning: Database connection is null, skipping initialization.");
                return;
            }

            boolean tableExists = false;
            try (ResultSet rs = conn.getMetaData().getTables(null, null, "properties", null)) {
                if (rs.next()) {
                    tableExists = true;
                }
            }

            boolean isEmpty = true;
            if (tableExists) {
                try (Statement stmt = conn.createStatement();
                     ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM properties")) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        isEmpty = false;
                    }
                }
                if (isEmpty) {
                    try (Statement stmt = conn.createStatement()) {
                        stmt.execute("SET FOREIGN_KEY_CHECKS = 0");
                        stmt.execute("DROP TABLE properties");
                        stmt.execute("SET FOREIGN_KEY_CHECKS = 1");
                    }
                    tableExists = false;
                }
            }
            try (Statement stmt = conn.createStatement()) {
                stmt.execute(createTableSql);
            }
            if (tableExists && !isEmpty) {
                try (Statement stmt = conn.createStatement()) {
                    try { stmt.execute("ALTER TABLE properties ADD COLUMN description TEXT"); } catch (SQLException ignored) {}
                    try { stmt.execute("ALTER TABLE properties ADD COLUMN facilities TEXT"); } catch (SQLException ignored) {}
                    try { stmt.execute("ALTER TABLE properties ADD COLUMN propertyType VARCHAR(100) NOT NULL DEFAULT 'Kost'"); } catch (SQLException ignored) {}
                    try { stmt.execute("ALTER TABLE properties ADD COLUMN verificationStatus VARCHAR(50) NOT NULL DEFAULT 'Pending'"); } catch (SQLException ignored) {}
                    try { stmt.execute("ALTER TABLE properties ADD COLUMN flagStatus VARCHAR(50) NOT NULL DEFAULT 'None'"); } catch (SQLException ignored) {}
                    try { stmt.execute("ALTER TABLE properties ADD COLUMN flagReason TEXT"); } catch (SQLException ignored) {}
                    try { stmt.execute("ALTER TABLE properties ADD COLUMN rejectionReason TEXT"); } catch (SQLException ignored) {}
                    try { stmt.execute("ALTER TABLE properties ADD COLUMN flagCount INT NOT NULL DEFAULT 0"); } catch (SQLException ignored) {}
                    try { stmt.execute("ALTER TABLE properties ADD COLUMN ownerId INT NOT NULL DEFAULT 1"); } catch (SQLException ignored) {}
                    try { stmt.execute("ALTER TABLE properties ADD COLUMN gender VARCHAR(50)"); } catch (SQLException ignored) {}
                    try { stmt.execute("ALTER TABLE properties ADD COLUMN roomType VARCHAR(100)"); } catch (SQLException ignored) {}
                    try { stmt.execute("ALTER TABLE properties ADD COLUMN jumlahKamar INT"); } catch (SQLException ignored) {}
                    try { stmt.execute("ALTER TABLE properties ADD COLUMN luasTanah DOUBLE"); } catch (SQLException ignored) {}
                    try { stmt.execute("ALTER TABLE properties ADD COLUMN durasiMinimum INT"); } catch (SQLException ignored) {}
                    try { stmt.execute("ALTER TABLE properties ADD COLUMN lantai INT"); } catch (SQLException ignored) {}
                    try { stmt.execute("ALTER TABLE properties ADD COLUMN nomorUnit VARCHAR(50)"); } catch (SQLException ignored) {}
                    try { stmt.execute("ALTER TABLE properties ADD COLUMN tipeUnit VARCHAR(50)"); } catch (SQLException ignored) {}
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean addProperty(Property p, int ownerId) {
        String sql = "INSERT INTO properties (name, location, price, propertyType, availability, verificationStatus, flagStatus, photos, description, facilities, ownerId, gender, roomType, jumlahKamar, luasTanah, durasiMinimum, lantai, nomorUnit, tipeUnit) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, p.getName());
            pstmt.setString(2, p.getLocation());
            pstmt.setDouble(3, p.getPrice());
            pstmt.setString(4, p.getPropertyType());
            pstmt.setInt(5, p.isAvailability() ? 1 : 0);
            pstmt.setString(6, p.getVerificationStatus() != null ? p.getVerificationStatus() : "Pending");
            pstmt.setString(7, p.getFlagStatus() != null ? p.getFlagStatus() : "None");
            pstmt.setString(8, p.getPhotos() != null ? p.getPhotos() : "");
            pstmt.setString(9, p.getDescription());
            pstmt.setString(10, p.getFacilities());
            pstmt.setInt(11, ownerId);

            pstmt.setNull(12, Types.VARCHAR); 
            pstmt.setNull(13, Types.VARCHAR); 
            pstmt.setNull(14, Types.INTEGER); 
            pstmt.setNull(15, Types.DOUBLE);  
            pstmt.setNull(16, Types.INTEGER); 
            pstmt.setNull(17, Types.INTEGER); 
            pstmt.setNull(18, Types.VARCHAR); 
            pstmt.setNull(19, Types.VARCHAR); 

            if (p instanceof Kost) {
                Kost k = (Kost) p;
                pstmt.setString(12, k.getGenderType());
                pstmt.setString(13, k.getRoomType());
            } else if (p instanceof Rumah) {
                Rumah r = (Rumah) p;
                pstmt.setInt(14, r.getJumlahKamar());
                pstmt.setDouble(15, r.getLuasTanah());
            } else if (p instanceof Kontrakan) {
                Kontrakan kr = (Kontrakan) p;
                pstmt.setInt(14, kr.getJumlahKamar());
                pstmt.setInt(16, kr.getDurasiMinimum());
            } else if (p instanceof Apartement) {
                Apartement a = (Apartement) p;
                pstmt.setInt(17, a.getLantai());
                pstmt.setString(18, a.getNomorUnit());
                pstmt.setString(19, a.getTipeUnit());
            }

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Property> getPropertiesByOwnerId(int ownerId) {
        List<Property> results = new ArrayList<>();
        String sql = "SELECT * FROM properties WHERE ownerId = ? ORDER BY propertyId DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, ownerId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Property prop = mapResultSetToProperty(rs);
                    results.add(prop);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return results;
    }

    
    public List<Property> searchProperties(String name, String location, String priceRange, String propertyType) {
        List<Property> results = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT p.*, u.name AS ownerName FROM properties p LEFT JOIN users u ON p.ownerId = u.userId WHERE p.verificationStatus = 'Approved' AND p.flagCount < 3 AND p.availability = 1");
        List<Object> params = new ArrayList<>();

        if (name != null && !name.trim().isEmpty()) {
            sql.append(" AND p.name LIKE ?");
            params.add("%" + name.trim() + "%");
        }

        if (location != null && !location.trim().isEmpty()) {
            sql.append(" AND p.location LIKE ?");
            params.add("%" + location.trim() + "%");
        }

        if (propertyType != null && !propertyType.trim().isEmpty()) {
            sql.append(" AND p.propertyType = ?");
            params.add(propertyType.trim());
        }

        if (priceRange != null && !priceRange.trim().isEmpty()) {
            if ("under-2".equals(priceRange)) {
                sql.append(" AND p.price < 2000000");
            } else if ("2-5".equals(priceRange)) {
                sql.append(" AND p.price >= 2000000 AND p.price <= 5000000");
            } else if ("5-10".equals(priceRange)) {
                sql.append(" AND p.price >= 5000000 AND p.price <= 10000000");
            } else if ("10-20".equals(priceRange)) {
                sql.append(" AND p.price >= 10000000 AND p.price <= 20000000");
            } else if ("over-20".equals(priceRange)) {
                sql.append(" AND p.price > 20000000");
            }
        }

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Property prop = mapResultSetToProperty(rs);
                    String pOwnerName = "";
                    String pOwnerProfilePic = "";
                    try { pOwnerName = rs.getString("ownerName"); } catch(Exception ignored) {}
                    prop.setOwnerName(pOwnerName);
                    prop.setOwnerProfilePic(pOwnerProfilePic);
                    results.add(prop);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return results;
    }

    
    public List<Property> getPropertiesByIds(List<Integer> ids) {
        List<Property> results = new ArrayList<>();
        if (ids == null || ids.isEmpty()) {
            return results;
        }

        StringBuilder sql = new StringBuilder("SELECT * FROM properties WHERE verificationStatus = 'Approved' AND flagCount = 0 AND propertyId IN (");
        for (int i = 0; i < ids.size(); i++) {
            sql.append("?");
            if (i < ids.size() - 1) {
                sql.append(",");
            }
        }
        sql.append(")");

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < ids.size(); i++) {
                pstmt.setInt(i + 1, ids.get(i));
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Property prop = mapResultSetToProperty(rs);
                    results.add(prop);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return results;
    }

    private Property mapResultSetToProperty(ResultSet rs) throws SQLException {
        int id = rs.getInt("propertyId");
        String pName = rs.getString("name");
        String pLoc = rs.getString("location");
        double pPrice = rs.getDouble("price");
        String pType = rs.getString("propertyType");
        boolean pAvail = rs.getInt("availability") == 1;
        String pVerif = rs.getString("verificationStatus");
        String pFlag = rs.getString("flagStatus");
        String pPhotos = rs.getString("photos");
        String pDesc = rs.getString("description");
        String pFacs = rs.getString("facilities");
        int ownerId = rs.getInt("ownerId");

        Property prop;
        if ("apartemen".equalsIgnoreCase(pType) || "apartement".equalsIgnoreCase(pType)) {
            prop = new Apartement(id, pName, pLoc, pPrice, pType, pAvail, pVerif, pFlag, pPhotos, pDesc, pFacs,
                    rs.getInt("lantai"), rs.getString("nomorUnit"), rs.getString("tipeUnit"));
        } else if ("kost".equalsIgnoreCase(pType)) {
            prop = new Kost(id, pName, pLoc, pPrice, pType, pAvail, pVerif, pFlag, pPhotos, pDesc, pFacs,
                    rs.getString("gender"), rs.getString("roomType"));
        } else if ("kontrakan".equalsIgnoreCase(pType)) {
            prop = new Kontrakan(id, pName, pLoc, pPrice, pType, pAvail, pVerif, pFlag, pPhotos, pDesc, pFacs,
                    rs.getInt("durasiMinimum"), rs.getInt("jumlahKamar"));
        } else {
            prop = new Rumah(id, pName, pLoc, pPrice, pType, pAvail, pVerif, pFlag, pPhotos, pDesc, pFacs,
                    rs.getInt("jumlahKamar"), rs.getDouble("luasTanah"));
        }
        prop.setOwnerId(ownerId);
        prop.setFlagReason(rs.getString("flagReason"));
        prop.setRejectionReason(rs.getString("rejectionReason"));
        prop.setFlagCount(rs.getInt("flagCount"));
        return prop;
    }

    public List<String> autocompleteLocations(String query) {
        List<String> suggestions = new ArrayList<>();
        String sql = "SELECT DISTINCT location FROM properties WHERE location LIKE ? LIMIT 10";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, "%" + (query == null ? "" : query.trim()) + "%");

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    suggestions.add(rs.getString("location"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return suggestions;
    }

    public List<String> autocompletePropertyNames(String query) {
        List<String> suggestions = new ArrayList<>();
        String sql = "SELECT DISTINCT name FROM properties WHERE name LIKE ? LIMIT 10";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, "%" + (query == null ? "" : query.trim()) + "%");

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    suggestions.add(rs.getString("name"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return suggestions;
    }

    public Property getPropertyById(int propertyId) {
        String sql = "SELECT * FROM properties WHERE propertyId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, propertyId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToProperty(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean deleteProperty(int propertyId) {
        String deleteReportsSql = "DELETE FROM reports WHERE propertyId = ?";
        String deletePropertySql = "DELETE FROM properties WHERE propertyId = ?";
        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement pstmt1 = conn.prepareStatement(deleteReportsSql);
                 PreparedStatement pstmt2 = conn.prepareStatement(deletePropertySql)) {
                
                pstmt1.setInt(1, propertyId);
                pstmt1.executeUpdate();
                
                pstmt2.setInt(1, propertyId);
                int affected = pstmt2.executeUpdate();
                
                conn.commit();
                return affected > 0;
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateProperty(Property p) {
        String sql = "UPDATE properties SET name = ?, location = ?, price = ?, availability = ?, photos = ?, description = ?, facilities = ?, "
                + "gender = ?, roomType = ?, jumlahKamar = ?, luasTanah = ?, durasiMinimum = ?, lantai = ?, nomorUnit = ?, tipeUnit = ? "
                + "WHERE propertyId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, p.getName());
            pstmt.setString(2, p.getLocation());
            pstmt.setDouble(3, p.getPrice());
            pstmt.setInt(4, p.isAvailability() ? 1 : 0);
            pstmt.setString(5, p.getPhotos() != null ? p.getPhotos() : "");
            pstmt.setString(6, p.getDescription());
            pstmt.setString(7, p.getFacilities());

            pstmt.setNull(8, Types.VARCHAR); 
            pstmt.setNull(9, Types.VARCHAR); 
            pstmt.setNull(10, Types.INTEGER); 
            pstmt.setNull(11, Types.DOUBLE); 
            pstmt.setNull(12, Types.INTEGER); 
            pstmt.setNull(13, Types.INTEGER); 
            pstmt.setNull(14, Types.VARCHAR); 
            pstmt.setNull(15, Types.VARCHAR); 
            
            if (p instanceof Kost) {
                Kost k = (Kost) p;
                pstmt.setString(8, k.getGenderType());
                pstmt.setString(9, k.getRoomType());
            } else if (p instanceof Rumah) {
                Rumah r = (Rumah) p;
                pstmt.setInt(10, r.getJumlahKamar());
                pstmt.setDouble(11, r.getLuasTanah());
            } else if (p instanceof Kontrakan) {
                Kontrakan kr = (Kontrakan) p;
                pstmt.setInt(10, kr.getJumlahKamar());
                pstmt.setInt(12, kr.getDurasiMinimum());
            } else if (p instanceof Apartement) {
                Apartement a = (Apartement) p;
                pstmt.setInt(13, a.getLantai());
                pstmt.setString(14, a.getNomorUnit());
                pstmt.setString(15, a.getTipeUnit());
            }

            pstmt.setInt(16, p.getPropertyId());

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getTotalPropertyCount() {
        String sql = "SELECT COUNT(*) FROM properties";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getPendingPropertyCount() {
        String sql = "SELECT COUNT(*) FROM properties WHERE verificationStatus = 'Pending'";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getFlaggedPropertyCount() {
        String sql = "SELECT COUNT(*) FROM properties WHERE flagStatus != 'None'";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Property> getPendingProperties() {
        List<Property> list = new ArrayList<>();
        String sql = "SELECT p.*, u.name AS ownerName FROM properties p LEFT JOIN users u ON p.ownerId = u.userId WHERE p.verificationStatus = 'Pending' ORDER BY p.propertyId DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Property prop = mapResultSetToProperty(rs);
                prop.setOwnerName(rs.getString("ownerName"));
                list.add(prop);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Property> getFlaggedProperties() {
        List<Property> list = new ArrayList<>();
        String sql = "SELECT p.*, u.name AS ownerName FROM properties p LEFT JOIN users u ON p.ownerId = u.userId WHERE p.flagStatus != 'None' ORDER BY p.propertyId DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Property prop = mapResultSetToProperty(rs);
                prop.setOwnerName(rs.getString("ownerName"));
                list.add(prop);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateVerificationStatus(int propertyId, String status, String reason) {
        String sql = "UPDATE properties SET verificationStatus = ?, rejectionReason = ? WHERE propertyId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, status);
            pstmt.setString(2, reason);
            pstmt.setInt(3, propertyId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateAvailability(int propertyId, boolean available) {
        String sql = "UPDATE properties SET availability = ? WHERE propertyId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, available ? 1 : 0);
            pstmt.setInt(2, propertyId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateFlagStatus(int propertyId, String flagStatus, String flagReason) {
        String sql = "UPDATE properties SET flagStatus = ?, flagReason = ? WHERE propertyId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, flagStatus);
            pstmt.setString(2, flagReason);
            pstmt.setInt(3, propertyId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateFlagAndCount(int propertyId, int newCount, String newStatus, String reason) {
        String updateSql = "UPDATE properties SET flagCount = ?, flagStatus = ?, flagReason = ? WHERE propertyId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(updateSql)) {
            pstmt.setInt(1, newCount);
            pstmt.setString(2, newStatus);
            pstmt.setString(3, reason);
            pstmt.setInt(4, propertyId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Property> getLandingProperties() {
        List<Property> results = new ArrayList<>();
        String sql = "SELECT p.*, u.name AS ownerName FROM properties p LEFT JOIN users u ON p.ownerId = u.userId " +
                     "WHERE p.verificationStatus = 'Approved' AND p.flagCount < 3 " +
                     "ORDER BY p.price DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Property prop = mapResultSetToProperty(rs);
                    String pOwnerName = "";
                    try { pOwnerName = rs.getString("ownerName"); } catch(Exception ignored) {}
                    prop.setOwnerName(pOwnerName);
                    results.add(prop);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return results;
    }
}