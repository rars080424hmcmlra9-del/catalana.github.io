<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.Conexion" %> 
<%
    request.setCharacterEncoding("UTF-8");
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    if(email != null && password != null){
        Connection con = null;
        try {
            con = Conexion.getConexion();

            // Consulta para la tabla usuarios en el esquema railway
            String sql = "SELECT id, nombre FROM usuarios WHERE email=? AND password=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if(rs.next()){
                // LOGIN EXITOSO
                session.setAttribute("usuario_id", rs.getInt("id"));
                session.setAttribute("nombre", rs.getString("nombre"));
                response.sendRedirect("../index.jsp?login=success");
            } else {
                // DATOS INCORRECTOS
                response.sendRedirect("../index.jsp?error=login_incorrecto");
            }
        } catch(Exception e) {
            // Imprime el error en la consola de Railway (Logs)
            System.err.println("Error en Login: " + e.getMessage());
            response.sendRedirect("../index.jsp?error=db");
        } finally {
            if(con != null) {
                try { 
                    con.close(); 
                } catch(Exception e) {
                    e.printStackTrace();
                }
            }
        }
    } else {
        response.sendRedirect("../index.jsp");
    }
%>
