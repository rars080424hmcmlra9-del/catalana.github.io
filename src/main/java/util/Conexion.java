package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {
    public static Connection getConexion() {
        Connection cn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = java.lang.System.getenv("MYSQL_URL");
            
            if (url != null && !url.isEmpty()) {
                // Railway usa la URL interna completa automáticamente
                cn = DriverManager.getConnection(url);
            } else {
                // URL Pública corregida con "chocolateria_db"
                String urlPublica = "jdbc:mysql://shinkansen.proxy.rlwy.net:10984/chocolateria_db?useSSL=false&serverTimezone=UTC";
                cn = DriverManager.getConnection(urlPublica, "root", "fxOJJTEZWGLXDUPFXYQCoSAsJTiUHuT");
            }
        } catch (Exception e) {
            java.lang.System.err.println("Error de conexión: " + e.getMessage());
        }
        return cn;
    }
}
