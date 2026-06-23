    package controller.auth;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/logout")
public class LogoutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null) {
            try {
                model.User currentUser = (model.User) session.getAttribute("userSession");
                if (currentUser != null) {
                    model.ActivityLog.recordLog(Integer.parseInt(currentUser.getUserId()), "LOGOUT", currentUser.getName() + " logout dari sistem");
                }
            } catch (Exception ignored) {}
            session.invalidate();
        }
        
        response.sendRedirect(request.getContextPath() + "/login");
    }
}
