package controller.owner;

import DAO.PropertyDAO;
import DAO.ReportDAO;
import model.Owner;
import model.Property;
import model.Report;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/owner/dashboard")
public class OwnerDashboardController extends HttpServlet {

    private PropertyDAO propertyDAO;
    private ReportDAO reportDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        propertyDAO = new PropertyDAO();
        reportDAO = new ReportDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userSession") == null) {
            response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("userSession");

        if (!(currentUser instanceof Owner)) {
            response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp");
            return;
        }

        List<Property> properties = ((Owner) currentUser).viewProperty();
        List<Report> ownerReports = ((Owner) currentUser).viewReport();
        
        request.setAttribute("ownerProperties", properties);

        int pendingReportsCount = 0;
        try {
            if (ownerReports != null) {
                for (Report r : ownerReports) {
                    if ("Pending".equalsIgnoreCase(r.getStatus())) {
                        pendingReportsCount++;
                    }
                }
            }
        } catch (Exception e) {}
        request.setAttribute("pendingReportsCount", pendingReportsCount);

        request.getRequestDispatcher("/pages/owner/dashboard_owner.jsp").forward(request, response);
    }
}