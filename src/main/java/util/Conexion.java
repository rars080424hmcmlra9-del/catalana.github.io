package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {

    public static Connection getConexion() {
        Connection cn = null;
        try {
            // 1. Forzamos el driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 2. Intentamos obtener la URL completa de Railway (MYSQL_URL es el estándar en MySQL de Railway)
            String mysqlUrl = System.getenv("MYSQL_URL");

            if (mysqlUrl != null && !mysqlUrl.isEmpty()) {
                // 🔥 MODO PRODUCCIÓN (RAILWAY)
                // Agregamos los parámetros de seguridad necesarios para MySQL 9
                if (!mysqlUrl.contains("?")) {
                    mysqlUrl += "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
                } else if (!mysqlUrl.contains("allowPublicKeyRetrieval")) {
                    mysqlUrl += "&allowPublicKeyRetrieval=true";
                }
                cn = DriverManager.getConnection(mysqlUrl);
            } else {
                // 🔹 MODO LOCAL (XAMPP / PC)
                // Usamos la URL pública que me pasaste antes para que funcione incluso si no hay variables
                String host = "shinkansen.proxy.rlwy.net";
                String port = "10984";
                String db   = "chocolateria_db";
                String user = "root";
                String pass = "fxOJJTEZWGLXDUPFXYQCoSAsJTiUHuT";
                
                String urlLocal = "jdbc:mysql://" + host + ":" + port + "/" + db + 
                                  "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
                
                cn = DriverManager.getConnection(urlLocal, user, pass);
            }

            if (cn != null) {
                System.out.println("✔ Conexión establecida correctamente.");
            }

        } catch (Exception e) {
            System.err.println("❌ ERROR CRÍTICO BD: " + e.getMessage());
            e.printStackTrace();
        }
        return cn;
    }
}
