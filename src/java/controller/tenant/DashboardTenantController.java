package controller.tenant;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.*;
import model.Tenant;

@WebServlet("/landing")
public class DashboardTenantController extends HttpServlet {

    private DAO.PropertyDAO propertyDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        propertyDAO = new DAO.PropertyDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userSession") == null) {
            // User is not logged in, redirect to login page
            response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("userSession");
        
        // PBO: Panggil viewProperty() pada objek Tenant untuk OOP compliance
        if (user instanceof Tenant) {
            ((Tenant) user).viewProperty();
        }
        
        // If user is Admin, redirect to their dashboard page
        if ("admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/pages/admin/dashboard_admin.jsp");
            return;
        }

        // Fetch default property list (all)
        List<Property> properties = propertyDAO.searchProperties(null, null, null, null);
        String json = convertToJson(properties);
        request.setAttribute("propertiesJson", json);

        // Otherwise, serve the tenant dashboard
        request.getRequestDispatcher("/pages/tenant/dashboard.jsp").forward(request, response);
    }

    private String convertToJson(List<Property> list) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            sb.append(list.get(i).toJson());
            if (i < list.size() - 1) {
                sb.append(",");
            }
        }
        sb.append("]");
        return sb.toString();
    }
}
