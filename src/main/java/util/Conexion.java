package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {
    public static Connection getConexion() {
        Connection cn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Usamos el nombre 'railway' que es donde ahora están tus tablas
            String db = "railway"; 
            String user = "root";
            String pass = "fxOJJTEZWGLXDUPFXYQCoSAsJTiUHuT";
            String host = "shinkansen.proxy.rlwy.net";
            String port = "10984";

            // URL con los permisos de seguridad necesarios
            String url = "jdbc:mysql://" + host + ":" + port + "/" + db 
                       + "?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";

            cn = DriverManager.getConnection(url, user, pass);
            
        } catch (Exception e) {
            System.err.println("❌ Error conectando a la DB railway: " + e.getMessage());
        }
        return cn;
    }
}
