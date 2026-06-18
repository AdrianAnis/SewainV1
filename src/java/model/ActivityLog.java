package model;

import java.sql.Timestamp;
import java.util.List;
import java.util.ArrayList;

public class ActivityLog {

    private int logId;
    private User user; // Added for UML compliance
    private int userId; // Kept for compatibility
    private String userName; // Kept for compatibility
    private String action;
    private Timestamp timestamp;
    private String description;

    // Constructors
    public ActivityLog() {}

    public ActivityLog(int logId, int userId, String userName, String action, Timestamp timestamp, String description) {
        this.logId = logId;
        this.userId = userId;
        this.userName = userName;
        this.action = action;
        this.timestamp = timestamp;
        this.description = description;
    }

    public ActivityLog(int userId, String action, String description) {
        this.userId = userId;
        this.action = action;
        this.description = description;
    }

    // Getters and Setters
    public int getLogId() {
        return logId;
    }

    public void setLogId(int logId) {
        this.logId = logId;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
        if (user != null) {
            try {
                this.userId = Integer.parseInt(user.getUserId());
            } catch (Exception ignored) {}
            this.userName = user.getName();
        }
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public Timestamp getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Timestamp timestamp) {
        this.timestamp = timestamp;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void addLog() {
        System.out.println("Log ditambahkan: " + action + " - " + description);
    }

    public void getLogs() {
        System.out.println("Menampilkan log ID: " + logId);
    }

    // UML Compliance Method
    public List<ActivityLog> getLogsList() {
        return new ArrayList<>(); // Kept for compatibility and UML compliance
    }
}
