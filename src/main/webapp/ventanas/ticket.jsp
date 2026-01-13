<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.BigDecimal" %>

<%
int ventaId = Integer.parseInt(request.getParameter("venta"));

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

String metodo="", banco="", referencia="", titular="";
BigDecimal total = BigDecimal.ZERO;
%>

<!DOCTYPE html>
<html lang="es">
<head>
<title>Ticket de compra</title>

<style>
body{font-family:Arial;background:#f4f4f4;}
.ticket{
    background:#fff;
    max-width:420px;
    margin:40px auto;
    padding:30px;
    border-radius:10px;
}
table{width:100%;border-collapse:collapse;}
th,td{border-bottom:1px dashed #aaa;padding:6px;font-size:14px;}
.total{text-align:right;font-weight:bold;margin-top:10px;}
@media print{button{display:none;}}
</style>
</head>

<body>

<div class="ticket">
<h2>La Catalana 🍫</h2>
<p><b>Venta #:</b> <%= ventaId %></p>

<%
try{
    Class.forName("com.mysql.cj.jdbc.Driver");
    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/chocolateria_db?useSSL=false&serverTimezone=UTC",
        "root",""
    );

    /* ===== DATOS DE VENTA ===== */
    ps = con.prepareStatement(
        "SELECT metodo_pago, banco, referencia, titular, total " +
        "FROM ventas WHERE venta_id=?"
    );
    ps.setInt(1, ventaId);
    rs = ps.executeQuery();

    if(rs.next()){
        metodo = rs.getString("metodo_pago");
        banco = rs.getString("banco");
        referencia = rs.getString("referencia");
        titular = rs.getString("titular");
        total = rs.getBigDecimal("total");
    }
    rs.close();
    ps.close();
%>

<p><b>Método de pago:</b> <%= metodo %></p>

<% if("Efectivo".equalsIgnoreCase(metodo)){ %>
<p><em>Paga en tienda presentando este ticket</em></p>

<% } else if("Tarjeta".equalsIgnoreCase(metodo)){ %>
<p><em>Pago realizado con tarjeta</em></p>

<% } else if("Transferencia".equalsIgnoreCase(metodo)){ %>
<p><b>Banco:</b> <%= banco %></p>
<p><b>Referencia:</b> <%= referencia %></p>
<p><b>Titular:</b> <%= titular %></p>
<% } %>

<hr>

<table>
<tr>
    <th>Producto</th>
    <th>Cant.</th>
    <th>Sub</th>
</tr>

<%
    ps = con.prepareStatement(
        "SELECT p.nombre, d.cantidad, d.precio " +
        "FROM venta_detalle d " +
        "JOIN productos p ON d.producto_id=p.producto_id " +
        "WHERE d.venta_id=?"
    );
    ps.setInt(1, ventaId);
    rs = ps.executeQuery();

    while(rs.next()){
        BigDecimal sub =
            rs.getBigDecimal("precio")
              .multiply(new BigDecimal(rs.getInt("cantidad")));
%>
<tr>
    <td><%= rs.getString("nombre") %></td>
    <td><%= rs.getInt("cantidad") %></td>
    <td>$<%= sub %></td>
</tr>
<%
    }
} catch(Exception e){
%>
<p>Error al generar el ticket</p>
<%
    e.printStackTrace();
} finally {
    try{ if(rs!=null) rs.close(); }catch(Exception e){}
    try{ if(ps!=null) ps.close(); }catch(Exception e){}
    try{ if(con!=null) con.close(); }catch(Exception e){}
}
%>

</table>

<p class="total">TOTAL: $<%= total %></p>

<p style="text-align:center;margin-top:10px;">
Presenta este ticket en tienda
</p>

<div style="text-align:center;">
<button onclick="window.print()">Imprimir</button>
</div>

</div>
</body>
</html>
