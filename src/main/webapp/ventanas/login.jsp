<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String ip = request.getRemoteAddr();

    if(email != null && password != null){

        Connection con = null;

        try{
            // DRIVER
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

            // LLAMAR SP (Asegúrate de haber importado el SP en Railway)
            CallableStatement cs = con.prepareCall("{CALL sp_login_usuario(?,?,?)}");
            cs.setString(1, email);
            cs.setString(2, password);
            cs.setString(3, ip);

            ResultSet rs = cs.executeQuery();

            if(rs.next() && "success".equals(rs.getString("status"))){

                session.setAttribute("usuario_id", rs.getInt("usuario_id"));
                session.setAttribute("nombre", rs.getString("nombre"));
                session.setAttribute("email", rs.getString("email"));

                response.sendRedirect("../index.jsp");
            }else{
                response.sendRedirect("../index.jsp?error=1");
            }

        }catch(Exception e){
            e.printStackTrace();
            response.sendRedirect("../index.jsp?error=2");
        }finally{
            if(con != null){
                try{ con.close(); }catch(Exception e){}
            }
        }

    }else{
        response.sendRedirect("../index.jsp");
    }
%>
