package util;

import config.AppConfig;
import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.UUID;

public class CloudinaryUploader {

    private static final String UPLOAD_URL_TEMPLATE = "https://api.cloudinary.com/v1_1/%s/image/upload";

    public static String upload(byte[] fileBytes, String originalFileName) throws IOException {
        String cloudName = AppConfig.get("cloudinary.cloud_name");
        String apiKey = AppConfig.get("cloudinary.api_key");
        String apiSecret = AppConfig.get("cloudinary.api_secret");

        if (cloudName == null || apiKey == null || apiSecret == null) {
            System.err.println("[CloudinaryUploader] Missing Cloudinary credentials in config.");
            return null;
        }

        String publicId = "sewain/" + UUID.randomUUID().toString();
        long timestamp = System.currentTimeMillis() / 1000L;

        String toSign = "public_id=" + publicId + "&timestamp=" + timestamp + apiSecret;
        String signature = sha1Hex(toSign);

        if (signature == null) {
            System.err.println("[CloudinaryUploader] Failed to generate SHA-1 signature.");
            return null;
        }

        String boundary = "----CloudinaryBoundary" + System.currentTimeMillis();
        String uploadUrl = String.format(UPLOAD_URL_TEMPLATE, cloudName);

        URL url = new URL(uploadUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setDoOutput(true);
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + boundary);
        conn.setConnectTimeout(30000);
        conn.setReadTimeout(60000);

        DataOutputStream out = new DataOutputStream(conn.getOutputStream());

        writeFormField(out, boundary, "api_key", apiKey);
        writeFormField(out, boundary, "timestamp", String.valueOf(timestamp));
        writeFormField(out, boundary, "public_id", publicId);
        writeFormField(out, boundary, "signature", signature);

        String mimeType = guessMimeType(originalFileName);
        out.writeBytes("--" + boundary + "\r\n");
        out.writeBytes("Content-Disposition: form-data; name=\"file\"; filename=\""
                + originalFileName + "\"\r\n");
        out.writeBytes("Content-Type: " + mimeType + "\r\n\r\n");
        out.write(fileBytes);
        out.writeBytes("\r\n");

        out.writeBytes("--" + boundary + "--\r\n");
        out.flush();
        out.close();

        int responseCode = conn.getResponseCode();
        InputStream responseStream;
        if (responseCode >= 200 && responseCode < 300) {
            responseStream = conn.getInputStream();
        } else {
            responseStream = conn.getErrorStream();
            String errorBody = readStream(responseStream);
            System.err.println("[CloudinaryUploader] Upload failed. HTTP " + responseCode);
            System.err.println("[CloudinaryUploader] Response: " + errorBody);
            conn.disconnect();
            return null;
        }

        String responseBody = readStream(responseStream);
        conn.disconnect();

        String secureUrl = extractJsonValue(responseBody, "secure_url");
        if (secureUrl == null) {
            System.err.println("[CloudinaryUploader] Could not parse secure_url from response.");
            System.err.println("[CloudinaryUploader] Response body: " + responseBody);
        }

        return secureUrl;
    }

    private static void writeFormField(DataOutputStream out, String boundary,
            String fieldName, String value) throws IOException {
        out.writeBytes("--" + boundary + "\r\n");
        out.writeBytes("Content-Disposition: form-data; name=\"" + fieldName + "\"\r\n\r\n");
        out.writeBytes(value + "\r\n");
    }

    private static String sha1Hex(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-1");
            byte[] digest = md.digest(input.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : digest) {
                sb.append(String.format("%02x", b & 0xff));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException | java.io.UnsupportedEncodingException e) {
            System.err.println("[CloudinaryUploader] SHA-1 error: " + e.getMessage());
            return null;
        }
    }

    private static String readStream(InputStream is) throws IOException {
        if (is == null)
            return "";
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        byte[] buffer = new byte[4096];
        int bytesRead;
        while ((bytesRead = is.read(buffer)) != -1) {
            baos.write(buffer, 0, bytesRead);
        }
        is.close();
        return baos.toString("UTF-8");
    }
    
    private static String extractJsonValue(String json, String key) {
        String searchKey = "\"" + key + "\"";
        int keyIdx = json.indexOf(searchKey);
        if (keyIdx == -1)
            return null;

        int colonIdx = json.indexOf(':', keyIdx + searchKey.length());
        if (colonIdx == -1)
            return null;

        int openQuote = json.indexOf('"', colonIdx + 1);
        if (openQuote == -1)
            return null;

        int closeQuote = openQuote + 1;
        while (closeQuote < json.length()) {
            char c = json.charAt(closeQuote);
            if (c == '\\') {
                closeQuote += 2;
                continue;
            }
            if (c == '"')
                break;
            closeQuote++;
        }
        if (closeQuote >= json.length())
            return null;

        String value = json.substring(openQuote + 1, closeQuote);
        value = value.replace("\\/", "/");
        return value;
    }

    private static String guessMimeType(String fileName) {
        if (fileName == null)
            return "application/octet-stream";
        String lower = fileName.toLowerCase();
        if (lower.endsWith(".png"))
            return "image/png";
        if (lower.endsWith(".gif"))
            return "image/gif";
        if (lower.endsWith(".webp"))
            return "image/webp";
        if (lower.endsWith(".bmp"))
            return "image/bmp";
        if (lower.endsWith(".svg"))
            return "image/svg+xml";
        return "image/jpeg";
    }
}
