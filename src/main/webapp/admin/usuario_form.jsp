<%@ page import="java.sql.*" %>
<%
if(session.getAttribute("admin_id")==null){
    response.sendRedirect("login_admin.jsp");
    return;
}

int id = Integer.parseInt(request.getParameter("id"));
String nombre="", email="";

try{
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/chocolateria_db","root",""
    );

    PreparedStatement ps = con.prepareStatement(
        "SELECT * FROM usuarios WHERE usuario_id=?"
    );
    ps.setInt(1, id);
    ResultSet rs = ps.executeQuery();

    if(rs.next()){
        nombre = rs.getString("nombre");
        email = rs.getString("email");
    }
}catch(Exception e){ }
%>

<!DOCTYPE html>
<html>
<head>
<title>Editar usuario</title>
<link rel="stylesheet" href="../style/css/styles.css">
</head>
<body>

<section class="container">
<h2>Editar Usuario</h2>

<form method="post" action="usuario_update.jsp">
<input type="hidden" name="id" value="<%= id %>">

<label>Nombre</label>
<input type="text" name="nombre" value="<%= nombre %>" required>

<label>Email</label>
<input type="email" name="email" value="<%= email %>" required>

<button class="btn">Guardar cambios</button>
</form>
</section>

</body>
</html>
