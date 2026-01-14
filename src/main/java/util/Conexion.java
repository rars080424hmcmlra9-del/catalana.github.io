package util;

import java.sql.Connection;
import java.sql.DriverManager;

public static Connection getConexion() {
    Connection cn = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String envUrl = System.getenv("MYSQL_URL");

        if (envUrl != null && !envUrl.isEmpty()) {
            // CORRECCIÓN CRÍTICA: Cambiar mysql:// por jdbc:mysql://
            String jdbcUrl = envUrl.replace("mysql://", "jdbc:mysql://") 
                           + "&allowPublicKeyRetrieval=true&useSSL=false";
            cn = DriverManager.getConnection(jdbcUrl);
        } else {
            // Conexión manual usando tus variables de image_b5b855.png
            String url = "jdbc:mysql://shinkansen.proxy.rlwy.net:10984/chocolateria_db?allowPublicKeyRetrieval=true&useSSL=false";
            cn = DriverManager.getConnection(url, "root", "fxOJJTEZWGLXDUPFXYQCoSAsJTiUHuT");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return cn;
}
