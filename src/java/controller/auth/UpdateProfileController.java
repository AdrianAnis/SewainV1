package controller.auth;

import DAO.UserDAO;
import DAO.UserDAOImpl;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.User;

@WebServlet(name = "UpdateProfileController", urlPatterns = {"/profile"})
public class UpdateProfileController extends HttpServlet {

    private final UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userSession") == null) {
            response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp");
            return;
        }
        request.getRequestDispatcher("/pages/components/profile.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userSession") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            try (PrintWriter out = response.getWriter()) {
                out.print("{\"success\":false,\"message\":\"Sesi tidak ditemukan.\"}");
            }
            return;
        }

        User currentUser = (User) session.getAttribute("userSession");
        String name  = request.getParameter("name")  != null ? request.getParameter("name").trim()  : "";
        String phone = request.getParameter("phone") != null ? request.getParameter("phone").trim() : "";

        if (name.isEmpty()) {
            try (PrintWriter out = response.getWriter()) {
                out.print("{\"success\":false,\"message\":\"Nama tidak boleh kosong.\"}");
            }
            return;
        }
        
        String oldName = currentUser.getName();
        String oldPhone = currentUser.getPhone();

        currentUser.setName(name);
        currentUser.setPhone(phone);

        boolean success = userDAO.updateProfile(currentUser);

        if (success) {
            session.setAttribute("userSession", currentUser);
            try (PrintWriter out = response.getWriter()) {
                out.print("{\"success\":true,\"message\":\"Profil berhasil diperbarui!\",\"name\":\""
                        + escapeJson(name) + "\"}");
            }
        } else {
            currentUser.setName(oldName);
            currentUser.setPhone(oldPhone);
            try (PrintWriter out = response.getWriter()) {
                out.print("{\"success\":false,\"message\":\"Gagal memperbarui profil.\"}");
            }
        }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
