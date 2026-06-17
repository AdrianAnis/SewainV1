package controller.owner;

import DAO.PropertyDAO;
import model.Property;
import model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "DetailOwnerServlet", urlPatterns = { "/owner/detail" })
public class DetailOwnerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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

        String idParam = request.getParameter("propertyId");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/pages/owner/dashboard_owner.jsp");
            return;
        }

        int propertyId;
        try {
            propertyId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/pages/owner/dashboard_owner.jsp");
            return;
        }

        int ownerId = 1;
        try {
            ownerId = Integer.parseInt(currentUser.getUserId());
        } catch (Exception e) {
        }

        PropertyDAO dao = new PropertyDAO();
        Property property = dao.getPropertyById(propertyId);

        if (property == null || property.getOwnerId() != ownerId) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Anda tidak memiliki akses untuk melihat properti ini.");
            return;
        }

        request.setAttribute("property", property);
        request.getRequestDispatcher("/pages/owner/detail_owner.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}