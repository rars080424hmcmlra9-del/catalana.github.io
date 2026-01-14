package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.net.URI;

public class Conexion {

    public static Connection getConexion() {
        Connection cn = null;
        try {
            String env = System.getenv("DATABASE_URL");

            if (env == null || env.isEmpty()) {
                // 🔹 LOCAL (XAMPP)
                String url = "jdbc:mysql://localhost:3306/chocolateria_db?useSSL=false&serverTimezone=UTC";
                Class.forName("com.mysql.cj.jdbc.Driver");
                cn = DriverManager.getConnection(url, "root", "");
            } else {
                // 🔥 RAILWAY
                URI dbUri = new URI(env);

                String[] userInfo = dbUri.getUserInfo().split(":");
                String user = userInfo[0];
                String pass = userInfo[1];

                String url = "jdbc:mysql://" + dbUri.getHost() + ":" + dbUri.getPort() +
                             "/chocolateria_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";

                Class.forName("com.mysql.cj.jdbc.Driver");
                cn = DriverManager.getConnection(url, user, pass);
            }

            System.out.println("✔ Conexión OK");

        } catch (Exception e) {
            System.err.println("❌ ERROR BD: " + e.getMessage());
            e.printStackTrace();
        }
        return cn;
    }
}
