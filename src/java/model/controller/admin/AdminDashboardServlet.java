package controller.admin;

import DAO.UserDAOImpl;
import DAO.PropertyDAO;
import DAO.ReportDAO;
import model.User;
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

        UserDAOImpl userDAO = new UserDAOImpl();
        PropertyDAO propertyDAO = new PropertyDAO();
        ReportDAO reportDAO = new ReportDAO();

        int totalUsers = userDAO.getAllUsers().size();
        int totalProperties = propertyDAO.getTotalPropertyCount();
        int pendingVerifications = propertyDAO.getPendingPropertyCount();
        int pendingReports = reportDAO.getPendingReportsCount();

        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalProperties", totalProperties);
        request.setAttribute("pendingVerificationsCount", pendingVerifications);
        request.setAttribute("pendingReportsCount", pendingReports);

        request.getRequestDispatcher("/pages/admin/dashboard_admin.jsp").forward(request, response);
    }
}   