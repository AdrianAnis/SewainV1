package controller.tenant;

import DAO.ReportDAO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.User;

@WebServlet(name = "ReportHistoryController", urlPatterns = {"/report-history"})
public class ReportHistoryController extends HttpServlet {

    private ReportDAO reportDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        reportDAO = new ReportDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userSession") == null) {
            response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("userSession");

        int userId = Integer.parseInt(currentUser.getUserId());
        List<Object[]> rows = reportDAO.getReportRowsByTenantId(userId);

        request.setAttribute("reportRows", rows);
        request.getRequestDispatcher("/pages/tenant/report_history.jsp").forward(request, response);
    }
}