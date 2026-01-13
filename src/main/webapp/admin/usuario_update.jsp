<%@ page import="java.sql.*" %>
<%
if(session.getAttribute("admin_id")==null){
    response.sendRedirect("login_admin.jsp");
    return;
}

int id = Integer.parseInt(request.getParameter("id"));
String nombre = request.getParameter("nombre");
String email = request.getParameter("email");

try{
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/chocolateria_db","root",""
    );

    PreparedStatement ps = con.prepareStatement(
        "UPDATE usuarios SET nombre=?, email=? WHERE usuario_id=?"
    );
    ps.setString(1, nombre);
    ps.setString(2, email);
    ps.setInt(3, id);
    ps.executeUpdate();

    response.sendRedirect("usuarios.jsp");

}catch(Exception e){
    out.println("Error: " + e.getMessage());
}
%>
