package controller.auth;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import model.OwnerRequest;
import model.Tenant;
import model.User;
import util.CloudinaryUploader;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;

@WebServlet("/upgrade")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class UpgradeController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userSession") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("userSession");
        
        
        Tenant tenant = new Tenant();
        tenant.setUserId(currentUser.getUserId());
        tenant.setName(currentUser.getName());
        tenant.setEmail(currentUser.getEmail());

        String reason = request.getParameter("reason");
        Part ktpPart = request.getPart("ktp_photo");

        if (ktpPart == null || ktpPart.getSize() == 0) {
            session.setAttribute("errorMsg", "Foto KTP wajib diupload.");
            response.sendRedirect(request.getContextPath() + "/pages/tenant/dashboard.jsp");
            return;
        }

        String ktpPhotoUrl = null;
        try {
            String fileName = getSubmittedFileName(ktpPart);
            byte[] fileBytes = readAllBytes(ktpPart.getInputStream());
            ktpPhotoUrl = CloudinaryUploader.upload(fileBytes, fileName);
            
            if (ktpPhotoUrl == null) {
                session.setAttribute("errorMsg", "Gagal mengunggah foto KTP. Silakan coba lagi.");
                response.sendRedirect(request.getContextPath() + "/pages/tenant/dashboard.jsp");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "Terjadi kesalahan saat memproses file.");
            response.sendRedirect(request.getContextPath() + "/pages/tenant/dashboard.jsp");
            return;
        }

        
        OwnerRequest ownerReq = new OwnerRequest();
        ownerReq.setTenant(tenant);
        ownerReq.setReason(reason);
        ownerReq.setKtpPhotoUrl(ktpPhotoUrl);

        boolean success = ownerReq.submitRequest();

        if (success) {
            session.setAttribute("successMsg", "Permintaan pengajuan Owner berhasil dikirim.");
            response.sendRedirect(request.getContextPath() + "/pages/tenant/dashboard.jsp");
        } else {
            session.setAttribute("errorMsg", "Anda sudah memiliki permintaan yang sedang diproses, atau data tidak lengkap.");
            response.sendRedirect(request.getContextPath() + "/pages/tenant/dashboard.jsp");
        }
    }

    private String getSubmittedFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                String fileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
                return fileName.substring(fileName.lastIndexOf('/') + 1).substring(fileName.lastIndexOf('\\') + 1);
            }
        }
        return null;
    }

    private byte[] readAllBytes(InputStream inputStream) throws IOException {
        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        int nRead;
        byte[] data = new byte[1024];
        while ((nRead = inputStream.read(data, 0, data.length)) != -1) {
            buffer.write(data, 0, nRead);
        }
        buffer.flush();
        return buffer.toByteArray();
    }
}
