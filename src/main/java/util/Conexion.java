package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {
    public static Connection getConexion() {
        Connection cn = null;
        try {
            // 1. Cargamos el driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 2. Datos de Railway (Asegúrate de que coincidan con tu panel)
            String host = "shinkansen.proxy.rlwy.net";
            String port = "10984";
            String db   = "chocolateria_db"; // <-- AQUÍ EL NOMBRE QUE VAS A CAMBIAR
            String user = "root";
            String pass = "fxOJJTEZWGLXDUPFXYQCoSAsJTiUHuT";

            // 3. Construcción de la URL con parámetros de seguridad para MySQL 8/9
            String url = "jdbc:mysql://" + host + ":" + port + "/" + db 
                       + "?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";

            cn = DriverManager.getConnection(url, user, pass);
            System.out.println("✔ Conectado a la base de datos de la Chocolatería");

        } catch (Exception e) {
            System.err.println("❌ ERROR: " + e.getMessage());
        }
        return cn;
    }
}
