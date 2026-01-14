package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {
    public static Connection getConexion() {
        Connection cn = null;
        try {
            // Forzamos el Driver de MySQL 8/9
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 1. Intentamos leer la URL interna de Railway
            String urlVar = System.getenv("MYSQL_URL");

            if (urlVar != null && !urlVar.isEmpty()) {
                // Si estamos en Railway, añadimos los parámetros de seguridad al final
                String conParametros = urlVar + (urlVar.contains("?") ? "&" : "?") 
                                     + "allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";
                cn = DriverManager.getConnection(conParametros);
                System.out.println("✔ Conectado a Railway exitosamente");
            } else {
                // 2. Si estás en tu PC (Modo Local), usamos tus credenciales públicas
                String host = "shinkansen.proxy.rlwy.net";
                String port = "10984";
                String db   = "chocolateria_db";
                String user = "root";
                String pass = "fxOJJTEZWGLXDUPFXYQCoSAsJTiUHuT";
                
                String urlPublica = "jdbc:mysql://" + host + ":" + port + "/" + db 
                                  + "?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";
                
                cn = DriverManager.getConnection(urlPublica, user, pass);
                System.out.println("✔ Conectado vía Host Público");
            }
        } catch (Exception e) {
            System.err.println("❌ ERROR CRÍTICO: " + e.getMessage());
        }
        return cn;
    }
}
