package controller.admin;

import DAO.ActivityLogDAO;
import model.User;
import model.ActivityLog;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminActivityServlet", urlPatterns = {"/admin/activity"})
public class AdminActivityServlet extends HttpServlet {

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

        String actionType = request.getParameter("actionType");
        String date = request.getParameter("date");

        // Set default filter if 'all' is passed
        if ("all".equalsIgnoreCase(actionType)) {
            actionType = null;
        }

        ActivityLogDAO logDAO = new ActivityLogDAO();
        List<ActivityLog> list = logDAO.getLogs(actionType, date);
        request.setAttribute("logs", list);

        request.getRequestDispatcher("/pages/admin/activity_log.jsp").forward(request, response);
    }
}
