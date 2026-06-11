/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package database;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author Lenovo
 */
public class DatabaseConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/isi nama db nanti ya";
    private static final String USER = "root";
    private static final String PASSWORD = "";
    
    public static Connection getConnection() {
        Connection conn = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Koneksi berhasil!");
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("Koneksi gagal!");
            e.printStackTrace();
        }
        
        return conn;
    }
}

