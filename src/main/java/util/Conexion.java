package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {
    public static Connection getConexion() {
        Connection cn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Intentamos obtener la URL interna (la mejor opción en la nube)
            String url = java.lang.System.getenv("MYSQL_URL");
            
            if (url != null && !url.isEmpty()) {
                cn = DriverManager.getConnection(url);
            } else {
                // Si falla la interna, usamos la pública apuntando a 'railway'
                // Agregamos los parámetros de seguridad para evitar errores de llave pública
                String urlPublica = "jdbc:mysql://shinkansen.proxy.rlwy.net:10984/chocolateria_db"
                                  + "?useSSL=false"
                                  + "&serverTimezone=UTC"
                                  + "&allowPublicKeyRetrieval=true";
                
                cn = DriverManager.getConnection(urlPublica, "root", "fxOJJTEZWGLXDUPFXYQCoSAsJTiUHuT");
            }
        } catch (Exception e) {
            java.lang.System.err.println("ERROR DE CONEXIÓN: " + e.getMessage());
        }
        return cn;
    }
}
