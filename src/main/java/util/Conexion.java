package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {
    public static Connection getConexion() {
        Connection cn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 1. Intentamos usar la variable interna de Railway (RED PRIVADA)
            String urlRailway = System.getenv("MYSQL_URL"); 

            if (urlRailway != null && !urlRailway.isEmpty()) {
                // Si la variable existe, estamos en Railway
                String urlFinal = urlRailway + (urlRailway.contains("?") ? "&" : "?") 
                                + "allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";
                cn = DriverManager.getConnection(urlFinal);
                System.out.println("✔ Conectado a la red INTERNA de Railway");
            } else {
                // 2. Si la variable NO existe, estamos en TU PC (RED PÚBLICA)
                // Usamos los datos que me acabas de pasar
                String host = "shinkansen.proxy.rlwy.net";
                String port = "10984";
                String db   = "railway"; 
                String user = "root";
                String pass = "fxOJJTEZWGLXBDUPFXYQCoSAsJtIuHUT";

                String urlPublica = "jdbc:mysql://" + host + ":" + port + "/" + db 
                                  + "?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";
                
                cn = DriverManager.getConnection(urlPublica, user, pass);
                System.out.println("✔ Conectado desde PC a la red PÚBLICA");
            }
        } catch (Exception e) {
            System.err.println("❌ Error de conexión: " + e.getMessage());
        }
        return cn;
    }
}
