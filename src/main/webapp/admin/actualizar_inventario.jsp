<%@ page import="java.sql.*" %>
<%
if(session.getAttribute("admin_id")==null){
    response.sendRedirect("login_admin.jsp");
    return;
}

int inventarioId = Integer.parseInt(request.getParameter("inventario_id"));
int cantidad = Integer.parseInt(request.getParameter("cantidad"));

Connection con=null;
PreparedStatement ps=null;

try{
    Class.forName("com.mysql.cj.jdbc.Driver");
    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/chocolateria_db?useSSL=false&serverTimezone=UTC",
        "root",""
    );

    ps = con.prepareStatement(
        "UPDATE inventario " +
        "SET cantidad_disponible=?, ultima_actualizacion=NOW() " +
        "WHERE inventario_id=?"
    );
    ps.setInt(1, cantidad);
    ps.setInt(2, inventarioId);
    ps.executeUpdate();

}catch(Exception e){
    e.printStackTrace();
}finally{
    if(ps!=null) ps.close();
    if(con!=null) con.close();
}

response.sendRedirect("inventario.jsp");
%>
