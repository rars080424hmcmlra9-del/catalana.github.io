<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    // Validar sesión
    Integer usuarioId = (Integer) session.getAttribute("usuario_id");
    if(usuarioId == null){
        response.sendRedirect("login.jsp");
        return;
    }

    // Validar parámetro producto_id
    String prodParam = request.getParameter("producto_id");
    if(prodParam == null || prodParam.isEmpty()){
        response.sendRedirect("catalogo.jsp");
        return;
    }

    int productoId = 0;
    int cantidad = 1;

    try {
        productoId = Integer.parseInt(prodParam);

        String cantParam = request.getParameter("cantidad");
        if(cantParam != null && !cantParam.isEmpty()){
            cantidad = Integer.parseInt(cantParam);
        }
    } catch (NumberFormatException e) {
        response.sendRedirect("catalogo.jsp");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/chocolateria_db?useSSL=false&serverTimezone=UTC",
            "root",""
        );

        // Buscar carrito
        String sqlCarrito = "SELECT carrito_id FROM carrito WHERE usuario_id=?";
        ps = con.prepareStatement(sqlCarrito);
        ps.setInt(1, usuarioId);
        rs = ps.executeQuery();

        int carritoId;
        if(rs.next()){
            carritoId = rs.getInt("carrito_id");
        } else {
            rs.close();
            ps.close();

            // Crear carrito
            String sqlNuevo = "INSERT INTO carrito(usuario_id, fecha_creacion) VALUES (?, NOW())";
            ps = con.prepareStatement(sqlNuevo, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, usuarioId);
            ps.executeUpdate();

            rs = ps.getGeneratedKeys();
            if(rs.next()){
                carritoId = rs.getInt(1);
            } else {
                throw new Exception("No se pudo crear carrito");
            }
        }

        rs.close();
        ps.close();

        // Verificar si el producto ya existe
        String sqlDetalle = "SELECT detalle_id FROM carrito_detalle WHERE carrito_id=? AND producto_id=?";
        ps = con.prepareStatement(sqlDetalle);
        ps.setInt(1, carritoId);
        ps.setInt(2, productoId);
        rs = ps.executeQuery();

        if(rs.next()){
            int detalleId = rs.getInt("detalle_id");
            rs.close();
            ps.close();

            String sqlUpdate = "UPDATE carrito_detalle SET cantidad = cantidad + ? WHERE detalle_id=?";
            ps = con.prepareStatement(sqlUpdate);
            ps.setInt(1, cantidad);
            ps.setInt(2, detalleId);
            ps.executeUpdate();
        } else {
            rs.close();
            ps.close();

            String sqlInsert = "INSERT INTO carrito_detalle(carrito_id, producto_id, cantidad) VALUES (?,?,?)";
            ps = con.prepareStatement(sqlInsert);
            ps.setInt(1, carritoId);
            ps.setInt(2, productoId);
            ps.setInt(3, cantidad);
            ps.executeUpdate();
        }

        // Redirigir al carrito
        response.sendRedirect("carrito.jsp");

    } catch(Exception e){
        e.printStackTrace();
        response.sendRedirect("error.jsp?msg=" + e.getMessage());
    } finally {
        try { if(rs != null) rs.close(); } catch(Exception e){}
        try { if(ps != null) ps.close(); } catch(Exception e){}
        try { if(con != null) con.close(); } catch(Exception e){}
    }
%>
