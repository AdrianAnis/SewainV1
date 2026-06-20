package controller.admin;

import DAO.PropertyDAO;
import model.User;
import model.Property;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminFlagServlet", urlPatterns = { "/admin/flagged" })
public class AdminFlagServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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

        PropertyDAO propertyDAO = new PropertyDAO();
        List<Property> list = propertyDAO.getFlaggedProperties();
        request.setAttribute("flaggedProperties", list);

        request.getRequestDispatcher("/pages/admin/flag_property.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userSession") == null) {
            response.getWriter().write("{\"success\": false, \"message\": \"Sesi tidak valid.\"}");
            return;
        }

        User currentUser = (User) session.getAttribute("userSession");
        if (!"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.getWriter().write("{\"success\": false, \"message\": \"Akses ditolak.\"}");
            return;
        }

        String action = request.getParameter("action");
        String propertyIdParam = request.getParameter("propertyId");

        if (action == null || propertyIdParam == null) {
            response.getWriter().write("{\"success\": false, \"message\": \"Parameter tidak lengkap.\"}");
            return;
        }

        int propertyId = Integer.parseInt(propertyIdParam);
        PropertyDAO propertyDAO = new PropertyDAO();
        Property prop = propertyDAO.getPropertyById(propertyId);

        if (prop == null) {
            response.getWriter().write("{\"success\": false, \"message\": \"Properti tidak ditemukan.\"}");
            return;
        }

        model.ActivityLog logModel = new model.ActivityLog();
        int adminId = 0;
        try {
            adminId = Integer.parseInt(currentUser.getUserId());
        } catch (Exception ignored) {
        }

        boolean success = false;
        if ("unflagProperty".equalsIgnoreCase(action)) {
            success = propertyDAO.updateFlagStatus(propertyId, "None", null);
            if (success) {
                
                model.Flag flagModel = new model.Flag();
                flagModel.removeFlag(propertyId);

                String desc = "Admin " + currentUser.getName() + " mencabut flag pada properti: " + prop.getName()
                        + " (ID: " + propertyId + ")";
                logModel.addLog(adminId, "UNFLAG PROPERTY", desc);
            }
        } else if ("deleteProperty".equalsIgnoreCase(action)) {
            success = ((model.Admin) currentUser).deleteProperty(propertyId);
            if (success) {
                String desc = "Admin " + currentUser.getName() + " menghapus properti secara permanen: "
                        + prop.getName() + " (ID: " + propertyId + ")";
                logModel.addLog(adminId, "DELETE PROPERTY", desc);
            }
        }

        if (success) {
            response.getWriter().write("{\"success\": true}");
        } else {
            response.getWriter().write("{\"success\": false, \"message\": \"Gagal memproses aksi di database.\"}");
        }
    }
}
