package controller.tenant;

import DAO.ReportDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Report;
import model.User;
import model.Tenant;

@WebServlet("/submit-report")
public class SubmitReportController extends HttpServlet {

    private ReportDAO reportDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        reportDAO = new ReportDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userSession") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Sesi Anda telah berakhir. Silakan login kembali.\"}");
            return;
        }

        User user = (User) session.getAttribute("userSession");
        
        if (user instanceof Tenant) {
            ((Tenant) user).reportProperty();
        }
        
        String propertyIdStr = request.getParameter("propertyId");
        String issueType = request.getParameter("issueType");
        String description = request.getParameter("description");

        if (propertyIdStr == null || propertyIdStr.trim().isEmpty() ||
            issueType == null || issueType.trim().isEmpty() ||
            description == null || description.trim().isEmpty()) {
            
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Semua field wajib diisi!\"}");
            return;
        }

        try {
            int propertyId = Integer.parseInt(propertyIdStr);
            int tenantId = Integer.parseInt(user.getUserId());

            Report report = new Report(propertyId, tenantId, issueType, description);
            
            report.submitReport();

            boolean success = reportDAO.insertReport(report);
            if (success) {
                response.getWriter().write("{\"status\":\"success\",\"message\":\"Laporan penipuan berhasil dikirim. Tim admin akan segera menginvestigasi!\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Gagal mengirim laporan ke database.\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Format ID properti tidak valid.\"}");
        }
    }
}