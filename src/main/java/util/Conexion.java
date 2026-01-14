package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {
    public static Connection getConexion() {
        Connection cn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 1. Intentamos obtener la URL de Railway (Red interna)
            String urlRailway = System.getenv("MYSQL_URL"); 

            if (urlRailway != null && !urlRailway.isEmpty()) {
                // Estamos en Railway: Usamos la conexión automática interna
                // Agregamos los parámetros de seguridad al final
                String conector = urlRailway.contains("?") ? "&" : "?";
                String urlFinal = urlRailway + conector + "allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";
                cn = DriverManager.getConnection(urlFinal);
                System.out.println("✔ Conectado usando red interna de Railway");
            } else {
                // Estamos en tu PC (Local): Usamos la red pública
                String host = "shinkansen.proxy.rlwy.net";
                String port = "10984";
                String db   = "railway"; 
                String user = "root";
                String pass = "fxOJJTEZWGLXDUPFXYQCoSAsJTiUHuT";

                String urlPublica = "jdbc:mysql://" + host + ":" + port + "/" + db 
                                  + "?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";
                
                cn = DriverManager.getConnection(urlPublica, user, pass);
                System.out.println("✔ Conectado desde PC Local a red pública");
            }

        } catch (Exception e) {
            System.err.println("❌ Error de conexión: " + e.getMessage());
        }
        return cn;
    }
}
