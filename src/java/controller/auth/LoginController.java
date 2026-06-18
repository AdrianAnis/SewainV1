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
import javax.servlet.http.HttpSession;
import model.User;

/**
 *
 * @author Lenovo
 */
@WebServlet("/login")
public class LoginController extends HttpServlet {

    private final UserDAO userDAO = new UserDAOImpl();

    // doGet bertugas menampilkan halaman form login saat URL diakses
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/pages/auth/login.jsp").forward(request, response);
    }

    // doPost bertugas memeriksa kecocokan akun saat user menekan tombol Sign In
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String emailOrUsername = request.getParameter("email_or_username");
        String passwordInput = request.getParameter("password");

        User currentUser = userDAO.loginUser(emailOrUsername, passwordInput);

        if (currentUser != null) {
            HttpSession session = request.getSession();
            session.setAttribute("userSession", currentUser);
            session.setAttribute("roleSession", currentUser.getRole());

            String role = currentUser.getRole();
            if ("Admin".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else if ("Owner".equalsIgnoreCase(role)) {
                response.sendRedirect("pages/owner/dashboard_owner.jsp");
            } else {
                response.sendRedirect("landing"); 
            }
        } else {
            request.setAttribute("errorMsg", "Email/Username atau Password Anda salah!");
            request.getRequestDispatcher("/pages/auth/login.jsp").forward(request, response);
        }
    }
}
