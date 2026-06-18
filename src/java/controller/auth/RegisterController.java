/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.auth;
import DAO.UserDAO;
import DAO.UserDAOImpl;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.User;
import model.Tenant;
/**
 *
 * @author Lenovo
 */
@WebServlet("/register")
public class RegisterController extends HttpServlet {

    private final UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/pages/auth/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String usernameInput = request.getParameter("username");
        String emailInput = request.getParameter("email");
        String passwordInput = request.getParameter("password");
        String phoneInput = request.getParameter("phone");
        User newUser = new Tenant();
        
        newUser.setName(usernameInput);
        newUser.setEmail(emailInput);
        newUser.setPassword(passwordInput);
        newUser.setPhone(phoneInput);
        newUser.setRole("tenant"); 

        boolean isSuccess = userDAO.registerUser(newUser);

        if (isSuccess) {
            request.setAttribute("successMsg", "Akun berhasil dibuat! Silakan masuk.");
            request.getRequestDispatcher("/pages/auth/login.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMsg", "Pendaftaran gagal! Username atau Email sudah terdaftar.");
            request.getRequestDispatcher("/pages/auth/register.jsp").forward(request, response);
        }
    }
}
