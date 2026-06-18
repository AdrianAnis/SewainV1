package DAO;

import database.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.User;
import model.Tenant;
import model.Owner;
import model.Admin;

public class UserDAOImpl implements UserDAO {

    public UserDAOImpl() {
        initializeDatabase();
    }

    private void initializeDatabase() {
        try (Connection conn = DatabaseConnection.getConnection()) {
            if (conn == null) {
                System.out.println("Warning: Database connection is null inside UserDAOImpl, skipping initialization.");
                return;
            }
            try (Statement stmt = conn.createStatement()) {
                // Ensure users table has status column
                try {
                    stmt.execute("ALTER TABLE users ADD COLUMN status VARCHAR(50) NOT NULL DEFAULT 'Active'");
                } catch (SQLException ignored) {
                    // Column already exists
                }

                // Create activity_log table
                String createActivityLogSql = "CREATE TABLE IF NOT EXISTS activity_log (" +
                        "logId INT AUTO_INCREMENT PRIMARY KEY, " +
                        "userId INT, " +
                        "action VARCHAR(255) NOT NULL, " +
                        "timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                        "description TEXT, " +
                        "FOREIGN KEY (userId) REFERENCES users(userId) ON DELETE SET NULL" +
                        ")";
                stmt.execute(createActivityLogSql);
                System.out.println("Table 'activity_log' initialized successfully.");

                // Seed admin user if not exists
                try (ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM users WHERE role = 'admin'")) {
                    if (rs.next() && rs.getInt(1) == 0) {
                        String insertAdminSql = "INSERT INTO users (name, email, password, phone, role, status) VALUES " +
                                "('Admin SewaIn', 'admin@sewain.com', 'admin123', '081234567890', 'admin', 'Active')";
                        stmt.execute(insertAdminSql);
                        System.out.println("Seed admin user created successfully.");
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public boolean registerUser(User user) {
        String sql = "INSERT INTO users (name, email, password, phone, role, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, user.getName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, util.PasswordUtil.hashPassword(user.getPassword()));
            stmt.setString(4, user.getPhone());
            stmt.setString(5, user.getRole().toLowerCase());
            stmt.setString(6, user.getStatus() != null ? user.getStatus() : "Active");
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean addUser(User user) {
        return registerUser(user);
    }

    @Override
    public User loginUser(String emailOrUsername, String password) {
        String sql = "SELECT * FROM users WHERE (email = ? OR name = ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, emailOrUsername);
            stmt.setString(2, emailOrUsername);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String pass = rs.getString("password");
                    
                    if (util.PasswordUtil.checkPassword(password, pass)) {
                        // Otomatis upgrade plain-text password ke hash yang aman saat login
                        if (pass != null && !pass.contains(":")) {
                            String newHash = util.PasswordUtil.hashPassword(password);
                            String updateSql = "UPDATE users SET password = ? WHERE userId = ?";
                            try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                                updateStmt.setString(1, newHash);
                                updateStmt.setInt(2, rs.getInt("userId"));
                                updateStmt.executeUpdate();
                            }
                            pass = newHash; // Update in memory object
                        }

                        String role = rs.getString("role");
                        String userId = String.valueOf(rs.getInt("userId"));
                        String name = rs.getString("name");
                        String email = rs.getString("email");
                        String status = rs.getString("status");
                        String phone = rs.getString("phone");
                        
                        User user;
                        if ("admin".equalsIgnoreCase(role)) {
                            user = new Admin(userId, name, email, pass, phone, role);
                        } else if ("owner".equalsIgnoreCase(role)) {
                            user = new Owner(userId, name, email, pass, phone, role);
                        } else {
                            user = new Tenant(userId, name, email, pass, phone, role);
                        }
                        user.setStatus(status);
                        return user;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public User getUserById(String userId) {
        String sql = "SELECT * FROM users WHERE userId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, Integer.parseInt(userId));
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String role = rs.getString("role");
                    String name = rs.getString("name");
                    String email = rs.getString("email");
                    String pass = rs.getString("password");
                    String status = rs.getString("status");
                    String phone = rs.getString("phone");
                    
                    User user;
                    if ("admin".equalsIgnoreCase(role)) {
                        user = new Admin(userId, name, email, pass, phone, role);
                    } else if ("owner".equalsIgnoreCase(role)) {
                        user = new Owner(userId, name, email, pass, phone, role);
                    } else {
                        user = new Tenant(userId, name, email, pass, phone, role);
                    }
                    user.setStatus(status);
                    return user;
                }
            }
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String role = rs.getString("role");
                    String userId = String.valueOf(rs.getInt("userId"));
                    String name = rs.getString("name");
                    String pass = rs.getString("password");
                    String status = rs.getString("status");
                    String phone = rs.getString("phone");
                    
                    User user;
                    if ("admin".equalsIgnoreCase(role)) {
                        user = new Admin(userId, name, email, pass, phone, role);
                    } else if ("owner".equalsIgnoreCase(role)) {
                        user = new Owner(userId, name, email, pass, phone, role);
                    } else {
                        user = new Tenant(userId, name, email, pass, phone, role);
                    }
                    user.setStatus(status);
                    return user;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean updateUser(User user) {
        String sql = "UPDATE users SET name = ?, email = ?, password = ?, phone = ?, role = ?, status = ? WHERE userId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());
            stmt.setString(4, user.getPhone());
            stmt.setString(5, user.getRole().toLowerCase());
            stmt.setString(6, user.getStatus());
            stmt.setInt(7, Integer.parseInt(user.getUserId()));
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean suspendUser(String userId) {
        return updateUserStatus(userId, "Suspended");
    }

    @Override
    public boolean activateUser(String userId) {
        return updateUserStatus(userId, "Active");
    }

    @Override
    public boolean upgradeToOwner(String userId) {
        String sql = "UPDATE users SET role = 'owner' WHERE userId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, Integer.parseInt(userId));
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY userId DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                String role = rs.getString("role");
                String userId = String.valueOf(rs.getInt("userId"));
                String name = rs.getString("name");
                String email = rs.getString("email");
                String pass = rs.getString("password");
                String status = rs.getString("status");
                String phone = rs.getString("phone");
                
                User user;
                if ("admin".equalsIgnoreCase(role)) {
                    user = new Admin(userId, name, email, pass, phone, role);
                } else if ("owner".equalsIgnoreCase(role)) {
                    user = new Owner(userId, name, email, pass, phone, role);
                } else {
                    user = new Tenant(userId, name, email, pass, phone, role);
                }
                user.setStatus(status);
                users.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    @Override
    public boolean updateUserStatus(String userId, String status) {
        String sql = "UPDATE users SET status = ? WHERE userId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, Integer.parseInt(userId));
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateProfile(User user) {
        String sql = "UPDATE users SET name = ?, phone = ? WHERE userId = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getName());
            stmt.setString(2, user.getPhone());
            stmt.setInt(3, Integer.parseInt(user.getUserId()));
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            return false;
        }
    }
}
