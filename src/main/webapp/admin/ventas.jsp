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
<title>Ventas</title>

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
<h2>Ventas</h2>

<table id="tablaVentas" class="carrito-tabla">
<thead>
<tr>
    <th>ID</th>
    <th>Total</th>
    <th>Método</th>
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
        "SELECT * FROM ventas ORDER BY fecha DESC"
    );
    rs = ps.executeQuery();

    while(rs.next()){
%>
<tr>
    <td><%= rs.getInt("venta_id") %></td>
    <td>$<%= rs.getBigDecimal("total") %></td>
    <td><%= rs.getString("metodo_pago") %></td>
    <td><%= rs.getTimestamp("fecha") %></td>
    <td>
        <!-- Editar -->
        <a href="venta_form.jsp?id=<%= rs.getInt("venta_id") %>" title="Editar">✏️</a>

        <!-- Eliminar -->
        <a href="venta_delete.jsp?id=<%= rs.getInt("venta_id") %>"
           title="Eliminar"
           onclick="return confirm('¿Seguro que deseas eliminar esta venta?');">
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
    $('#tablaVentas').DataTable({
        order: [[3, "desc"]],
        language: {
            url: "https://cdn.datatables.net/plug-ins/1.13.8/i18n/es-ES.json"
        }
    });
});
</script>

</body>
</html>
