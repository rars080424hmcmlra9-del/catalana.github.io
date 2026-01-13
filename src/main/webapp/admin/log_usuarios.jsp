<%@ page import="java.sql.*" %>
<%
if(session.getAttribute("admin_id")==null){
    response.sendRedirect("login_admin.jsp");
    return;
}
%>

<!DOCTYPE html>
<html lang="es">
<head>
<title>Log de Usuarios</title>

<link rel="stylesheet" href="../style/css/styles.css">

<!-- DataTables CSS -->
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.8/css/jquery.dataTables.min.css">

<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<!-- DataTables JS -->
<script src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>
</head>

<body>

<section class="container">
<h2>Registro de Actividad de Usuarios</h2>

<table id="tablaLogs" class="carrito-tabla">
<thead>
<tr>
    <th>ID</th>
    <th>ID Usuario</th>
    <th>Acción</th>
    <th>IP</th>
    <th>Fecha</th>
    <th>Acciones</th>
</tr>
</thead>

<tbody>
<%
Connection con=null;
PreparedStatement ps=null;
ResultSet rs=null;

try{
    Class.forName("com.mysql.cj.jdbc.Driver");
    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/chocolateria_db","root",""
    );

    ps = con.prepareStatement(
        "SELECT * FROM log_usuarios ORDER BY fecha_evento DESC"
    );
    rs = ps.executeQuery();

    while(rs.next()){
%>
<tr>
    <td><%= rs.getInt("log_id") %></td>
    <td><%= rs.getInt("usuario_id") %></td>
    <td><%= rs.getString("accion") %></td>
    <td><%= rs.getString("ip_address") %></td>
    <td><%= rs.getTimestamp("fecha_evento") %></td>
    <td>
        <!-- Eliminar -->
        <a href="log_delete.jsp?id=<%= rs.getInt("log_id") %>"
           title="Eliminar"
           onclick="return confirm('¿Seguro que deseas eliminar este registro del log?');">
           🗑️
        </a>
    </td>
</tr>
<%
    }
}catch(Exception e){
    out.println("Error: " + e.getMessage());
}
%>
</tbody>
</table>
</section>

<script>
$(document).ready(function () {
    $('#tablaLogs').DataTable({
        order: [[4, "desc"]],
        language: {
            url: "https://cdn.datatables.net/plug-ins/1.13.8/i18n/es-ES.json"
        }
    });
});
</script>

</body>
</html>
