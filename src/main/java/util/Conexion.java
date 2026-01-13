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
                // Dentro de Railway: Usamos la URL interna tal cual
                cn = DriverManager.getConnection(url);
            } else {
                // Desde afuera (tu PC): Agregamos allowPublicKeyRetrieval=true
                String urlPublica = "jdbc:mysql://shinkansen.proxy.rlwy.net:10984/chocolateria_db"
                                  + "?useSSL=false"
                                  + "&serverTimezone=UTC"
                                  + "&allowPublicKeyRetrieval=true"; // <--- ESTO ES LO QUE FALTA
                
                cn = DriverManager.getConnection(urlPublica, "root", "fxOJJTEZWGLXDUPFXYQCoSAsJTiUHuT");
            }
        } catch (Exception e) {
            java.lang.System.err.println("Error de conexión: " + e.getMessage());
            e.printStackTrace();
        }
        return cn;
    }
}
