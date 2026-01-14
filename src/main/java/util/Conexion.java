package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {
    public static Connection getConexion() {
        Connection cn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Railway inyecta esta variable automáticamente
            String urlVar = java.lang.System.getenv("MYSQL_URL");
            
            if (urlVar != null && !urlVar.isEmpty()) {
                cn = DriverManager.getConnection(urlVar);
            } else {
                // Configuración de respaldo con tus datos de Railway
                String urlPublica = "jdbc:mysql://shinkansen.proxy.rlwy.net:10984/chocolateria_db"
                                  + "?useSSL=false"
                                  + "&serverTimezone=UTC"
                                  + "&allowPublicKeyRetrieval=true";
                
                cn = DriverManager.getConnection(urlPublica, "root", "fxOJJTEZWGLXDUPFXYQCoSAsJTiUHuT");
            }
        } catch (Exception e) {
            java.lang.System.err.println("Error en Conexion: " + e.getMessage());
        }
        return cn;
    }
}
