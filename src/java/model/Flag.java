package model;

import java.util.Date;

public class Flag {

    private int flagId;
    private Property property;
    private String reason;
    private Date date;

    public Flag() {
    }

    public Flag(int flagId, Property property, String reason, Date date) {
        this.flagId = flagId;
        this.property = property;
        this.reason = reason;
        this.date = date;
    }

    
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

    public boolean addFlag(Property target, String reasonDetail) {
        this.property = target;
        this.reason = reasonDetail;
        this.date = new Date();
        DAO.FlagDAO dao = new DAO.FlagDAO();
        return dao.insert(this);
    }

    public boolean removeFlag(int propertyId) {
        DAO.FlagDAO dao = new DAO.FlagDAO();
        return dao.deleteByPropertyId(propertyId);
    }

    public String getFlagInfo() {
        return "Reason: " + this.reason + " (Date: " + this.date + ")";
    }
}