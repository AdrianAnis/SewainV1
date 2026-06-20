package controller.tenant;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.OwnerRequest;
import model.User;

@WebServlet("/owner-request-status")
public class GetOwnerRequestStatusServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userSession") == null) {
            response.getWriter().write("{\"hasRequest\": false}");
            return;
        }

        User currentUser = (User) session.getAttribute("userSession");
        
        
        OwnerRequest latestReq = OwnerRequest.getLatestStatusForTenant(currentUser.getUserId());

        if (latestReq == null) {
            response.getWriter().write("{\"hasRequest\": false}");
        } else {
            
            if ("approved".equals(latestReq.getStatus()) && "Tenant".equalsIgnoreCase(currentUser.getRole())) {
                User newOwner = new model.Owner(
                    currentUser.getUserId(),
                    currentUser.getName(),
                    currentUser.getEmail(),
                    currentUser.getPassword(),
                    currentUser.getPhone(),
                    "Owner"
                );
                session.setAttribute("userSession", newOwner);
                session.setAttribute("roleSession", "tenant"); 
            }

            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"hasRequest\": true, ");
            json.append("\"status\": \"").append(escapeJson(latestReq.getStatus())).append("\", ");
            json.append("\"reason\": \"").append(escapeJson(latestReq.getReason())).append("\", ");
            json.append("\"rejectReason\": \"").append(latestReq.getRejectReason() != null ? escapeJson(latestReq.getRejectReason()) : "").append("\", ");
            json.append("\"date\": \"").append(latestReq.getDate().toString()).append("\"");
            json.append("}");

            response.getWriter().write(json.toString());
        }
    }

    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\b", "\\b")
                  .replace("\f", "\\f")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
}
