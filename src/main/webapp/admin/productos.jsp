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
<title>Productos</title>

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
<h2>Productos</h2>

<a class="btn" href="producto_form.jsp">➕ Nuevo producto</a>

<table id="tablaProductos" class="carrito-tabla">
<thead>
<tr>
    <th>ID</th>
    <th>Nombre</th>
    <th>Precio</th>
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

    ps = con.prepareStatement("SELECT * FROM productos");
    rs = ps.executeQuery();

    while(rs.next()){
%>
<tr>
    <td><%= rs.getInt("producto_id") %></td>
    <td><%= rs.getString("nombre") %></td>
    <td>$<%= rs.getBigDecimal("precio") %></td>
    <td>
        <!-- Editar -->
        <a href="producto_form.jsp?id=<%= rs.getInt("producto_id") %>" title="Editar">✏️</a>

        <!-- Eliminar -->
        <a href="producto_delete.jsp?id=<%= rs.getInt("producto_id") %>"
           title="Eliminar"
           onclick="return confirm('¿Seguro que deseas eliminar este producto?');">
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
    $('#tablaProductos').DataTable({
        language: {
            url: "https://cdn.datatables.net/plug-ins/1.13.8/i18n/es-ES.json"
        }
    });
});
</script>

</body>
</html>
