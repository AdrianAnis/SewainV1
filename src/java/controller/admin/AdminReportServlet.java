package controller.admin;

import model.User;
import model.Admin;
import model.Report;
import model.Property;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/*
  ALTER TABLE properties 
  ADD COLUMN flagCount INT NOT NULL DEFAULT 0;
*/
@WebServlet(name = "AdminReportServlet", urlPatterns = {"/admin/reports"})
public class AdminReportServlet extends HttpServlet {

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
        List<Report> list = adminUser.viewAllReports();
        request.setAttribute("reports", list);

        request.getRequestDispatcher("/pages/admin/handle_report.jsp").forward(request, response);
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
        model.ActivityLog logModel = new model.ActivityLog();
        int adminId = 0;
        try {
            adminId = Integer.parseInt(currentUser.getUserId());
        } catch (Exception ignored) {}

        if ("resolveReport".equalsIgnoreCase(action)) {
            String reportIdParam = request.getParameter("reportId");
            if (reportIdParam == null) {
                response.getWriter().write("{\"success\": false, \"message\": \"Parameter tidak lengkap.\"}");
                return;
            }

            int reportId = Integer.parseInt(reportIdParam);
            model.Admin admin = (model.Admin) currentUser;
            Report report = admin.getReportById(reportId);
            
            boolean success = false;
            if (report != null) {
                success = admin.handleReport(report, "Resolved");
            }

            if (success) {
                String desc = "Admin " + currentUser.getName() + " menyelesaikan laporan ID: " + reportId;
                logModel.addLog(adminId, "RESOLVE REPORT", desc);
                response.getWriter().write("{\"success\": true}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Gagal memperbarui status laporan.\"}");
            }

        } else if ("flagProperty".equalsIgnoreCase(action)) {
            String propertyIdParam = request.getParameter("propertyId");
            String reportIdParam = request.getParameter("reportId");
            String reason = request.getParameter("reason");

            if (propertyIdParam == null || reason == null || reason.trim().isEmpty()) {
                response.getWriter().write("{\"success\": false, \"message\": \"Parameter tidak lengkap.\"}");
                return;
            }

            int propertyId = Integer.parseInt(propertyIdParam);
            model.Admin admin = (model.Admin) currentUser;
            Property prop = admin.getPropertyById(propertyId);

            if (prop == null) {
                response.getWriter().write("{\"success\": false, \"message\": \"Properti tidak ditemukan.\"}");
                return;
            }

            model.Flag newFlag = admin.flagProperty(prop, reason);
            boolean success = (newFlag != null);
            if (success) {
                admin.incrementPropertyFlagCount(propertyId, reason);
            }
            if (success) {
                if (reportIdParam != null && !reportIdParam.isEmpty()) {
                    try {
                        int reportId = Integer.parseInt(reportIdParam);
                        Report report = admin.getReportById(reportId);
                        if (report != null) {
                            admin.handleReport(report, "Resolved");
                        }
                    } catch (Exception ignored) {}
                }

                String desc = "Admin " + currentUser.getName() + " menandai (flagged) properti: " + prop.getName() + " (ID: " + propertyId + ") karena: " + reason;
                logModel.addLog(adminId, "FLAG PROPERTY", desc);
                response.getWriter().write("{\"success\": true}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Gagal menandai properti di database.\"}");
            }
        } else {
            response.getWriter().write("{\"success\": false, \"message\": \"Aksi tidak dikenal.\"}");
        }
    }
}