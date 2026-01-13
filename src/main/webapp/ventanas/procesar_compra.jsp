<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.Properties" %>
<%@ page import="javax.mail.*" %>
<%@ page import="javax.mail.internet.*" %>

<%
Integer usuarioId = (Integer) session.getAttribute("usuario_id");
String correoUsuario = (String) session.getAttribute("email");

if(usuarioId == null || correoUsuario == null){
    response.sendRedirect("../index.jsp");
    return;
}

/* ===== DATOS DEL FORM ===== */
String metodoPago = request.getParameter("metodo_pago");
BigDecimal total = new BigDecimal(request.getParameter("total"));

// SOLO PARA TRANSFERENCIA
String banco = request.getParameter("banco");
String referencia = request.getParameter("referencia");
String titular = request.getParameter("titular");

Connection con = null;
PreparedStatement psVenta = null;
PreparedStatement psCarrito = null;
PreparedStatement psDetalle = null;
PreparedStatement psDelete = null;
ResultSet rs = null;

int ventaId = 0;

try{
    Class.forName("com.mysql.cj.jdbc.Driver");
    
    // --- NUEVA LÓGICA DE CONEXIÓN PARA RAILWAY ---
    String dbUrl = System.getenv("MYSQL_URL"); 

    if (dbUrl != null) {
        // Conexión interna automática en Railway
        con = DriverManager.getConnection(dbUrl);
    } else {
        // Conexión manual desde tu PC a Railway usando tus datos
        String urlPublica = "jdbc:mysql://shinkansen.proxy.rlwy.net:10984/railway?useSSL=false&serverTimezone=UTC";
        con = DriverManager.getConnection(urlPublica, "root", "fxOJJTEZWGLXDUPFXYQCoSAsJTiUHuT");
    }
    // ----------------------------------------------

    con.setAutoCommit(false); // 🔐 TRANSACCIÓN

    /* ===== INSERTAR VENTA ===== */
    psVenta = con.prepareStatement(
        "INSERT INTO ventas(usuario_id, total, metodo_pago, banco, referencia, titular) " +
        "VALUES (?,?,?,?,?,?)",
        Statement.RETURN_GENERATED_KEYS
    );

    psVenta.setInt(1, usuarioId);
    psVenta.setBigDecimal(2, total);
    psVenta.setString(3, metodoPago);
    psVenta.setString(4, banco);
    psVenta.setString(5, referencia);
    psVenta.setString(6, titular);
    psVenta.executeUpdate();

    rs = psVenta.getGeneratedKeys();
    if(rs.next()){
        ventaId = rs.getInt(1);
    }

    /* ===== OBTENER CARRITO ===== */
    psCarrito = con.prepareStatement(
        "SELECT d.producto_id, p.nombre, p.precio, d.cantidad " +
        "FROM carrito c " +
        "JOIN carrito_detalle d ON c.carrito_id = d.carrito_id " +
        "JOIN productos p ON d.producto_id = p.producto_id " +
        "WHERE c.usuario_id=?"
    );
    psCarrito.setInt(1, usuarioId);
    rs = psCarrito.executeQuery();

    /* ===== INSERTAR DETALLE ===== */
    psDetalle = con.prepareStatement(
        "INSERT INTO venta_detalle (venta_id, producto_id, cantidad, precio) VALUES (?,?,?,?)"
    );

    StringBuilder ticket = new StringBuilder();
    ticket.append("<h2>Ticket de compra - La Catalana</h2>");
    ticket.append("<p><b>Venta #:</b> ").append(ventaId).append("</p>");
    ticket.append("<p><b>Método de pago:</b> ").append(metodoPago).append("</p>");

    if("Transferencia".equalsIgnoreCase(metodoPago)){
        ticket.append("<p><b>Banco:</b> ").append(banco).append("</p>");
        ticket.append("<p><b>Referencia:</b> ").append(referencia).append("</p>");
        ticket.append("<p><b>Titular:</b> ").append(titular).append("</p>");
    }

    ticket.append("<table border='1' cellpadding='6'>");
    ticket.append("<tr><th>Producto</th><th>Precio</th><th>Cantidad</th><th>Subtotal</th></tr>");

    while(rs.next()){
        int productoId = rs.getInt("producto_id");
        String nombre = rs.getString("nombre");
        BigDecimal precio = rs.getBigDecimal("precio");
        int cantidad = rs.getInt("cantidad");
        BigDecimal subtotal = precio.multiply(new BigDecimal(cantidad));

        psDetalle.setInt(1, ventaId);
        psDetalle.setInt(2, productoId);
        psDetalle.setInt(3, cantidad);
        psDetalle.setBigDecimal(4, precio);
        psDetalle.executeUpdate();

        ticket.append("<tr>")
              .append("<td>").append(nombre).append("</td>")
              .append("<td>$").append(precio).append("</td>")
              .append("<td>").append(cantidad).append("</td>")
              .append("<td>$").append(subtotal).append("</td>")
              .append("</tr>");
    }

    ticket.append("</table>");
    ticket.append("<h3>Total: $").append(total).append("</h3>");

    /* ===== VACIAR CARRITO ===== */
    psDelete = con.prepareStatement(
        "DELETE d FROM carrito_detalle d " +
        "JOIN carrito c ON d.carrito_id = c.carrito_id " +
        "WHERE c.usuario_id=?"
    );
    psDelete.setInt(1, usuarioId);
    psDelete.executeUpdate();

    psDelete = con.prepareStatement("DELETE FROM carrito WHERE usuario_id=?");
    psDelete.setInt(1, usuarioId);
    psDelete.executeUpdate();

    /* ===== EMAIL ===== */
    final String remitente = "chocolaterialacatalana@gmail.com";
    final String clave = "sylxpcyqjdeendaj";
    String correoAdmin = "chocolaterialacatalana@gmail.com";

    Properties props = new Properties();
    props.put("mail.smtp.auth","true");
    props.put("mail.smtp.starttls.enable","true");
    props.put("mail.smtp.host","smtp.gmail.com");
    props.put("mail.smtp.port","587");

    Session mailSession = Session.getInstance(props,
        new Authenticator(){
            protected PasswordAuthentication getPasswordAuthentication(){
                return new PasswordAuthentication(remitente, clave);
            }
        }
    );

    Message mensaje = new MimeMessage(mailSession);
    mensaje.setFrom(new InternetAddress(remitente));
    mensaje.setRecipients(
        Message.RecipientType.TO,
        InternetAddress.parse(correoUsuario + "," + correoAdmin)
    );
    mensaje.setSubject("Ticket de compra - La Catalana");
    mensaje.setContent(ticket.toString(), "text/html; charset=UTF-8");

    Transport.send(mensaje);

    con.commit(); // ✅ OK

}catch(Exception e){
    if(con != null) con.rollback();
    e.printStackTrace();
}finally{
    if(rs!=null) rs.close();
    if(psVenta!=null) psVenta.close();
    if(psCarrito!=null) psCarrito.close();
    if(psDetalle!=null) psDetalle.close();
    if(psDelete!=null) psDelete.close();
    if(con!=null) con.close();
}

/* ===== REDIRECCIÓN ===== */
response.sendRedirect(
    "compra_exito.jsp?venta=" + ventaId + "&metodo_pago=" + metodoPago
);
%>
