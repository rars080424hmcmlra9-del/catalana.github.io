package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {
    public static Connection getConexion() {
        Connection cn = null;
        try {
            // Intentamos obtener la URL de Railway
            String url = System.getenv("MYSQL_URL");
            
            // Si no hay URL de Railway, usamos una configuración local por defecto
            if (url == null) {
                url = "jdbc:mysql://localhost:3306/chocolateria_db?user=root&password=";
            }

            // Cargamos el driver de MySQL (el que pusimos en el pom.xml)
            Class.forName("com.mysql.cj.jdbc.Driver");
            cn = DriverManager.getConnection(url);
            
            System.out.println("Conexión exitosa a la base de datos.");
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("Error en la conexión: " + e.getMessage());
            e.printStackTrace();
        }
        return cn;
    }
}
