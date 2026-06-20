package model;

import java.sql.Timestamp;
import java.util.List;
import java.util.ArrayList;

public class ActivityLog {

    private int logId;
    private User user; 
    private int userId; 
    private String userName; 
    private String action;
    private Timestamp timestamp;
    private String description;


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

    public boolean addLog(int userId, String action, String description) {
        DAO.ActivityLogDAO dao = new DAO.ActivityLogDAO();
        return dao.addLog(userId, action, description);
    }

    public List<ActivityLog> getLogs(String actionType, String dateStr) {
        DAO.ActivityLogDAO dao = new DAO.ActivityLogDAO();
        return dao.getLogs(actionType, dateStr);
    }
}