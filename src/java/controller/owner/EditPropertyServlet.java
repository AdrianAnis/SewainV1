package controller.owner;

import DAO.PropertyDAO;
import model.*;
import util.CloudinaryUploader;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@WebServlet(name = "EditPropertyServlet", urlPatterns = { "/owner/edit" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class EditPropertyServlet extends HttpServlet {

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
            response.sendRedirect(request.getContextPath() + "/pages/owner/dashboard_owner.jsp");
            return;
        }

        request.setAttribute("property", property);
        request.getRequestDispatcher("/pages/owner/edit_property.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userSession") == null) {
            sendResponse(request, response, false, "Session expired.", null);
            return;
        }

        User currentUser = (User) session.getAttribute("userSession");
        if (!"Owner".equalsIgnoreCase(currentUser.getRole()) && !"Admin".equalsIgnoreCase(currentUser.getRole())) {
            sendResponse(request, response, false, "Unauthorized access.", null);
            return;
        }

        String idParam = request.getParameter("propertyId");
        if (idParam == null || idParam.trim().isEmpty()) {
            sendResponse(request, response, false, "Missing property ID.", null);
            return;
        }

        int propertyId;
        try {
            propertyId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            sendResponse(request, response, false, "Invalid property ID.", null);
            return;
        }

        int ownerId = 1;
        try {
            ownerId = Integer.parseInt(currentUser.getUserId());
        } catch (Exception e) {
        }

        PropertyDAO dao = new PropertyDAO();
        Property existingProperty = dao.getPropertyById(propertyId);

        if (existingProperty == null || existingProperty.getOwnerId() != ownerId) {
            sendResponse(request, response, false, "Forbidden access to this property.", null);
            return;
        }

        if (currentUser instanceof Owner) {
            ((Owner) currentUser).editProperty(propertyId);
        }

        String name = request.getParameter("name");
        String location = request.getParameter("location");
        double price = 0;
        try {
            price = Double.parseDouble(request.getParameter("price"));
        } catch (Exception e) {
        }

        String description = request.getParameter("description");
        String statusParam = request.getParameter("status");
        boolean availability = "Available".equalsIgnoreCase(statusParam);
        String facilities = request.getParameter("facilities");
        String propertyType = existingProperty.getPropertyType();

        String existingPhotosStr = request.getParameter("existingPhotos");
        List<String> existingPhotosList = new ArrayList<>();
        if (existingPhotosStr != null && !existingPhotosStr.trim().isEmpty()) {
            existingPhotosList.addAll(Arrays.asList(existingPhotosStr.split(",")));
        }

        String coverUrl = null;
        Part coverPart = request.getPart("cover_photo");
        if (coverPart != null && coverPart.getSize() > 0) {
            String fileName = getSubmittedFileName(coverPart);
            byte[] fileBytes = readAllBytes(coverPart.getInputStream());
            coverUrl = CloudinaryUploader.upload(fileBytes, fileName);
            if (coverUrl == null) {
                sendResponse(request, response, false, "Gagal upload cover photo baru ke Cloudinary.", null);
                return;
            }
        } else {
            if (!existingPhotosList.isEmpty()) {
                coverUrl = existingPhotosList.get(0);
            }
        }

        List<String> galleryUrls = new ArrayList<>();
        for (int i = 1; i < existingPhotosList.size(); i++) {
            galleryUrls.add(existingPhotosList.get(i));
        }

        for (Part part : request.getParts()) {
            if ("gallery_photos".equals(part.getName()) && part.getSize() > 0) {
                String fileName = getSubmittedFileName(part);
                byte[] fileBytes = readAllBytes(part.getInputStream());
                String cloudinaryUrl = CloudinaryUploader.upload(fileBytes, fileName);
                if (cloudinaryUrl != null) {
                    galleryUrls.add(cloudinaryUrl);
                }
            }
        }

        List<String> finalPhotos = new ArrayList<>();
        if (coverUrl != null && !coverUrl.trim().isEmpty()) {
            finalPhotos.add(coverUrl);
        }
        for (String url : galleryUrls) {
            if (url != null && !url.trim().isEmpty()) {
                finalPhotos.add(url);
            }
        }
        String photosJoined = String.join(",", finalPhotos);

        Property prop = null;
        if ("Kost".equalsIgnoreCase(propertyType)) {
            Kost k = new Kost();
            k.setGender(request.getParameter("gender"));
            k.setRoomType(request.getParameter("roomType"));
            prop = k;
        } else if ("Rumah".equalsIgnoreCase(propertyType)) {
            Rumah r = new Rumah();
            try {
                r.setJumlahKamar(Integer.parseInt(request.getParameter("jumlahKamar")));
            } catch (Exception e) {
            }
            try {
                r.setLuasTanah(Double.parseDouble(request.getParameter("luasTanah")));
            } catch (Exception e) {
            }
            prop = r;
        } else if ("Kontrakan".equalsIgnoreCase(propertyType)) {
            Kontrakan kr = new Kontrakan();
            try {
                kr.setJumlahKamar(Integer.parseInt(request.getParameter("jumlahKamar")));
            } catch (Exception e) {
            }
            try {
                kr.setDurasiMinimum(Integer.parseInt(request.getParameter("durasiMinimum")));
            } catch (Exception e) {
            }
            prop = kr;
        } else if ("Apartement".equalsIgnoreCase(propertyType)) {
            Apartement a = new Apartement();
            try {
                a.setLantai(Integer.parseInt(request.getParameter("lantai")));
            } catch (Exception e) {
            }
            a.setNomorUnit(request.getParameter("nomorUnit"));
            a.setTipeUnit(request.getParameter("tipeUnit"));
            prop = a;
        }

        if (prop != null) {
            prop.setPropertyId(propertyId);
            prop.setName(name);
            prop.setLocation(location);
            prop.setPrice(price);
            prop.setDescription(description);
            prop.setFacilities(facilities);
            prop.setPropertyType(propertyType);
            prop.setAvailability(availability);
            prop.setPhotos(photosJoined);

            boolean success = dao.updateProperty(prop);
            if (success) {
                sendResponse(request, response, true, "Success", propertyId);
            } else {
                sendResponse(request, response, false, "Gagal memperbarui database.", null);
            }
        } else {
            sendResponse(request, response, false, "Invalid property type.", null);
        }
    }

    private void sendResponse(HttpServletRequest request, HttpServletResponse response, boolean success, String message,
            Integer propertyId) throws IOException {
        String acceptHeader = request.getHeader("Accept");
        boolean isJsonRequest = (acceptHeader != null && acceptHeader.contains("application/json"))
                || "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));

        if (isJsonRequest) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            if (success) {
                response.getWriter().write("{\"success\": true, \"propertyId\": " + propertyId + "}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"" + message + "\"}");
            }
        } else {
            if (success) {
                response.sendRedirect(
                        request.getContextPath() + "/owner/detail?propertyId=" + propertyId + "&updated=true");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, message);
            }
        }
    }

    private String getSubmittedFileName(Part part) {
        String header = part.getHeader("content-disposition");
        if (header == null)
            return "unknown";
        for (String token : header.split(";")) {
            String trimmed = token.trim();
            if (trimmed.startsWith("filename")) {
                int eqIdx = trimmed.indexOf('=');
                if (eqIdx != -1) {
                    String fileName = trimmed.substring(eqIdx + 1).trim().replace("\"", "");
                    int lastSlash = Math.max(fileName.lastIndexOf('/'), fileName.lastIndexOf('\\'));
                    if (lastSlash >= 0) {
                        fileName = fileName.substring(lastSlash + 1);
                    }
                    return fileName;
                }
            }
        }
        return "unknown";
    }

    private byte[] readAllBytes(InputStream is) throws IOException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        byte[] buffer = new byte[8192];
        int bytesRead;
        while ((bytesRead = is.read(buffer)) != -1) {
            baos.write(buffer, 0, bytesRead);
        }
        is.close();
        return baos.toByteArray();
    }
}
