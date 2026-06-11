/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Lenovo
 */
public class Admin extends User {

    public Admin() {
        super();
    }

    public Admin(String userId, String name, String email, String password, String phone, String role) {
        super(userId, name, email, password, phone, role);
    }

    public void manageUser() {
        System.out.println("Mengelola user");
    }

    public void verifyProperty() {
        System.out.println("Memverifikasi property");
    }

    public void monitorActivity() {
        System.out.println("Monitoring aktivitas");
    }

    public void handleReport() {
        System.out.println("Menangani laporan");
    }

    public void flagProperty() {
        System.out.println("Memberikan flag property");
    }
}
