<%@ page contentType="text/html; charset=UTF-8" %>
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
<title>Inventario | Admin</title>

<link rel="stylesheet" href="../style/css/styles.css">

<!-- DataTables -->
<link rel="stylesheet"
      href="https://cdn.datatables.net/1.13.8/css/jquery.dataTables.min.css">

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>

<style>
input[type=number]{
    width:80px;
    padding:4px;
}
.btn-guardar{
    padding:5px 10px;
    background:#4CAF50;
    color:#fff;
    border:none;
    cursor:pointer;
}
</style>
</head>

<body>

<section class="container">
<h2>📦 Inventario</h2>

<table id="tablaInventario" class="display carrito-tabla">
<thead>
<tr>
    <th>ID</th>
    <th>Producto</th>
    <th>Stock</th>
    <th>Última actualización</th>
    <th>Acción</th>
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
        "jdbc:mysql://localhost:3306/chocolateria_db?useSSL=false&serverTimezone=UTC",
        "root",""
    );

    ps = con.prepareStatement(
        "SELECT i.inventario_id, p.nombre, i.cantidad_disponible, i.ultima_actualizacion " +
        "FROM inventario i " +
        "JOIN productos p ON i.producto_id=p.producto_id"
    );
    rs = ps.executeQuery();

    while(rs.next()){
%>
<tr>
<form action="actualizar_inventario.jsp" method="post">
    <td><%= rs.getInt("inventario_id") %></td>

    <td><%= rs.getString("nombre") %></td>

    <td>
        <input type="number" name="cantidad"
               value="<%= rs.getInt("cantidad_disponible") %>"
               min="0" required>
    </td>

    <td><%= rs.getTimestamp("ultima_actualizacion") %></td>

    <td>
        <input type="hidden" name="inventario_id"
               value="<%= rs.getInt("inventario_id") %>">
        <button class="btn-guardar">Guardar</button>
    </td>
</form>
</tr>
<%
    }
}catch(Exception e){
    e.printStackTrace();
}finally{
    if(rs!=null) rs.close();
    if(ps!=null) ps.close();
    if(con!=null) con.close();
}
%>
</tbody>
</table>
</section>

<script>
$(document).ready(function(){
    $('#tablaInventario').DataTable({
        language:{
            url:"https://cdn.datatables.net/plug-ins/1.13.8/i18n/es-ES.json"
        }
    });
});
</script>

</body>
</html>
