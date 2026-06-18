package controller.auth;

import model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/switch-role")
public class SwitchRoleController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("userSession");
        
        if (currentUser != null) {
            String currentRole = currentUser.getRole();
            
            if ("Tenant".equalsIgnoreCase(currentRole)) {
                currentUser.setRole("Owner");
            } else if ("Owner".equalsIgnoreCase(currentRole)) {
                currentUser.setRole("Tenant");
            }
            
            // Simpan perubahan kembali ke session
            session.setAttribute("userSession", currentUser);
            
            // Redirect ke Controller resmi, BUKAN ke file fisik JSP langsung!
            if ("Owner".equalsIgnoreCase(currentUser.getRole())) {
                response.sendRedirect(request.getContextPath() + "/owner/dashboard");
                return;
            } else {
                response.sendRedirect(request.getContextPath() + "/landing");
                return;
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp");
    }
}
