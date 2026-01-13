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
    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/chocolateria_db?useSSL=false&serverTimezone=UTC",
        "root",""
    );

    /* BORRAR DETALLE */
    ps = con.prepareStatement(
        "DELETE d FROM carrito_detalle d " +
        "JOIN carrito c ON d.carrito_id = c.carrito_id " +
        "WHERE c.usuario_id=?"
    );
    ps.setInt(1, usuarioId);
    ps.executeUpdate();

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
