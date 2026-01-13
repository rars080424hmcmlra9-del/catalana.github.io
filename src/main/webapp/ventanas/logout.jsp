<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    Integer usuarioId = (Integer) session.getAttribute("usuario_id");
    String ip = request.getRemoteAddr();

    Connection con = null;

    try{
        if(usuarioId != null){

            Class.forName("com.mysql.cj.jdbc.Driver");

            // --- INICIO DE CONEXIÓN HÍBRIDA RAILWAY ---
            String dbUrl = System.getenv("MYSQL_URL"); 

            if (dbUrl != null) {
                // Conexión automática dentro de Railway (Producción)
                con = DriverManager.getConnection(dbUrl);
            } else {
                // Conexión manual desde tu PC -> Railway (Desarrollo)
                String host = "shinkansen.proxy.rlwy.net";
                String port = "10984";
                String dbName = "railway"; 
                String user = "root";
                String pass = "fxOJJTEZWGLXDUPFXYQCoSAsJTiUHuT"; // Tu contraseña de Railway

                String urlPublica = "jdbc:mysql://" + host + ":" + port + "/" + dbName + "?useSSL=false&serverTimezone=UTC";
                con = DriverManager.getConnection(urlPublica, user, pass);
            }
            // --- FIN DE CONEXIÓN HÍBRIDA ---

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO log_usuarios(usuario_id, accion, ip_address) VALUES (?,?,?)"
            );
            ps.setInt(1, usuarioId);
            ps.setString(2, "Cierre de sesión");
            ps.setString(3, ip);
            ps.executeUpdate();
            
            ps.close(); // Buena práctica cerrar el PreparedStatement
        }

    }catch(Exception e){
        e.printStackTrace();
    }finally{
        if(con != null){
            try{ con.close(); }catch(Exception e){}
        }
    }

    // Invalida la sesión del servidor para borrar los datos del usuario
    session.invalidate();
    // Redirige al inicio (nota el uso de ../ para salir de la carpeta actual)
    response.sendRedirect("../index.jsp");
%>
