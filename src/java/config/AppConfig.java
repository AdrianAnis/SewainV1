package config;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class AppConfig {

    private static final Properties props = new Properties();
    private static boolean loaded = false;

    private static synchronized void loadProperties() {
        if (loaded)
            return;
        InputStream is = AppConfig.class.getClassLoader()
                .getResourceAsStream("../cloudinary.properties");

        if (is == null) {
            is = AppConfig.class.getClassLoader()
                    .getResourceAsStream("cloudinary.properties");
        }

        if (is == null) {
            System.err.println("[AppConfig] FATAL: cloudinary.properties not found!");
            System.err.println("[AppConfig] Expected location: WEB-INF/cloudinary.properties");
            loaded = true;
            return;
        }

        try {
            props.load(is);
            System.out.println("[AppConfig] cloudinary.properties loaded successfully.");
        } catch (IOException e) {
            System.err.println("[AppConfig] Error reading cloudinary.properties: " + e.getMessage());
        } finally {
            try {
                is.close();
            } catch (IOException ignored) {
            }
        }

        loaded = true;
    }

    public static String get(String key) {
        loadProperties();
        return props.getProperty(key);
    }

    public static String get(String key, String defaultValue) {
        loadProperties();
        return props.getProperty(key, defaultValue);
    }
}
