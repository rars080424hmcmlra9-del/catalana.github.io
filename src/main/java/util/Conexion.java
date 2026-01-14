package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {
    public static Connection getConexion() {
        Connection cn = null;
        try {
            // 1. Carga forzada del driver moderno
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 2. Construcción manual de la URL basada en tus imágenes de Railway
            // Usamos la URL pública pero con los parámetros críticos para MySQL 9
            String host = "shinkansen.proxy.rlwy.net";
            String port = "10984";
            String db   = "chocolateria_db";
            String user = "root";
            String pass = "fxOJJTEZWGLXDUPFXYQCoSAsJTiUHuT";
            
            String url = "jdbc:mysql://" + host + ":" + port + "/" + db 
                         + "?useSSL=false"
                         + "&allowPublicKeyRetrieval=true"
                         + "&serverTimezone=UTC"
                         + "&useUnicode=true"
                         + "&characterEncoding=UTF-8";

            cn = DriverManager.getConnection(url, user, pass);
            System.out.println(">>> CONEXIÓN EXITOSA A: " + db);
            
        } catch (ClassNotFoundException e) {
            System.err.println(">>> ERROR: No se encontró el Driver de MySQL");
        } catch (SQLException e) {
            System.err.println(">>> ERROR DE SQL: " + e.getMessage());
        } catch (Exception e) {
            System.err.println(">>> ERROR GENERAL: " + e.getMessage());
        }
        return cn;
    }
}
