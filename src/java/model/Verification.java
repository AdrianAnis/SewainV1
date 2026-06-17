/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;
import java.util.Date;
/**
 *
 * @author Lenovo
 */
public class Verification {

    private int verificationId;
    private Property property;
    private String status;
    private Date date;
    public Verification() {}

    public Verification(int verificationId, Property property, String status, Date date) {
        this.verificationId = verificationId;
        this.property = property;
        this.status = status;
        this.date = date;
    }

    public int getVerificationId() {
        return verificationId;
    }

    public void setVerificationId(int verificationId) {
        this.verificationId = verificationId;
    }

    public Property getProperty() {
        return property;
    }

    public void setProperty(Property property) {
        this.property = property;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date =  date;
    }
    
    public void approve() {
        status = "Approved";
    }

    public void reject()  {
        status = "Rejected";
    }
}