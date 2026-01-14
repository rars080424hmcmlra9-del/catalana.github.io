package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {
    public static Connection getConexion() {
        Connection cn = null;
        try {
            // 1. Forzamos la carga del driver moderno
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 2. Obtenemos la URL de Railway (image_aa4ca6.png muestra que existe MYSQL_URL)
            String mysqlUrl = System.getenv("MYSQL_URL");

            if (mysqlUrl != null && !mysqlUrl.isEmpty()) {
                // --- MODO PRODUCCIÓN (RAILWAY) ---
                // Agregamos parámetros de seguridad vitales para evitar el error de "Public Key"
                String connectionUrl = mysqlUrl + (mysqlUrl.contains("?") ? "&" : "?") 
                                     + "allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";
                cn = DriverManager.getConnection(connectionUrl);
            } else {
                // --- MODO LOCAL / RESPALDO (Host Público de tu imagen) ---
                String url = "jdbc:mysql://shinkansen.proxy.rlwy.net:10984/chocolateria_db"
                           + "?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";
                
                // Credenciales exactas de tu captura:
                String user = "root";
                String pass = "fxOJJTEZWGLXDUPFXYQCoSAsJTiUHuT";
                
                cn = DriverManager.getConnection(url, user, pass);
            }
        } catch (Exception e) {
            System.err.println("❌ ERROR DE CONEXIÓN: " + e.getMessage());
            e.printStackTrace();
        }
        return cn;
    }
}
