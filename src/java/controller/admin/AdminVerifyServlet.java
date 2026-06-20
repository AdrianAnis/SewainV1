package controller.admin;

import DAO.PropertyDAO;
import model.User;
import model.Property;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminVerifyServlet", urlPatterns = {"/admin/verify"})
public class AdminVerifyServlet extends HttpServlet {

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

        List<Property> list = ((model.Admin) currentUser).viewPendingProperties();
        request.setAttribute("pendingProperties", list);

        request.getRequestDispatcher("/pages/admin/verify_property.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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

        int propertyId = 0;
        try {
            propertyId = Integer.parseInt(propertyIdParam);
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\": false, \"message\": \"ID Properti tidak valid.\"}");
            return;
        }

        Property prop = ((model.Admin) currentUser).getPropertyById(propertyId);
        if (prop == null) {
            response.getWriter().write("{\"success\": false, \"message\": \"Properti tidak ditemukan.\"}");
            return;
        }

        boolean success = false;
        model.ActivityLog logModel = new model.ActivityLog();
        int adminId = 0;
        try {
            adminId = Integer.parseInt(currentUser.getUserId());
        } catch (Exception ignored) {}

        if ("approve".equalsIgnoreCase(action)) {
            success = ((model.Admin) currentUser).verifyProperty(prop, "Approved");
            if (success) {
                String desc = "Admin " + currentUser.getName() + " menyetujui properti: " + prop.getName() + " (ID: " + propertyId + ")";
                logModel.addLog(adminId, "VERIFY PROPERTY", desc);
            }
        } else if ("reject".equalsIgnoreCase(action)) {
            String reason = request.getParameter("reason");
            if (reason == null || reason.trim().isEmpty()) {
                reason = "Tidak ada alasan spesifik";
            }
            success = ((model.Admin) currentUser).verifyProperty(prop, "Rejected");
            if (success) {
                String desc = "Admin " + currentUser.getName() + " menolak properti: " + prop.getName() + " (ID: " + propertyId + ") karena: " + reason;
                logModel.addLog(adminId, "VERIFY PROPERTY", desc);
            }
        }

        if (success) {
            response.getWriter().write("{\"success\": true}");
        } else {
            response.getWriter().write("{\"success\": false, \"message\": \"Gagal memperbarui status verifikasi di database.\"}");
        }
    }
}