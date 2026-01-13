<%@ page import="java.sql.*" %>
<%
if(session.getAttribute("admin_id")==null){
    response.sendRedirect("login_admin.jsp");
    return;
}

int id = Integer.parseInt(request.getParameter("id"));

try{
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/chocolateria_db","root",""
    );

    PreparedStatement ps = con.prepareStatement(
        "DELETE FROM log_usuarios WHERE log_id=?"
    );
    ps.setInt(1, id);
    ps.executeUpdate();

    response.sendRedirect("log_usuarios.jsp");

}catch(Exception e){
    out.println("Error al eliminar: " + e.getMessage());
}
%>
