/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Lenovo
 */
public class Apartement extends Property {

    private int lantai;
    private String nomorUnit;
    private String tipeUnit;

    public Apartement() {
        super();
    }

    public Apartement(int propertyId, String name, String location, double price, String propertyType,
                      boolean availability, String verificationStatus, String flagStatus, String photos,
                      String description, String facilities,
                      int lantai, String nomorUnit, String tipeUnit) {
        super(propertyId, name, location, price, propertyType, availability, verificationStatus, flagStatus, photos, description, facilities);
        this.lantai = lantai;
        this.nomorUnit = nomorUnit;
        this.tipeUnit = tipeUnit;
    }

    public int getLantai() {
        return lantai;
    }

    public void setLantai(int lantai) {
        this.lantai = lantai;
    }

    public String getNomorUnit() {
        return nomorUnit;
    }

    public void setNomorUnit(String nomorUnit) {
        this.nomorUnit = nomorUnit;
    }

    public String getTipeUnit() {
        return tipeUnit;
    }

    public void setTipeUnit(String tipeUnit) {
        this.tipeUnit = tipeUnit;
    }

    @Override
    public java.util.List<String> getSpecificDetails() {
        java.util.List<String> details = new java.util.ArrayList<>();
        details.add("Lantai: " + lantai);
        details.add("No. Unit: " + (nomorUnit != null ? nomorUnit : "12B"));
        details.add("Tipe Unit: " + (tipeUnit != null ? tipeUnit : "Studio"));
        return details;
    }

    @Override
    public String toJson() {
        return "{" + buildBaseJson() + ","
                + "\"lantai\":" + lantai + ","
                + "\"nomorUnit\":\"" + escapeJson(nomorUnit) + "\","
                + "\"tipeUnit\":\"" + escapeJson(tipeUnit) + "\""
                + "}";
    }

    @Override
    public String getPropertyTypeLabel() {
        return "Apartemen";
    }
}

