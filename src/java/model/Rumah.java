/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Lenovo
 */
public class Rumah extends Property {

    private int jumlahKamar;
    private double luasTanah;
    public Rumah() {
        super();
    }

    public Rumah(int propertyId, String name, String location, double price, String propertyType,
                 boolean availability, String verificationStatus, String flagStatus, String photos,
                 String description, String facilities,
                 int jumlahKamar, double luasTanah) {
        super(propertyId, name, location, price, propertyType, availability, verificationStatus, flagStatus, photos, description, facilities);
        this.jumlahKamar = jumlahKamar;
        this.luasTanah = luasTanah;
    }

    public int getJumlahKamar() {
        return jumlahKamar;
    }

    public void setJumlahKamar(int jumlahKamar) {
        this.jumlahKamar = jumlahKamar;
    }

    public double getLuasTanah() {
        return luasTanah;
    }

    public void setLuasTanah(double luasTanah) {
        this.luasTanah = luasTanah;
    }

    @Override
    public java.util.List<String> getSpecificDetails() {
        java.util.List<String> details = new java.util.ArrayList<>();
        details.add("Kamar Tidur: " + jumlahKamar);
        details.add("Luas Tanah: " + luasTanah + " m²");
        return details;
    }

    @Override
    public String toJson() {
        return "{" + buildBaseJson() + ","
                + "\"jumlahKamar\":" + jumlahKamar + ","
                + "\"luasTanah\":" + luasTanah
                + "}";
    }
}

