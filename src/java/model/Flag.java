package model;

import java.util.Date;

public class Flag {

    private int flagId;
    private Property property;
    private String reason;
    private Date date;

    // Constructors
    public Flag() {
    }

    public Flag(int flagId, Property property, String reason, Date date) {
        this.flagId = flagId;
        this.property = property;
        this.reason = reason;
        this.date = date;
    }

    // Getters and Setters
    public int getFlagId() {
        return flagId;
    }

    public void setFlagId(int flagId) {
        this.flagId = flagId;
    }

    public Property getProperty() {
        return property;
    }

    public void setProperty(Property property) {
        this.property = property;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    // UML methods
    public void addFlag() {
        System.out.println("Flag ditambahkan");
    }

    public void removeFlag() {
        System.out.println("Flag dihapus");
    }

    public String getFlagInfo() {
        return reason;
    }
}