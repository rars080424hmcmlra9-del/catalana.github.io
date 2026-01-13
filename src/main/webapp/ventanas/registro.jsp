<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.Conexion" %> <%
    String nombre = request.getParameter("nombre");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String telefono = request.getParameter("telefono");
    String direccion = request.getParameter("direccion");
    String ip = request.getRemoteAddr();

    if(nombre != null && email != null && password != null){
        Connection con = null;
        try {
            // USAMOS LA CONEXIÓN CENTRALIZADA (Ya no necesitas System.getenv aquí)
            con = Conexion.getConexion();

            // INSERT USUARIO
            String sql = "INSERT INTO usuarios(nombre,email,password,telefono,direccion) VALUES (?,?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, nombre);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, telefono);
            ps.setString(5, direccion);
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            int usuarioId = 0;
            if(rs.next()){ usuarioId = rs.getInt(1); }
            
            // LOG
            String sqlLog = "INSERT INTO log_usuarios(usuario_id,accion,ip_address) VALUES (?,?,?)";
            PreparedStatement psLog = con.prepareStatement(sqlLog);
            psLog.setInt(1, usuarioId);
            psLog.setString(2, "Registro de usuario");
            psLog.setString(3, ip);
            psLog.executeUpdate();

            response.sendRedirect("../index.jsp?reg=success");

        } catch(Exception e) {
            e.printStackTrace();
            response.sendRedirect("../index.jsp?error=" + e.getMessage());
        } finally {
            if(con != null) try { con.close(); } catch(Exception e) {}
        }
    } else {
        response.sendRedirect("../index.jsp");
    }
%>
