package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    public static Connection getConexion() {
        Connection cn = null;
        try {
            // 1. Cargamos el Driver (Obligatorio para Tomcat 7/8)
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 2. Intentamos obtener la URL de Railway (MYSQL_URL es la estándar)
            String mysqlUrl = System.getenv("MYSQL_URL");

            if (mysqlUrl != null && !mysqlUrl.isEmpty()) {
                // MODO PRODUCCIÓN: Railway
                // Agregamos parámetros de seguridad obligatorios para MySQL moderno
                String conParametros = mysqlUrl + (mysqlUrl.contains("?") ? "&" : "?") 
                                     + "allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";
                cn = DriverManager.getConnection(conParametros);
            } else {
                // MODO LOCAL / RESPALDO: Datos de tu panel de Railway
                String url = "jdbc:mysql://shinkansen.proxy.rlwy.net:10984/chocolateria_db"
                           + "?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";
                
                // Estos datos deben coincidir con tu pestaña 'Variables' en Railway
                String user = "root";
                String pass = "fxOJJTEZWGLXDUPFXYQCoSAsJTiUHuT";
                
                cn = DriverManager.getConnection(url, user, pass);
            }
            
            System.out.println("✔ ¡Conexión establecida con éxito!");

        } catch (ClassNotFoundException e) {
            System.err.println("❌ Error: No se encontró el Driver de MySQL.");
        } catch (SQLException e) {
            System.err.println("❌ Error de SQL (Credenciales o Red): " + e.getMessage());
        } catch (Exception e) {
            System.err.println("❌ Error General: " + e.getMessage());
        }
        return cn;
    }
}
