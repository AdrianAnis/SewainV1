package controller.tenant;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.*;

@WebServlet("/search")
public class SearchPropertyController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("search_property_name");
        String location = request.getParameter("search_location");
        String price = request.getParameter("price");
        String type = request.getParameter("type");

        List<Property> properties = model.Property.searchProperties(name, location, price, type);

        String json = convertToJson(properties);

        request.setAttribute("propertiesJson", json);

        request.getRequestDispatcher("/pages/tenant/dashboard.jsp").forward(request, response);
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
