<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.Conexion" %> 
<%
    // Aseguramos que los datos se lean correctamente si hay caracteres especiales
    request.setCharacterEncoding("UTF-8");
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    if(email != null && password != null){
        Connection con = null;
        try {
            con = Conexion.getConexion();

            // Consulta apuntando a la tabla que moviste a 'railway'
            String sql = "SELECT id, nombre FROM usuarios WHERE email=? AND password=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if(rs.next()){
                // LOGIN EXITOSO
                // NOTA: Si en tu tabla la columna se llama 'id', usa rs.getInt("id")
                session.setAttribute("usuario_id", rs.getInt("id"));
                session.setAttribute("nombre", rs.getString("nombre"));
                
                response.sendRedirect("../index.jsp?login=success");
            } else {
                // DATOS INCORRECTOS
                response.sendRedirect("../index.jsp?error=login_incorrecto");
            }
        } catch(Exception e) {
            // En lugar de imprimir en pantalla, redirigimos con el error para no romper el diseño
            System.err.println("Error en Login: " + e.getMessage());
            response.sendRedirect("../index.jsp?error=db");
        } finally {
            if(con != null) try { con.close(); } catch(Exception e) {}
        }
    } else {
        response.sendRedirect("../index.jsp");
    }
%>
