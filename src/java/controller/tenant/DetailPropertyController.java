package controller.tenant;

import DAO.PropertyDAO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Property;
import model.User;
import model.Tenant;

@WebServlet(name = "DetailPropertyController", urlPatterns = { "/property/detail" })
public class DetailPropertyController extends HttpServlet {

    private PropertyDAO propertyDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        propertyDAO = new PropertyDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userSession") == null) {
            response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("userSession");

        List<Property> properties;
        if (user instanceof Tenant) {
            properties = ((Tenant) user).viewProperty();
        } else {
            properties = propertyDAO.searchProperties(null, null, null, null);
        }
        request.setAttribute("propertiesList", properties);

        request.getRequestDispatcher("/pages/tenant/detail.jsp").forward(request, response);
    }
}
