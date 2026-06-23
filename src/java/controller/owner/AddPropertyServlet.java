package controller.owner;

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
import java.util.List;

@WebServlet(name = "AddPropertyServlet", urlPatterns = { "/addProperty" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class AddPropertyServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userSession") == null) {
            response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("userSession");
        int ownerId = 1;
        try {
            ownerId = Integer.parseInt(currentUser.getUserId());
        } catch (Exception e) {
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
        String propertyType = request.getParameter("type");

        List<String> photoUrls = new ArrayList<>();

        Part coverPart = request.getPart("cover_photo");
        if (coverPart != null && coverPart.getSize() > 0) {
            String fileName = getSubmittedFileName(coverPart);
            byte[] fileBytes = readAllBytes(coverPart.getInputStream());

            String cloudinaryUrl = CloudinaryUploader.upload(fileBytes, fileName);
            if (cloudinaryUrl == null) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(
                        "{\"success\": false, \"message\": \"Gagal upload cover photo ke Cloudinary. Coba lagi.\"}");
                return;
            }
            photoUrls.add(cloudinaryUrl);
        }

        for (Part part : request.getParts()) {
            if ("gallery_photos".equals(part.getName()) && part.getSize() > 0) {
                String fileName = getSubmittedFileName(part);
                byte[] fileBytes = readAllBytes(part.getInputStream());

                String cloudinaryUrl = CloudinaryUploader.upload(fileBytes, fileName);
                if (cloudinaryUrl != null) {
                    photoUrls.add(cloudinaryUrl);
                }
            }
        }

        String photosJoined = photoUrls.isEmpty() ? "" : String.join(",", photoUrls);

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
            prop.setName(name);
            prop.setLocation(location);
            prop.setPrice(price);
            prop.setDescription(description);
            prop.setFacilities(facilities);
            prop.setPropertyType(propertyType);
            prop.setAvailability(availability);
            prop.setPhotos(photosJoined);
            boolean success = false;
            if (currentUser instanceof Owner) {
                success = ((Owner) currentUser).addProperty(prop);
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            if (success) {
                model.ActivityLog.recordLog(ownerId, "ADD_PROPERTY",
                        "Owner " + currentUser.getName() + " menambahkan properti baru: " + prop.getName());
                response.getWriter().write("{\"success\": true}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Database error.\"}");
            }
        } else {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid property type.\"}");
        }
    }

    /**
     * Extracts the original file name from a multipart Part.
     * Compatible with different servlet container implementations.
     */
    private String getSubmittedFileName(Part part) {
        String header = part.getHeader("content-disposition");
        if (header == null)
            return "unknown";
        for (String token : header.split(";")) {
            String trimmed = token.trim();
            if (trimmed.startsWith("filename")) {
                int eqIdx = trimmed.indexOf('=');
                if (eqIdx != -1) {
                    String fileName = trimmed.substring(eqIdx + 1).trim()
                            .replace("\"", "");

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
