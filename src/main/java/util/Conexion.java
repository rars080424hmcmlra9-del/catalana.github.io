package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {
    public static Connection getConexion() {
        Connection cn = null;
        try {
            // 1. Forzar el Driver actualizado de MySQL 8/9
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 2. Intentar URL interna de Railway
            String url = java.lang.System.getenv("MYSQL_URL");
            
            if (url != null && !url.isEmpty()) {
                // Railway configura su URL interna automáticamente con lo necesario
                cn = DriverManager.getConnection(url);
            } else {
                // 3. URL Pública para "chocolateria_db" con parámetros de compatibilidad MySQL 9
                String urlPublica = "jdbc:mysql://shinkansen.proxy.rlwy.net:10984/chocolateria_db"
                                  + "?useSSL=false"
                                  + "&serverTimezone=UTC"
                                  + "&allowPublicKeyRetrieval=true"; // OBLIGATORIO para MySQL 9
                
                cn = DriverManager.getConnection(urlPublica, "root", "fxOJJTEZWGLXDUPFXYQCoSAsJTiUHuT");
            }
            java.lang.System.out.println("¡Conexión exitosa a MySQL 9!");
        } catch (Exception e) {
            java.lang.System.err.println("Error de conexión: " + e.getMessage());
        }
        return cn;
    }
}
