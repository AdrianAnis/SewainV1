package controller.auth;

import DAO.UserDAO;
import DAO.UserDAOImpl;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.User;

@WebServlet("/upgrade")
public class UpgradeController extends HttpServlet {

    private final UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userSession") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("userSession");

        boolean success = userDAO.upgradeToOwner(currentUser.getUserId());

        if (success) {
            currentUser.setRole("owner");
            session.setAttribute("userSession", currentUser);
            session.setAttribute("roleSession", "owner");

            response.sendRedirect(request.getContextPath() + "/pages/owner/dashboard_owner.jsp");
        } else {
            session.setAttribute("errorMsg", "Gagal melakukan upgrade akun menjadi Owner. Silakan coba lagi.");
            response.sendRedirect(request.getContextPath() + "/landing");
        }
    }
}
