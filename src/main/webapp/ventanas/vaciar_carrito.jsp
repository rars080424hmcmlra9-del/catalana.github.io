<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    Integer usuarioId = (Integer) session.getAttribute("usuario_id");

    if(usuarioId == null){
        response.sendRedirect("login.jsp");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;

    try{
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
            String pass = "fxOJJTEZWGLXDUPFXYQCoSAsJTiUHuT";

            String urlPublica = "jdbc:mysql://" + host + ":" + port + "/" + dbName + "?useSSL=false&serverTimezone=UTC";
            con = DriverManager.getConnection(urlPublica, user, pass);
        }
        // --- FIN DE CONEXIÓN HÍBRIDA ---

        /* BORRAR DETALLE */
        ps = con.prepareStatement(
            "DELETE d FROM carrito_detalle d " +
            "JOIN carrito c ON d.carrito_id = c.carrito_id " +
            "WHERE c.usuario_id=?"
        );
        ps.setInt(1, usuarioId);
        ps.executeUpdate();
        ps.close();

        /* BORRAR CARRITO */
        ps = con.prepareStatement("DELETE FROM carrito WHERE usuario_id=?");
        ps.setInt(1, usuarioId);
        ps.executeUpdate();

    }catch(Exception e){
        e.printStackTrace();
    }finally{
        try{ if(ps!=null) ps.close(); }catch(Exception e){}
        try{ if(con!=null) con.close(); }catch(Exception e){}
    }

    /* REGRESAR AL CARRITO */
    response.sendRedirect("carrito.jsp");
%>
