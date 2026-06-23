package controller.admin;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.OwnerRequest;
import model.User;

@WebServlet("/admin/owner-requests")
public class AdminOwnerRequestServlet extends HttpServlet {

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

        String filter = request.getParameter("filter");
        if (filter == null || filter.trim().isEmpty()) {
            filter = "pending";
        }

        List<OwnerRequest> requestList;
        if ("all".equalsIgnoreCase(filter)) {
            requestList = OwnerRequest.getAllRequestHistory();
        } else {
            requestList = OwnerRequest.getPendingRequests();
        }

        request.setAttribute("requestList", requestList);
        request.setAttribute("filter", filter);
        request.getRequestDispatcher("/pages/admin/owner_requests.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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

        String action = request.getParameter("action");
        String requestId = request.getParameter("requestId");
        String rejectReason = request.getParameter("rejectReason");

        if (action == null || requestId == null) {
            session.setAttribute("errorMsg", "Parameter tidak lengkap.");
            response.sendRedirect(request.getContextPath() + "/admin/owner-requests");
            return;
        }

        OwnerRequest ownerReq = OwnerRequest.getById(requestId);

        if (ownerReq == null) {
            session.setAttribute("errorMsg", "Permintaan tidak ditemukan.");
            response.sendRedirect(request.getContextPath() + "/admin/owner-requests");
            return;
        }

        boolean success = false;
        if ("approve".equalsIgnoreCase(action)) {
            success = ownerReq.approve();
            if (success) {
                model.ActivityLog.recordLog(Integer.parseInt(currentUser.getUserId()), "APPROVE_OWNER_REQUEST",
                        currentUser.getName() + " menyetujui permintaan Owner dari: "
                                + ownerReq.getTenant().getName());
                session.setAttribute("successMsg", "Permintaan berhasil disetujui, tenant sekarang adalah Owner.");
            } else {
                session.setAttribute("errorMsg", "Gagal menyetujui permintaan. Pastikan status masih pending.");
            }
        } else if ("reject".equalsIgnoreCase(action)) {
            if (rejectReason == null || rejectReason.trim().isEmpty()) {
                rejectReason = "Tidak ada alasan spesifik.";
            }
            success = ownerReq.reject(rejectReason);
            if (success) {
                model.ActivityLog.recordLog(Integer.parseInt(currentUser.getUserId()), "REJECT_OWNER_REQUEST",
                        currentUser.getName() + " menolak permintaan Owner dari: "
                                + ownerReq.getTenant().getName());
                session.setAttribute("successMsg", "Permintaan berhasil ditolak.");
            } else {
                session.setAttribute("errorMsg", "Gagal menolak permintaan. Pastikan status masih pending.");
            }
        } else {
            session.setAttribute("errorMsg", "Aksi tidak dikenali.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/owner-requests");
    }
}
