package controller.owner;

import DAO.ReportDAO;
import model.Report;
import model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ReportOwnerServlet", urlPatterns = {"/owner/reports"})
public class ReportOwnerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userSession") == null) {
            response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("userSession");
        if (!"Owner".equalsIgnoreCase(currentUser.getRole()) && !"Admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp");
            return;
        }

        int ownerId = 1;
        try {
            ownerId = Integer.parseInt(currentUser.getUserId());
        } catch (Exception e) {}

        ReportDAO reportDAO = new ReportDAO();
        List<Report> reports = reportDAO.getReportsByOwnerId(ownerId);

        request.setAttribute("reports", reports);
        request.getRequestDispatcher("/pages/owner/report_owner.jsp").forward(request, response);
    }
}