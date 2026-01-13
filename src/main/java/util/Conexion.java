package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {
    public static Connection getConexion() {
        Connection cn = null;
        try {
            // Railway proporciona automáticamente la variable MYSQL_URL
            String url = java.lang.System.getenv("MYSQL_URL");
            
            // Si la variable no existe (ej. pruebas locales), usamos la URL pública
            if (url == null || url.isEmpty()) {
                url = "jdbc:mysql://shinkansen.proxy.rlwy.net:10984/railway?useSSL=false&serverTimezone=UTC";
                Class.forName("com.mysql.cj.jdbc.Driver");
                cn = DriverManager.getConnection(url, "root", "fxOJJTEZWGLXDUPFXYQCoSAsJTiUHuT");
            } else {
                // Conexión interna dentro de Railway
                Class.forName("com.mysql.cj.jdbc.Driver");
                cn = DriverManager.getConnection(url);
            }
            java.lang.System.out.println("Conexión establecida con éxito.");
        } catch (Exception e) {
            java.lang.System.err.println("ERROR EN CONEXIÓN: " + e.getMessage());
            e.printStackTrace();
        }
        return cn;
    }
}
