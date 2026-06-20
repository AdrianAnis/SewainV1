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
            
            
            if ("Owner".equalsIgnoreCase(currentRole)) {
                String currentRoleSession = (String) session.getAttribute("roleSession");
                
                if ("tenant".equalsIgnoreCase(currentRoleSession)) {
                    
                    session.setAttribute("roleSession", "owner");
                    response.sendRedirect(request.getContextPath() + "/owner/dashboard");
                } else {
                    
                    session.setAttribute("roleSession", "tenant");
                    response.sendRedirect(request.getContextPath() + "/landing");
                }
                return;
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp");
    }
}
