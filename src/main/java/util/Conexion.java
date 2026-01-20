package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    public static Connection getConexion() {
        Connection cn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 1. Buscamos variables de entorno (Prioridad para Railway)
            String url = System.getenv("MYSQL_URL");
            String user = System.getenv("MYSQLUSER");
            String pass = System.getenv("MYSQLPASSWORD");
            String db = System.getenv("MYSQLDATABASE");
            String host = System.getenv("MYSQLHOST");
            String port = System.getenv("MYSQLPORT");

            // Parámetros obligatorios para evitar errores de SSL y Zona horaria
            String params = "?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";

            if (url != null && !url.isEmpty()) {
                // CASO 1: Railway nos da la URL completa (MYSQL_URL)
                // A veces la URL de Railway empieza con mysql:// y JDBC necesita jdbc:mysql://
                String jdbcUrl = url.startsWith("jdbc:") ? url : "jdbc:" + url;
                
                // Si la URL ya tiene parámetros, usamos & para agregar los nuestros, si no, usamos ?
                String conector = jdbcUrl.contains("?") ? "&" : "";
                
                cn = DriverManager.getConnection(jdbcUrl + conector + "allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC");
                System.out.println("✔ Conectado usando MYSQL_URL de Railway");

            } else if (host != null && user != null) {
                // CASO 2: Railway nos da las variables por separado (Host, User, Pass)
                String urlConstruida = "jdbc:mysql://" + host + ":" + port + "/" + db + params;
                cn = DriverManager.getConnection(urlConstruida, user, pass);
                System.out.println("✔ Conectado usando variables desglosadas (HOST, USER...)");

            } else {
                // CASO 3: MODO LOCAL (Tu PC) - Aquí corregimos el error de sintaxis
                // NOTA: Nunca subas contraseñas reales a GitHub. Usa variables de entorno también en local si es posible.
                String urlLocal = "jdbc:mysql://shinkansen.proxy.rlwy.net:10984/chocolateria_db" + params;
                String userLocal = "root";
                String passLocal = "fxOJJTEZWGLXDUPFXYQCoSAsJTiUHuT"; // Tu contraseña

                cn = DriverManager.getConnection(urlLocal, userLocal, passLocal);
                System.out.println("✔ Conectado usando configuración MANUAL / LOCAL");
            }

        } catch (ClassNotFoundException e) {
            System.err.println("❌ Error: Driver no encontrado. " + e.getMessage());
        } catch (SQLException e) {
            System.err.println("❌ Error SQL: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("❌ Error General: " + e.getMessage());
        }
        return cn;
    }
}
