package controller.admin;

import model.User;
import model.Admin;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userSession") == null) {
            response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("userSession");
        if (!"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/landing");
            return;
        }

        Admin adminUser = (Admin) currentUser;
        
        int totalUsers = adminUser.getTotalUsersCount();
        int totalProperties = adminUser.getTotalPropertyCount();
        int pendingVerifications = adminUser.getPendingPropertyCount();
        int pendingReports = adminUser.getPendingReportsCount();

        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalProperties", totalProperties);
        request.setAttribute("pendingVerificationsCount", pendingVerifications);
        request.setAttribute("pendingReportsCount", pendingReports);

        java.util.List<model.ActivityLog> activityLogs = model.ActivityLog.getAllLogs();
        request.setAttribute("activityLogs", activityLogs);

        request.getRequestDispatcher("/pages/admin/dashboard_admin.jsp").forward(request, response);
    }
}   