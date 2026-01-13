<%@ page import="java.sql.*" %>
<%
if(session.getAttribute("admin_id")==null){
    response.sendRedirect("login_admin.jsp");
    return;
}

int id = Integer.parseInt(request.getParameter("id"));
String metodo = "";
double total = 0;

try{
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/chocolateria_db","root",""
    );

    PreparedStatement ps = con.prepareStatement(
        "SELECT * FROM ventas WHERE venta_id=?"
    );
    ps.setInt(1, id);
    ResultSet rs = ps.executeQuery();

    if(rs.next()){
        metodo = rs.getString("metodo_pago");
        total = rs.getDouble("total");
    }
}catch(Exception e){}
%>

<!DOCTYPE html>
<html>
<head>
<title>Editar Venta</title>
<link rel="stylesheet" href="../style/css/styles.css">
</head>
<body>

<section class="container">
<h2>Editar Venta</h2>

<form method="post" action="venta_update.jsp">
<input type="hidden" name="id" value="<%= id %>">

<label>Total</label>
<input type="number" step="0.01" name="total" value="<%= total %>" required>

<label>Método de pago</label>
<select name="metodo_pago" required>
    <option value="Efectivo" <%= metodo.equals("Efectivo")?"selected":"" %>>Efectivo</option>
    <option value="Tarjeta" <%= metodo.equals("Tarjeta")?"selected":"" %>>Tarjeta</option>
    <option value="Transferencia" <%= metodo.equals("Transferencia")?"selected":"" %>>Transferencia</option>
</select>

<button class="btn">Guardar cambios</button>
</form>
</section>

</body>
</html>
