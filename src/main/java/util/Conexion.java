package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {
    public static Connection getConexion() {
        Connection cn = null;
        try {
            // Cargamos el driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Configuración para el esquema 'railway'
            // Usamos los datos de acceso que ya tienes
            String host = "shinkansen.proxy.rlwy.net";
            String port = "10984";
            String db   = "railway"; // <-- IMPORTANTE: Ahora que las moviste, usamos este
            String user = "root";
            String pass = "fxOJJTEZWGLXDUPFXYQCoSAsJTiUHuT";

            // URL con los parámetros de seguridad para evitar el error de llave pública
            String url = "jdbc:mysql://" + host + ":" + port + "/" + db 
                       + "?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";

            cn = DriverManager.getConnection(url, user, pass);
            
            // Log de consola para confirmar en Railway que conectó
            System.out.println("✔ Conexión exitosa al esquema: " + db);

        } catch (Exception e) {
            System.err.println("❌ Error de conexión: " + e.getMessage());
        }
        return cn;
    }
}
