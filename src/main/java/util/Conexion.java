package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {
    public static Connection getConexion() {
        Connection cn = null;
        try {
            // Forzamos la carga del Driver moderno
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 1. Intentamos la URL interna de Railway (Prioridad)
            String url = java.lang.System.getenv("MYSQL_URL");
            
            if (url != null && !url.isEmpty()) {
                cn = DriverManager.getConnection(url);
            } else {
                // 2. URL Pública para "chocolateria_db" con parámetros para MySQL 9
                // Es CRÍTICO incluir allowPublicKeyRetrieval=true
                String urlPublica = "jdbc:mysql://shinkansen.proxy.rlwy.net:10984/chocolateria_db"
                                  + "?useSSL=false"
                                  + "&serverTimezone=UTC"
                                  + "&allowPublicKeyRetrieval=true";
                
                cn = DriverManager.getConnection(urlPublica, "root", "fxOJJTEZWGLXDUPFXYQCoSAsJTiUHuT");
            }
        } catch (Exception e) {
            java.lang.System.err.println("Error de conexión: " + e.getMessage());
        }
        return cn;
    }
}
