package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    public static Connection getConexion() {
        Connection cn = null;
        try {
            // 1. Cargamos el Driver moderno de MySQL (imprescindible para Tomcat)
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 2. Intentamos obtener la URL de conexión de Railway
            String mysqlUrl = System.getenv("MYSQL_URL");

            if (mysqlUrl != null && !mysqlUrl.isEmpty()) {
                // --- CONFIGURACIÓN PARA PRODUCCIÓN (RAILWAY) ---
                // Forzamos parámetros de compatibilidad para evitar el error de llave pública y SSL
                String params = (mysqlUrl.contains("?") ? "&" : "?") 
                              + "allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";
                
                cn = DriverManager.getConnection(mysqlUrl + params);
                System.out.println(">>> [CONEXIÓN EXITOSA] Conectado a Railway MySQL.");
            } else {
                // --- CONFIGURACIÓN PARA LOCAL O RESPALDO ---
                // Usamos los datos públicos que se muestran en tu panel de Railway
                String host = "shinkansen.proxy.rlwy.net";
                String port = "10984";
                String db   = "chocolateria_db";
                String user = "root";
                String pass = "fxOJJTEZWGLXDUPFXYQCoSAsJTiUHuT";
                
                String url = "jdbc:mysql://" + host + ":" + port + "/" + db 
                           + "?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";

                cn = DriverManager.getConnection(url, user, pass);
                System.out.println(">>> [CONEXIÓN EXITOSA] Conectado vía Host Público.");
            }

        } catch (ClassNotFoundException e) {
            System.err.println(">>> [ERROR] No se encontró el Driver MySQL: " + e.getMessage());
        } catch (SQLException e) {
            System.err.println(">>> [ERROR DE SQL] Acceso denegado o DB no encontrada: " + e.getMessage());
        } catch (Exception e) {
            System.err.println(">>> [ERROR GENERAL] " + e.getMessage());
        }
        return cn;
    }
}
