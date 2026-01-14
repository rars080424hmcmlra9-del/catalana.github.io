package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {
    public static Connection getConexion() {
        Connection cn = null;
        try {
            // Cargamos el driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 1. Intentar URL interna (Es la que aparece como MYSQL_URL en tu imagen)
            String urlVar = java.lang.System.getenv("MYSQL_URL");
            
            if (urlVar != null && !urlVar.isEmpty()) {
                cn = DriverManager.getConnection(urlVar);
            } else {
                // 2. Si falla, usamos la URL pública de tu captura con los parámetros de seguridad
                // Nombre de DB: chocolateria_db | Password: la de tu captura
                String urlPublica = "jdbc:mysql://shinkansen.proxy.rlwy.net:10984/chocolateria_db"
                                  + "?useSSL=false"
                                  + "&serverTimezone=UTC"
                                  + "&allowPublicKeyRetrieval=true";
                
                cn = DriverManager.getConnection(urlPublica, "root", "fxOJJTEZWGLXDUPFXYQCoSAsJTiUHuT");
            }
            java.lang.System.out.println("CONEXIÓN EXITOSA A LA CATALANA");
        } catch (Exception e) {
            java.lang.System.err.println("ERROR DE CONEXIÓN: " + e.getMessage());
            e.printStackTrace();
        }
        return cn;
    }
}
