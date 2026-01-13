<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.*" %>

<%
/* =============================
   VALIDAR USUARIO
   ============================= */
Integer usuarioId = (Integer) session.getAttribute("usuario_id");
if(usuarioId == null){
    response.sendRedirect("login.jsp");
    return;
}

/* =============================
   OBTENER CARRITO (SESSION)
   ============================= */
Map<Integer, Integer> carrito =
    (Map<Integer, Integer>) session.getAttribute("carrito");

if(carrito == null || carrito.isEmpty()){
    response.sendRedirect("carrito.jsp");
    return;
}
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <title>Checkout | La Catalana</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/style/css/styles.css">
</head>
<body>

<jsp:include page="header.jsp"/>

<div class="container">
    <h2 class="title">Confirmar compra</h2>

    <form method="post">
        <p><strong>Método de pago:</strong></p>

        <label>
            <input type="radio" name="metodo_pago" value="EFECTIVO" checked>
            Pago en efectivo (en tienda)
        </label>

        <br><br>

        <button class="btn" type="submit" name="confirmar">
            Confirmar compra
        </button>
    </form>
</div>

<%
/* =============================
   PROCESAR COMPRA
   ============================= */
if(request.getParameter("confirmar") != null){

    Connection con = null;
    PreparedStatement psVenta = null;
    PreparedStatement psDetalle = null;
    ResultSet rsKeys = null;

    BigDecimal total = BigDecimal.ZERO;

    try{
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/chocolateria_db?useSSL=false&serverTimezone=UTC",
            "root",""
        );

        con.setAutoCommit(false);

        /* =============================
           CALCULAR TOTAL
           ============================= */
        for(Integer productoId : carrito.keySet()){
            PreparedStatement psPrecio = con.prepareStatement(
                "SELECT precio FROM productos WHERE producto_id=?"
            );
            psPrecio.setInt(1, productoId);
            ResultSet rsPrecio = psPrecio.executeQuery();

            if(rsPrecio.next()){
                BigDecimal precio = rsPrecio.getBigDecimal("precio");
                int cantidad = carrito.get(productoId);
                total = total.add(precio.multiply(new BigDecimal(cantidad)));
            }
            rsPrecio.close();
            psPrecio.close();
        }

        /* =============================
           INSERTAR VENTA
           ============================= */
        psVenta = con.prepareStatement(
            "INSERT INTO ventas (usuario_id, fecha, total, metodo_pago) VALUES (?, NOW(), ?, ?)",
            Statement.RETURN_GENERATED_KEYS
        );
        psVenta.setInt(1, usuarioId);
        psVenta.setBigDecimal(2, total);
        psVenta.setString(3, "EFECTIVO");
        psVenta.executeUpdate();

        rsKeys = psVenta.getGeneratedKeys();
        int ventaId = 0;
        if(rsKeys.next()){
            ventaId = rsKeys.getInt(1);
        }

        /* =============================
           INSERTAR DETALLES
           ============================= */
        psDetalle = con.prepareStatement(
            "INSERT INTO venta_detalle (venta_id, producto_id, cantidad) VALUES (?, ?, ?)"
        );

        for(Integer productoId : carrito.keySet()){
            psDetalle.setInt(1, ventaId);
            psDetalle.setInt(2, productoId);
            psDetalle.setInt(3, carrito.get(productoId));
            psDetalle.executeUpdate();
        }

        con.commit();

        // LIMPIAR CARRITO
        session.removeAttribute("carrito");

        // IR AL TICKET
        response.sendRedirect("ticket.jsp?venta=" + ventaId);
        return;

    }catch(Exception e){
        if(con != null) con.rollback();
        e.printStackTrace();
    }finally{
        if(rsKeys != null) rsKeys.close();
        if(psVenta != null) psVenta.close();
        if(psDetalle != null) psDetalle.close();
        if(con != null) con.close();
    }
}
%>

<footer>
    © 2026 La Catalana Chocolatería
</footer>

</body>
</html>
