/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;
import java.util.List;
import model.User;

/**
 *
 * @author Lenovo
 */
public interface UserDAO {
    List<User> getAllUsers(); 
    User getUserById(String userId);
    User getUserByEmail(String email);
    boolean addUser(User user);
    boolean updateUser(User user);
    boolean suspendUser(String userId);
    boolean activateUser(String userId);
    boolean updateProfile(User user);

    boolean registerUser(User user);
    User loginUser(String emailOrUsername, String password);
    boolean upgradeToOwner(String userId); 
    boolean updateUserStatus(String userId, String status);
}
