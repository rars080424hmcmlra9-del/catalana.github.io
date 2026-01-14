package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {
    public static Connection getConexion() {
        Connection cn = null;
        try {
            // Forzamos la carga del Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Intentamos obtener la URL de Railway (Interna)
            String url = java.lang.System.getenv("MYSQL_URL");
            
            if (url != null && !url.isEmpty()) {
                // En Railway, la URL interna ya es segura
                cn = DriverManager.getConnection(url);
            } else {
                // Configuración definitiva para tu base: chocolateria_db
                // Agregamos los parámetros para evitar errores de seguridad
                String urlPublica = "jdbc:mysql://shinkansen.proxy.rlwy.net:10984/chocolateria_db"
                                  + "?useSSL=false"
                                  + "&serverTimezone=UTC"
                                  + "&allowPublicKeyRetrieval=true";
                
                cn = DriverManager.getConnection(urlPublica, "root", "fxOJJTEZWGLXDUPFXYQCoSAsJTiUHuT");
            }
        } catch (Exception e) {
            java.lang.System.err.println("CRÍTICO: Fallo al conectar DB -> " + e.getMessage());
        }
        return cn;
    }
}
