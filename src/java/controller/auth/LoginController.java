/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.auth;
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
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/pages/auth/login.jsp").forward(request, response);
    }

   
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String emailOrUsername = request.getParameter("email_or_username");
        String passwordInput = request.getParameter("password");

        User currentUser = User.login(emailOrUsername, passwordInput);

        if (currentUser != null) {
            if ("Suspended".equalsIgnoreCase(currentUser.getStatus())) {
                request.setAttribute("errorMsg", "Akun Anda telah ditangguhkan. Silakan hubungi Admin.");
                request.getRequestDispatcher("/pages/auth/login.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession();
            session.setAttribute("userSession", currentUser);
            session.setAttribute("roleSession", currentUser.getRole());

            String role = currentUser.getRole();
            if ("Admin".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else if ("Owner".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/owner/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/landing"); 
            }
        } else {
            request.setAttribute("errorMsg", "Email/Username atau Password Anda salah!");
            request.getRequestDispatcher("/pages/auth/login.jsp").forward(request, response);
        }
    }
}
