package controller.tenant;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.User;

@WebServlet(name = "ReportHistoryController", urlPatterns = { "/report-history" })
public class ReportHistoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userSession") == null) {
            response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("userSession");

        String roleSession = (String) session.getAttribute("roleSession");
        boolean isViewingAsTenant = "tenant".equalsIgnoreCase(roleSession) || "Tenant".equalsIgnoreCase(currentUser.getRole());

        if ("admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/pages/admin/dashboard_admin.jsp");
            return;
        } else if (!isViewingAsTenant) {
            response.sendRedirect(request.getContextPath() + "/pages/owner/dashboard_owner.jsp");
            return;
        }

        model.Tenant dummyTenant = new model.Tenant();
        dummyTenant.setUserId(currentUser.getUserId());
        List<Object[]> rows = dummyTenant.viewReportHistory();

        request.setAttribute("reportRows", rows);
        request.getRequestDispatcher("/pages/tenant/report_history.jsp").forward(request, response);
    }
}
