package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    public static Connection getConexion() {
        Connection cn = null;
        try {
            // 1. Carga del Driver (Obligatorio para Tomcat 7)
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 2. Intentamos leer la variable de entorno de Railway
            String envUrl = System.getenv("MYSQL_URL");
            
            // 3. Parámetros de seguridad necesarios para MySQL 8/9
            // allowPublicKeyRetrieval=true es lo que evita el error de conexión
            String parametros = "?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";

            if (envUrl != null && !envUrl.isEmpty()) {
                // MODO PRODUCCIÓN (Railway)
                cn = DriverManager.getConnection(envUrl + (envUrl.contains("?") ? "&" : "") + "allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC");
                System.out.println("✔ Conectado usando MYSQL_URL de Railway");
            } else {
                // MODO MANUAL / LOCAL
                // Usamos los datos de tu panel de Railway (Pestaña 'Connect')
                String host = "shinkansen.proxy.rlwy.net";
                String port = "10984";
                String db   = "chocolateria_db";
                String user = "root";
                String pass = "fxOJJTEZWGLXDUPFXYQCoSAsJTiUHuT";
                
                String urlManual = "jdbc:mysql://" + host + ":" + port + "/" + db + parametros;
                
                cn = DriverManager.getConnection(urlManual, user, pass);
                System.out.println("✔ Conectado usando configuración manual");
            }

        } catch (ClassNotFoundException e) {
            System.err.println("❌ ERROR: No se encontró el Driver MySQL: " + e.getMessage());
        } catch (SQLException e) {
            System.err.println("❌ ERROR DE SQL: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("❌ ERROR GENERAL: " + e.getMessage());
        }
        return cn;
    }
}
