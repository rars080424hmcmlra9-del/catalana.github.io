<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>

<%
    // Declaramos la conexión fuera del bloque try
    Connection con = null;

    try {
        // Cargamos el driver de MySQL (asegúrate de tener el conector en /lib)
        Class.forName("com.mysql.cj.jdbc.Driver");

        // 1. Intentamos obtener la URL automática de Railway
        String dbUrlRailway = System.getenv("MYSQL_URL"); 

        if (dbUrlRailway != null) {
            // --- MODO PRODUCCIÓN (RAILWAY) ---
            // Si la app corre en Railway, usa la conexión interna por seguridad
            con = DriverManager.getConnection(dbUrlRailway);
        } else {
            // --- MODO DESARROLLO (TU PC -> RAILWAY) ---
            // Si dbUrlRailway es nulo, estamos en tu PC. 
            // Usamos la Public Network con tus credenciales
            
            String host = "shinkansen.proxy.rlwy.net";
            String port = "10984";
            String dbName = "railway"; // Nombre por defecto en Railway
            String user = "root";
            String pass = "fxOJJTEZWGLXDUPFXYQCoSAsJTiUHuT"; // Tu contraseña de la captura

            String urlPublica = "jdbc:mysql://" + host + ":" + port + "/" + dbName + "?useSSL=false&serverTimezone=UTC";
            
            con = DriverManager.getConnection(urlPublica, user, pass);
        }

        // Verificación rápida en la consola del servidor
        if (con != null) {
            System.out.println("¡CONEXIÓN EXITOSA!");
        }

    } catch (Exception e) {
        // Esto mostrará el error en la página y en los Logs de Railway
        out.print("<h3>Error en la conexión:</h3> <p>" + e.getMessage() + "</p>");
        e.printStackTrace();
    }
%>
