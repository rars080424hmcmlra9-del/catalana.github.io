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
            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/chocolateria_db?useSSL=false&serverTimezone=UTC",
                "root",
                ""
            );

            // INSERT USUARIO
            String sql = "INSERT INTO usuarios(nombre,email,password,telefono,direccion) VALUES (?,?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, nombre);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, telefono);
            ps.setString(5, direccion);
            ps.executeUpdate();

            // OBTENER ID
            String sqlId = "SELECT usuario_id FROM usuarios WHERE email=?";
            PreparedStatement ps2 = con.prepareStatement(sqlId);
            ps2.setString(1, email);
            ResultSet rs = ps2.executeQuery();

            int usuarioId = 0;
            if(rs.next()){
                usuarioId = rs.getInt("usuario_id");
            }

            // LOG
            String sqlLog = "INSERT INTO log_usuarios(usuario_id,accion,ip_address) VALUES (?,?,?)";
            PreparedStatement psLog = con.prepareStatement(sqlLog);
            psLog.setInt(1, usuarioId);
            psLog.setString(2, "Registro de usuario");
            psLog.setString(3, ip);
            psLog.executeUpdate();

            response.sendRedirect("../index.jsp");

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
