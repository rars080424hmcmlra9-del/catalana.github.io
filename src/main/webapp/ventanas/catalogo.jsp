<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="es">
<head>
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
    PreparedStatement psProd = null;
    ResultSet rsProd = null;

    try{
        Class.forName("com.mysql.cj.jdbc.Driver");

        // --- INICIO DE CONEXIÓN HÍBRIDA RAILWAY ---
        String dbUrl = System.getenv("MYSQL_URL"); 

        if (dbUrl != null) {
            // Conexión automática dentro de Railway
            con = DriverManager.getConnection(dbUrl);
        } else {
            // Conexión manual para tu PC -> Railway
            String urlPublica = "jdbc:mysql://shinkansen.proxy.rlwy.net:10984/railway?useSSL=false&serverTimezone=UTC";
            con = DriverManager.getConnection(urlPublica, "root", "fxOJJTEZWGLXDUPFXYQCoSAsJTiUHuT");
        }
        // --- FIN DE CONEXIÓN HÍBRIDA ---

        // Consulta de Categorías
        psCat = con.prepareStatement("SELECT * FROM categorias");
        rsCat = psCat.executeQuery();

        while(rsCat.next()){
%>
        <a href="catalogo.jsp?cat=<%= rsCat.getInt("categoria_id") %>" class="btn filtro">
            <%= rsCat.getString("nombre") %>
        </a>
<%
        }
%>
</section>

<section class="container">
    <div class="productos catalogo">

<%
        String categoriaFiltro = request.getParameter("cat");

        String sql =
            "SELECT p.producto_id, p.nombre, p.descripcion, p.precio, i.cantidad_disponible " +
            "FROM productos p " +
            "INNER JOIN inventario i ON p.producto_id = i.producto_id ";

        if(categoriaFiltro != null){
            sql += "WHERE p.categoria_id = ?";
            psProd = con.prepareStatement(sql);
            psProd.setInt(1, Integer.parseInt(categoriaFiltro));
        }else{
            psProd = con.prepareStatement(sql);
        }

        rsProd = psProd.executeQuery();

        while(rsProd.next()){
            int stock = rsProd.getInt("cantidad_disponible");
%>
        <div class="producto-card">

            <img src="<%= request.getContextPath() %>/style/img/prod<%= rsProd.getInt("producto_id") %>.jpg"
                 alt="<%= rsProd.getString("nombre") %>">

            <h4><%= rsProd.getString("nombre") %></h4>
            <p><%= rsProd.getString("descripcion") %></p>

            <p class="precio">$<%= rsProd.getBigDecimal("precio") %></p>

            <p class="stock">
                Stock: <%= stock %>
            </p>

            <% if(stock > 0){ %>
            <form action="agregar_carrito.jsp" method="post">
                <input type="hidden" name="producto_id"
                       value="<%= rsProd.getInt("producto_id") %>">
                <button type="submit" class="btn">Agregar</button>
            </form>
            <% } else { %>
                <p class="sin-stock">Producto agotado</p>
            <% } %>

        </div>
<%
        }
    }catch(Exception e){
        e.printStackTrace();
    }finally{
        if(rsProd != null) rsProd.close();
        if(psProd != null) psProd.close();
        if(rsCat != null) rsCat.close();
        if(psCat != null) psCat.close();
        if(con != null) con.close();
    }
%>

    </div>
</section>

<footer>
    © 2026 La Catalana Chocolatería
</footer>

</body>
</html>
