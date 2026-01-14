package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {
    public static Connection getConexion() {
        Connection cn = null;
        try {
            // Forzamos la carga del Driver para evitar errores de clase no encontrada
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Intentamos obtener la URL interna proporcionada por Railway
            String url = java.lang.System.getenv("MYSQL_URL");
            
            if (url != null && !url.isEmpty()) {
                // Si la variable interna existe, la usamos directamente
                cn = DriverManager.getConnection(url);
            } else {
                // Configuración para acceso externo (tu PC) a chocolateria_db
                // Es vital agregar allowPublicKeyRetrieval=true para MySQL 8+
                String urlPublica = "jdbc:mysql://shinkansen.proxy.rlwy.net:10984/chocolateria_db"
                                  + "?useSSL=false"
                                  + "&serverTimezone=UTC"
                                  + "&allowPublicKeyRetrieval=true";
                
                cn = DriverManager.getConnection(urlPublica, "root", "fxOJJTEZWGLXDUPFXYQCoSAsJTiUHuT");
            }
        } catch (Exception e) {
            java.lang.System.err.println("Error crítico en Conexion: " + e.getMessage());
            e.printStackTrace();
        }
        return cn;
    }
}
