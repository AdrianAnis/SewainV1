package controller.admin;

import model.User;
import model.Admin;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminUserServlet", urlPatterns = { "/admin/users" })
public class AdminUserServlet extends HttpServlet {

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

        Admin adminUser = (Admin) currentUser;
        List<User> list = adminUser.viewAllUsers();
        request.setAttribute("users", list);

        request.getRequestDispatcher("/pages/admin/manage_user.jsp").forward(request, response);
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
        if ("toggleStatus".equalsIgnoreCase(action)) {
            String userId = request.getParameter("userId");
            String status = request.getParameter("status");

            if (userId == null || status == null) {
                response.getWriter().write("{\"success\": false, \"message\": \"Parameter tidak lengkap.\"}");
                return;
            }

            Admin adminUser = (Admin) currentUser;
            User targetUser = adminUser.getUserById(userId);
            if (targetUser == null) {
                response.getWriter().write("{\"success\": false, \"message\": \"User tidak ditemukan.\"}");
                return;
            }

            if (targetUser.getUserId().equals(currentUser.getUserId())) {
                response.getWriter()
                        .write("{\"success\": false, \"message\": \"Tidak dapat menangguhkan akun sendiri.\"}");
                return;
            }

            Admin admin = (Admin) currentUser;
            String manageAction = "Suspended".equalsIgnoreCase(status) ? "suspend" : "activate";
            boolean success = admin.manageUser(targetUser, manageAction);
            if (success) {

                model.ActivityLog logModel = new model.ActivityLog();
                String actionName = "Suspended".equalsIgnoreCase(status) ? "SUSPEND USER" : "ACTIVATE USER";
                String description = currentUser.getName() + " mengubah status " + targetUser.getName()
                        + " menjadi " + status;

                try {
                    int adminId = Integer.parseInt(currentUser.getUserId());
                    logModel.addLog(adminId, actionName, description);
                } catch (Exception ignored) {
                }

                response.getWriter().write("{\"success\": true}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Gagal memperbarui database.\"}");
            }
        } else {
            response.getWriter().write("{\"success\": false, \"message\": \"Aksi tidak dikenal.\"}");
        }
    }
}
