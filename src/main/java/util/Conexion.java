package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {
    public static Connection getConexion() {
        Connection cn = null;
        try {
            // 1. Forzamos el driver actualizado
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 2. Intentamos la URL interna de Railway
            String urlVar = java.lang.System.getenv("MYSQL_URL");
            
            if (urlVar != null && !urlVar.isEmpty()) {
                // Agregamos parámetros de compatibilidad para MySQL 9
                String urlFull = urlVar + (urlVar.contains("?") ? "&" : "?") 
                               + "allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";
                cn = DriverManager.getConnection(urlFull);
            } else {
                // 3. Respaldo Manual (Datos de tu imagen de Railway)
                String host = "shinkansen.proxy.rlwy.net";
                String port = "10984";
                String db   = "chocolateria_db";
                String user = "root";
                String pass = "fxOJJTEZWGLXDUPFXYQCoSAsJTiUHuT";
                
                String urlPublica = "jdbc:mysql://" + host + ":" + port + "/" + db 
                                  + "?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";
                
                cn = DriverManager.getConnection(urlPublica, user, pass);
            }
        } catch (Exception e) {
            java.lang.System.err.println("CRÍTICO: Fallo al conectar DB -> " + e.getMessage());
        }
        return cn;
    }
}
