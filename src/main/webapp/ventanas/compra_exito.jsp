<%@ page contentType="text/html; charset=UTF-8" %>
<%
    Integer usuarioId = (Integer) session.getAttribute("usuario_id");
    if(usuarioId == null){
        response.sendRedirect("../index.jsp");
        return;
    }

    // Datos enviados desde procesar_compra.jsp
    String metodoPago = request.getParameter("metodo_pago");
    String ventaId = request.getParameter("venta");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <title>Compra exitosa | La Catalana</title>
    <link rel="stylesheet" href="../style/css/styles.css">

    <style>
        .exito-box{
            max-width:600px;
            margin:80px auto;
            background:#fff;
            padding:40px;
            border-radius:12px;
            text-align:center;
            box-shadow:0 10px 30px rgba(0,0,0,.1);
        }
        .exito-box h2{
            color:#2e7d32;
            margin-bottom:15px;
        }
        .exito-box p{
            font-size:16px;
            margin-bottom:10px;
        }
        .acciones{
            margin-top:25px;
        }
        .acciones a{
            margin:6px;
            display:inline-block;
        }
    </style>
</head>
<body>

<jsp:include page="header.jsp"/>

<div class="exito-box">
    <h2>¡Compra realizada con éxito! 🎉</h2>

    <p><strong>Número de venta:</strong> #<%= ventaId %></p>
    <p><strong>Método de pago:</strong> <%= metodoPago %></p>

    <% if("Efectivo".equalsIgnoreCase(metodoPago)){ %>
        <p>
            Tu pedido quedó registrado.<br>
            Presenta el ticket en tienda para realizar el pago en efectivo.
        </p>
    <% } else { %>
        <p>
            Tu pago fue registrado correctamente.<br>
            En breve recibirás la confirmación por correo.
        </p>
    <% } %>

    <div class="acciones">
        <!-- Ticket imprimible -->
        <a href="ticket.jsp?venta=<%= ventaId %>" target="_blank" class="btn">
            Ver / Imprimir ticket
        </a>

        <!-- Volver a comprar -->
        <a href="catalogo.jsp" class="btn btn-secundario">
            Seguir comprando
        </a>
    </div>
</div>

<footer>
    © 2026 La Catalana Chocolatería
</footer>

</body>
</html>
