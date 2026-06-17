/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Lenovo
 */


public class Owner extends User {

    public Owner() {
        super();
    }

    public Owner(String userId, String name, String email, String password, String phone, String role) {
        super(userId, name, email, password, phone, role);
    }

    public void viewReport() {
        System.out.println("[Owner] " + getName() + " (ID: " + getUserId() + ") melihat daftar laporan keluhan masuk.");
    }

    public void addProperty(String propertyName) {
        System.out.println("[Owner] " + getName() + " (ID: " + getUserId() + ") mendaftarkan properti baru: " + propertyName);
    }


    public void viewProperty() {
        System.out.println("[Owner] " + getName() + " (ID: " + getUserId() + ") melihat daftar properti miliknya.");
    }

    public void editProperty(int propertyId) {
        System.out.println("[Owner] " + getName() + " (ID: " + getUserId() + ") mengubah data properti ID: " + propertyId);
    }

    public void deleteProperty(int propertyId) {
        System.out.println("[Owner] " + getName() + " (ID: " + getUserId() + ") menghapus properti  ID: " + propertyId);
    }
}
