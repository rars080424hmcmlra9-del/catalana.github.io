<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.BigDecimal" %>

<%
    Integer usuarioId = (Integer) session.getAttribute("usuario_id");
    if(usuarioId == null){
        response.sendRedirect("login.jsp");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    BigDecimal total = BigDecimal.ZERO;
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mi Carrito | La Catalana</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/style/css/styles.css">

    <style>
        .transferencia-box, .tarjeta-box{
            display:none;
            margin-top:15px;
            background:#f9f9f9;
            padding:15px;
            border-radius:8px;
        }
        .transferencia-box label,
        .tarjeta-box label{
            display:block;
            margin-top:10px;
            font-weight:600;
        }
        .transferencia-box input,
        .tarjeta-box input{
            width:100%;
            padding:8px;
            margin-top:5px;
        }
        .acciones-carrito{
            margin:15px 0;
            text-align:right;
        }
    </style>
</head>
<body>

<jsp:include page="header.jsp"/>

<section class="container">
    <h2 class="title">Mi carrito</h2>

    <form action="procesar_compra.jsp" method="post">

        <!-- TABLA CARRITO -->
        <table class="carrito-tabla">
            <thead>
                <tr>
                    <th>Producto</th>
                    <th>Precio</th>
                    <th>Cantidad</th>
                    <th>Subtotal</th>
                </tr>
            </thead>
            <tbody>

<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/chocolateria_db?useSSL=false&serverTimezone=UTC",
            "root", ""
        );

        String sql =
            "SELECT p.nombre, p.precio, d.cantidad " +
            "FROM carrito c " +
            "JOIN carrito_detalle d ON c.carrito_id = d.carrito_id " +
            "JOIN productos p ON d.producto_id = p.producto_id " +
            "WHERE c.usuario_id=?";

        ps = con.prepareStatement(sql);
        ps.setInt(1, usuarioId);
        rs = ps.executeQuery();

        boolean hayProductos = false;

        while(rs.next()){
            hayProductos = true;
            BigDecimal precio = rs.getBigDecimal("precio");
            int cantidad = rs.getInt("cantidad");
            BigDecimal subtotal = precio.multiply(new BigDecimal(cantidad));
            total = total.add(subtotal);
%>
                <tr>
                    <td><%= rs.getString("nombre") %></td>
                    <td>$<%= precio %></td>
                    <td><%= cantidad %></td>
                    <td>$<%= subtotal %></td>
                </tr>
<%
        }

        if(!hayProductos){
%>
                <tr>
                    <td colspan="4" style="text-align:center;">
                        Tu carrito está vacío 🛒
                    </td>
                </tr>
<%
        }

    } catch(Exception e){
        e.printStackTrace();
%>
                <tr>
                    <td colspan="4" style="text-align:center;">
                        Error al cargar el carrito.
                    </td>
                </tr>
<%
    } finally {
        try { if(rs != null) rs.close(); } catch(Exception e){}
        try { if(ps != null) ps.close(); } catch(Exception e){}
        try { if(con != null) con.close(); } catch(Exception e){}
    }
%>

            </tbody>
            <tfoot>
                <tr class="total">
                    <td colspan="3"><strong>Total</strong></td>
                    <td><strong>$<%= total %></strong></td>
                </tr>
            </tfoot>
        </table>

        <!-- VACIAR CARRITO -->
        <div class="acciones-carrito">
            <a href="vaciar_carrito.jsp"
               class="btn btn-danger"
               onclick="return confirm('¿Seguro que deseas vaciar el carrito?');">
                Vaciar carrito
            </a>
        </div>

        <input type="hidden" name="total" value="<%= total %>">

        <!-- MÉTODO DE PAGO -->
        <div class="pago-box">
            <label>Método de pago</label>
            <select name="metodo_pago" id="metodo_pago" required onchange="mostrarPago()">
                <option value="">Selecciona</option>
                <option value="Efectivo">Efectivo</option>
                <option value="Tarjeta">Tarjeta</option>
                <option value="Transferencia">Transferencia</option>
            </select>

            <!-- TRANSFERENCIA -->
            <div class="transferencia-box" id="transferenciaBox">
                <p><strong>Datos de transferencia</strong></p>
                <label>Banco</label>
                <input type="text" name="banco">
                <label>Referencia</label>
                <input type="text" name="referencia">
                <label>Titular</label>
                <input type="text" name="titular">
            </div>

            <!-- TARJETA -->
            <div class="tarjeta-box" id="tarjetaBox">
                <p><strong>Datos de tarjeta</strong></p>
                <label>Número</label>
                <input type="text" name="tarjeta_numero" maxlength="19">
                <label>Titular</label>
                <input type="text" name="tarjeta_titular">
                <label>Vencimiento</label>
                <input type="text" name="tarjeta_fecha" placeholder="MM/AA">
                <label>CVV</label>
                <input type="password" name="tarjeta_cvv" maxlength="4">
            </div>

            <button class="btn" type="submit"
                <%= total.compareTo(BigDecimal.ZERO)==0 ? "disabled" : "" %>>
                Confirmar compra
            </button>
           <a href="catalogo.jsp" class="btn">Seguir comprando</a>
        </div>
    </form>
</section>

<footer>© 2026 La Catalana Chocolatería</footer>

<script>
function mostrarPago(){
    const metodo = document.getElementById("metodo_pago").value;
    document.getElementById("transferenciaBox").style.display = "none";
    document.getElementById("tarjetaBox").style.display = "none";

    if(metodo === "Transferencia"){
        document.getElementById("transferenciaBox").style.display = "block";
    }
    if(metodo === "Tarjeta"){
        document.getElementById("tarjetaBox").style.display = "block";
    }
}
</script>

</body>
</html>
