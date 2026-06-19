package util;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.security.SecureRandom;
import java.util.Base64;

public class PasswordUtil {
    public static String hashPassword(String password) {
        try {
            int iterations = 10000;
            byte[] salt = new byte[16];
            new SecureRandom().nextBytes(salt);

            PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, iterations, 256);
            SecretKeyFactory skf = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
            byte[] hash = skf.generateSecret(spec).getEncoded();

            return iterations + ":" + Base64.getEncoder().encodeToString(salt) + ":"
                    + Base64.getEncoder().encodeToString(hash);
        } catch (Exception e) {
            throw new RuntimeException("Error saat melakukan hashing password", e);
        }
    }

    public static boolean checkPassword(String plainPassword, String storedHash) {
        try {
            if (storedHash == null || !storedHash.contains(":")) {
                return plainPassword.equals(storedHash);
            }

            String[] parts = storedHash.split(":");
            if (parts.length != 3)
                return false;

            int iterations = Integer.parseInt(parts[0]);
            byte[] salt = Base64.getDecoder().decode(parts[1]);
            byte[] hash = Base64.getDecoder().decode(parts[2]);

            PBEKeySpec spec = new PBEKeySpec(plainPassword.toCharArray(), salt, iterations, hash.length * 8);
            SecretKeyFactory skf = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
            byte[] testHash = skf.generateSecret(spec).getEncoded();

            if (hash.length != testHash.length)
                return false;
            for (int i = 0; i < hash.length; i++) {
                if (hash[i] != testHash[i])
                    return false;
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
