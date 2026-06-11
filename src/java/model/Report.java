/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author Lenovo
 */
public class Report {

    private int reportId;
    private int propertyId;
    private int tenantId;
    private String issueType;
    private String description;
    private Timestamp reportDate;
    private String status;
    private String propertyName;
    private String tenantName;

    public Report() {
        this.status = "Pending";
    }
    public Report(int reportId, int propertyId, int tenantId, String issueType, String description, Timestamp reportDate, String status) {
        this.reportId = reportId;
        this.propertyId = propertyId;
        this.tenantId = tenantId;
        this.issueType = issueType;
        this.description = description;
        this.reportDate = reportDate;
        this.status = status;
    }

    public Report(int propertyId, int tenantId, String issueType, String description) {
        this.propertyId = propertyId;
        this.tenantId = tenantId;
        this.issueType = issueType;
        this.description = description;
        this.status = "Pending";
    }

    // Getters and Setters
    public int getReportId() {
        return reportId;
    }

    public void setReportId(int reportId) {
        this.reportId = reportId;
    }

    public int getPropertyId() {
        return propertyId;
    }

    public void setPropertyId(int propertyId) {
        this.propertyId = propertyId;
    }

    public int getTenantId() {
        return tenantId;
    }

    public void setTenantId(int tenantId) {
        this.tenantId = tenantId;
    }

    public String getIssueType() {
        return issueType;
    }

    public void setIssueType(String issueType) {
        this.issueType = issueType;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Timestamp getReportDate() {
        return reportDate;
    }

    public void setReportDate(Timestamp reportDate) {
        this.reportDate = reportDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPropertyName() {
        return propertyName;
    }

    public void setPropertyName(String propertyName) {
        this.propertyName = propertyName;
    }

    public String getTenantName() {
        return tenantName;
    }

    public void setTenantName(String tenantName) {
        this.tenantName = tenantName;
    }

    public void submitReport() {
        System.out.println("Laporan penipuan berhasil dikirim untuk properti ID: " + propertyId);
    }

    // UML Compliance Method
    public void updateStatus(String status) {
        this.status = status;
    }
}
