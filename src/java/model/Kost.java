/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Lenovo
 */
public class Kost extends Property {

    private String gender;
    private String roomType;

    public Kost() {
        super();
    }

    public Kost(int propertyId, String name, String location, double price, String propertyType,
                boolean availability, String verificationStatus, String flagStatus, String photos,
                String description, String facilities,
                String gender, String roomType) {
        super(propertyId, name, location, price, propertyType, availability, verificationStatus, flagStatus, photos, description, facilities);
        this.gender = gender;
        this.roomType = roomType;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getGenderType() {
        return gender;
    }

    public String getRoomType() {
        return roomType;
    }

    public void setRoomType(String roomType) {
        this.roomType = roomType;
    }

    @Override
    public java.util.List<String> getSpecificDetails() {
        java.util.List<String> details = new java.util.ArrayList<>();
        details.add("Gender: " + (gender != null ? gender : "Campur"));
        details.add("Tipe Kamar: " + (roomType != null ? roomType : "Standard"));
        return details;
    }

    @Override
    public String toJson() {
        return "{" + buildBaseJson() + ","
                + "\"gender\":\"" + escapeJson(gender) + "\","
                + "\"roomType\":\"" + escapeJson(roomType) + "\""
                + "}";
    }
}





