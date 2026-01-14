package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {

    public static Connection getConexion() {
        Connection cn = null;
        try {
            String host = System.getenv("MYSQL_HOST");
            String port = System.getenv("MYSQL_PORT");
            String user = System.getenv("MYSQL_USER");
            String pass = System.getenv("MYSQL_PASSWORD");

            // 🔥 TU BASE DE DATOS ORIGINAL
            String db = "chocolateria_db";

            String url = "jdbc:mysql://" + host + ":" + port + "/" + db +
                         "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";

            Class.forName("com.mysql.cj.jdbc.Driver");
            cn = DriverManager.getConnection(url, user, pass);

            System.out.println("✔ Conectado a chocolateria_db");

        } catch (Exception e) {
            System.err.println("❌ ERROR BD: " + e.getMessage());
            e.printStackTrace();
        }
        return cn;
    }
}
