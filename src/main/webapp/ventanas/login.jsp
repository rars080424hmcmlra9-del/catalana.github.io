<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.Conexion" %> <%
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    if(email != null && password != null){
        Connection con = null;
        try {
            // Llamamos a la conexión centralizada
            con = Conexion.getConexion();

            String sql = "SELECT * FROM usuarios WHERE email=? AND password=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if(rs.next()){
                // LOGIN EXITOSO
                session.setAttribute("usuario_id", rs.getInt("usuario_id"));
                session.setAttribute("nombre", rs.getString("nombre"));
                response.sendRedirect("../index.jsp");
            } else {
                // DATOS INCORRECTOS
                response.sendRedirect("../index.jsp?error=login");
            }
        } catch(Exception e) {
            out.println("Error: " + e.getMessage());
        } finally {
            if(con != null) con.close();
        }
    }
%>
