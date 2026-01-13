<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    String nombre = request.getParameter("nombre");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String telefono = request.getParameter("telefono");
    String direccion = request.getParameter("direccion");
    String ip = request.getRemoteAddr();

    if(nombre != null && email != null && password != null){

        Connection con = null;

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
                String pass = "fxOJJTEZWGLXDUPFXYQCoSAsJTiUHuT"; // Tu contraseña de Railway

                String urlPublica = "jdbc:mysql://" + host + ":" + port + "/" + dbName + "?useSSL=false&serverTimezone=UTC";
                con = DriverManager.getConnection(urlPublica, user, pass);
            }
            // --- FIN DE CONEXIÓN HÍBRIDA ---

            // INSERT USUARIO
            String sql = "INSERT INTO usuarios(nombre,email,password,telefono,direccion) VALUES (?,?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, nombre);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, telefono);
            ps.setString(5, direccion);
            ps.executeUpdate();

            // OBTENER ID (Optimizado usando GeneratedKeys)
            ResultSet rs = ps.getGeneratedKeys();
            int usuarioId = 0;
            if(rs.next()){
                usuarioId = rs.getInt(1);
            }
            rs.close();
            ps.close();

            // LOG
            String sqlLog = "INSERT INTO log_usuarios(usuario_id,accion,ip_address) VALUES (?,?,?)";
            PreparedStatement psLog = con.prepareStatement(sqlLog);
            psLog.setInt(1, usuarioId);
            psLog.setString(2, "Registro de usuario");
            psLog.setString(3, ip);
            psLog.executeUpdate();
            psLog.close();

            response.sendRedirect("../index.jsp?reg=success");

        }catch(Exception e){
            e.printStackTrace();
            response.sendRedirect("../index.jsp?error=registro");
        }finally{
            if(con != null){
                try{ con.close(); }catch(Exception e){}
            }
        }
    }else{
        response.sendRedirect("../index.jsp");
    }
%>
