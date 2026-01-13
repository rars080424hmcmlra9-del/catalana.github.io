<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.BigDecimal" %>

<%
String ventaParam = request.getParameter("venta");
if(ventaParam == null || ventaParam.isEmpty()){
    response.sendRedirect("catalogo.jsp");
    return;
}

int ventaId = Integer.parseInt(ventaParam);

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

String metodo="", banco="", referencia="", titular="";
BigDecimal total = BigDecimal.ZERO;
%>

<!DOCTYPE html>
<html lang="es">
<head>
<title>Ticket de compra | La Catalana</title>

<style>
body{font-family:Arial;background:#f4f4f4;}
.ticket{
    background:#fff;
    max-width:420px;
    margin:40px auto;
    padding:30px;
    border-radius:10px;
    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
}
table{width:100%;border-collapse:collapse;}
th,td{border-bottom:1px dashed #aaa;padding:6px;font-size:14px;}
.total{text-align:right;font-weight:bold;margin-top:20px; font-size: 1.2em;}
@media print{button{display:none;}}
</style>
</head>

<body>

<div class="ticket">
<h2 style="text-align: center;">La Catalana 🍫</h2>
<p><b>Venta #:</b> <%= ventaId %></p>

<%
try{
    Class.forName("com.mysql.cj.jdbc.Driver");

    // --- INICIO DE CONEXIÓN HÍBRIDA RAILWAY ---
    String dbUrl = System.getenv("MYSQL_URL"); 

    if (dbUrl != null) {
        // Modo Producción (Railway)
        con = DriverManager.getConnection(dbUrl);
    } else {
        // Modo Desarrollo (Tu PC conectándose a Railway)
        String urlPublica = "jdbc:mysql://shinkansen.proxy.rlwy.net:10984/railway?useSSL=false&serverTimezone=UTC";
        con = DriverManager.getConnection(urlPublica, "root", "fxOJJTEZWGLXDUPFXYQCoSAsJTiUHuT");
    }
    // --- FIN DE CONEXIÓN HÍBRIDA ---

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
    <th style="text-align: left;">Producto</th>
    <th>Cant.</th>
    <th style="text-align: right;">Sub</th>
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
    <td style="text-align: center;"><%= rs.getInt("cantidad") %></td>
    <td style="text-align: right;">$<%= sub %></td>
</tr>
<%
    }
} catch(Exception e){
%>
<p>Error al generar el ticket: <%= e.getMessage() %></p>
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

<p style="text-align:center;margin-top:20px;">
¡Gracias por tu compra!<br>
Presenta este ticket en tienda
</p>

<div style="text-align:center; margin-top: 20px;">
<button onclick="window.print()" style="padding: 10px 20px; cursor: pointer;">Imprimir Ticket</button>
<br><br>
<a href="../index.jsp" style="color: brown; text-decoration: none;">Volver al inicio</a>
</div>

</div>
</body>
</html>
