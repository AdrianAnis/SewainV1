package controller.tenant;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.*;
import model.Tenant;
import DAO.PropertyDAO;

@WebServlet(name = "WishlistController", urlPatterns = { "/wishlist", "/wishlist-properties" })
public class WishlistController extends HttpServlet {

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
            if ("/wishlist-properties".equals(request.getServletPath())) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.setContentType("application/json");
                response.getWriter().write("{\"error\":\"Unauthorized\"}");
            } else {
                response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp");
            }
            return;
        }

        User user = (User) session.getAttribute("userSession");

        if (user instanceof Tenant) {
            ((Tenant) user).addToWishlist();
        }

        if (!"/wishlist-properties".equals(request.getServletPath())) {
            if ("owner".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/pages/owner/dashboard_owner.jsp");
                return;
            } else if ("admin".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/pages/admin/dashboard_admin.jsp");
                return;
            }
        }

        if ("/wishlist-properties".equals(request.getServletPath())) {
            String idsParam = request.getParameter("ids");
            List<Integer> ids = new ArrayList<>();
            if (idsParam != null && !idsParam.trim().isEmpty()) {
                String[] parts = idsParam.split(",");
                for (String part : parts) {
                    try {
                        String cleanId = part.trim();
                        if (cleanId.toUpperCase().startsWith("PROP-")) {
                            cleanId = cleanId.substring(5);
                        }
                        ids.add(Integer.parseInt(cleanId));
                    } catch (NumberFormatException ignored) {
                    }
                }
            }

            List<Property> properties = propertyDAO.getPropertiesByIds(ids);
            String json = convertToJson(properties);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            try (PrintWriter out = response.getWriter()) {
                out.print(json);
            }
        } else {
            request.getRequestDispatcher("/pages/tenant/wishlist.jsp").forward(request, response);
        }
    }

    private String convertToJson(List<Property> list) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            Property p = list.get(i);
            sb.append("{");
            sb.append("\"propertyId\":").append(p.getPropertyId()).append(",");
            sb.append("\"name\":\"").append(escapeJson(p.getName())).append("\",");
            sb.append("\"location\":\"").append(escapeJson(p.getLocation())).append("\",");
            sb.append("\"price\":").append(p.getPrice()).append(",");
            sb.append("\"propertyType\":\"").append(escapeJson(p.getPropertyType())).append("\",");
            sb.append("\"availability\":").append(p.isAvailability() ? 1 : 0).append(",");
            sb.append("\"verificationStatus\":\"").append(escapeJson(p.getVerificationStatus())).append("\",");
            sb.append("\"photos\":\"").append(escapeJson(p.getPhotos())).append("\",");
            sb.append("\"description\":\"").append(escapeJson(p.getDescription())).append("\",");

            if (p instanceof Kost) {
                Kost k = (Kost) p;
                sb.append("\"gender\":\"").append(escapeJson(k.getGender())).append("\",");
                sb.append("\"roomType\":\"").append(escapeJson(k.getRoomType())).append("\",");
            } else if (p instanceof Rumah) {
                Rumah r = (Rumah) p;
                sb.append("\"jumlahKamar\":").append(r.getJumlahKamar()).append(",");
                sb.append("\"luasTanah\":").append(r.getLuasTanah()).append(",");
            } else if (p instanceof Kontrakan) {
                Kontrakan ko = (Kontrakan) p;
                sb.append("\"jumlahKamar\":").append(ko.getJumlahKamar()).append(",");
                sb.append("\"durasiMinimum\":").append(ko.getDurasiMinimum()).append(",");
            } else if (p instanceof Apartement) {
                Apartement a = (Apartement) p;
                sb.append("\"lantai\":").append(a.getLantai()).append(",");
                sb.append("\"nomorUnit\":\"").append(escapeJson(a.getNomorUnit())).append("\",");
                sb.append("\"tipeUnit\":\"").append(escapeJson(a.getTipeUnit())).append("\",");
            }

            sb.append("\"facilities\":[");
            String facStr = p.getFacilities();
            if (facStr != null && !facStr.trim().isEmpty()) {
                String[] facs = facStr.split(",");
                for (int k = 0; k < facs.length; k++) {
                    sb.append("\"").append(escapeJson(facs[k].trim())).append("\"");
                    if (k < facs.length - 1)
                        sb.append(",");
                }
            }
            sb.append("],");

            double price = p.getPrice();
            String priceLabel = "";
            if (price >= 1000000) {
                double priceJt = price / 1000000.0;
                if (priceJt == (long) priceJt) {
                    priceLabel = "Rp " + (long) priceJt + " jt/bln";
                } else {
                    priceLabel = "Rp " + priceJt + " jt/bln";
                }
            } else {
                priceLabel = "Rp " + (long) price + "/bln";
            }
            sb.append("\"priceLabel\":\"").append(escapeJson(priceLabel)).append("\"");

            sb.append("}");
            if (i < list.size() - 1)
                sb.append(",");
        }
        sb.append("]");
        return sb.toString();
    }

    private String escapeJson(String s) {
        if (s == null)
            return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\b", "\\b")
                .replace("\f", "\\f")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
