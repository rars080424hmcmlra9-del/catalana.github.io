<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.Conexion" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Catálogo | La Catalana</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/style/css/styles.css">
</head>
<body>

<jsp:include page="header.jsp"/>

<section class="hero catalogo-hero">
    <div>
        <h2>Nuestro Catálogo</h2>
        <p>Chocolate artesanal hecho con pasión</p>
    </div>
</section>

<section class="container filtros">
    <a href="catalogo.jsp" class="btn filtro">Todos</a>
    <%
        Connection con = null;
        PreparedStatement psCat = null;
        ResultSet rsCat = null;
        
        try {
            // Intentamos obtener la conexión
            con = Conexion.getConexion();
            
            if (con == null) {
                out.println("<p style='color:red; text-align:center;'>⚠️ Error: No se pudo conectar a la base de datos. Verifique los logs de Railway.</p>");
            } else {
                // 1. Mostrar Categorías
                psCat = con.prepareStatement("SELECT * FROM categorias");
                rsCat = psCat.executeQuery();
                while(rsCat.next()){
    %>
        <a href="catalogo.jsp?cat=<%= rsCat.getInt("categoria_id") %>" class="btn filtro">
            <%= rsCat.getString("nombre") %>
        </a>
    <%          } 
            }
        } catch(Exception e) {
            out.println("");
        }
    %>
</section>

<section class="container">
    <div class="productos catalogo">
    <%
        // Solo intentamos cargar productos si hay conexión
        if (con != null) {
            PreparedStatement psProd = null;
            ResultSet rsProd = null;
            try {
                String categoriaFiltro = request.getParameter("cat");
                String sql = "SELECT p.producto_id, p.nombre, p.descripcion, p.precio, i.cantidad_disponible " +
                             "FROM productos p " +
                             "INNER JOIN inventario i ON p.producto_id = i.producto_id ";

                if(categoriaFiltro != null && !categoriaFiltro.isEmpty()){
                    sql += "WHERE p.categoria_id = ?";
                    psProd = con.prepareStatement(sql);
                    psProd.setInt(1, Integer.parseInt(categoriaFiltro));
                } else {
                    psProd = con.prepareStatement(sql);
                }

                rsProd = psProd.executeQuery();
                boolean tieneProductos = false;
                
                while(rsProd.next()){
                    tieneProductos = true;
                    int stock = rsProd.getInt("cantidad_disponible");
    %>
        <div class="producto-card">
            <img src="<%= request.getContextPath() %>/style/img/prod<%= rsProd.getInt("producto_id") %>.jpg" 
                 onerror="this.src='<%= request.getContextPath() %>/style/img/default-choco.jpg'" alt="Chocolate">
            
            <h4><%= rsProd.getString("nombre") %></h4>
            <p><%= rsProd.getString("descripcion") %></p>
            <p class="precio">$<%= String.format("%.2f", rsProd.getBigDecimal("precio")) %></p>
            <p class="stock">Disponibles: <%= stock %></p>

            <% if(stock > 0){ %>
                <form action="agregar_carrito.jsp" method="post">
                    <input type="hidden" name="producto_id" value="<%= rsProd.getInt("producto_id") %>">
                    <button type="submit" class="btn">Agregar al carrito</button>
                </form>
            <% } else { %>
                <p class="sin-stock">Temporalmente Agotado</p>
            <% } %>
        </div>
    <%
                }
                
                if(!tieneProductos) {
                    out.println("<p style='text-align:center; width:100%;'>No hay productos registrados en esta categoría.</p>");
                }

            } catch(Exception e) {
                out.println("<div class='error-box' style='color:red;'>");
                out.println("<h4>Error al cargar productos</h4>");
                out.println("<p>" + e.getMessage() + "</p>");
                out.println("</div>");
            } finally {
                // CERRAMOS TODO para que Railway no bloquee la base de datos por exceso de conexiones
                if(rsCat != null) try { rsCat.close(); } catch(Exception e) {}
                if(psCat != null) try { psCat.close(); } catch(Exception e) {}
                if(rsProd != null) try { rsProd.close(); } catch(Exception e) {}
                if(psProd != null) try { psProd.close(); } catch(Exception e) {}
                if(con != null) try { con.close(); } catch(Exception e) {}
            }
        }
    %>
    </div>
</section>

<footer>
    <p>© 2026 La Catalana Chocolatería Artesanal</p>
</footer>

</body>
</html>
