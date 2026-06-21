package controller.tenant;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet({ "/get-property-names", "/getPropertyNames" })
public class GetPropertyNamesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String query = request.getParameter("q");
        if (query == null) {
            query = request.getParameter("query");
        }

        List<String> names = model.Property.autocompletePropertyNames(query);

        String json = convertListToJson(names);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(json);
    }

    private String convertListToJson(List<String> list) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            sb.append("\"").append(escapeJson(list.get(i))).append("\"");
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
