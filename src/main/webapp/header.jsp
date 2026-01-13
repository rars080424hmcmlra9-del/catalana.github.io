<%@ page contentType="text/html; charset=UTF-8" %>

<header class="site-header">

    <div class="logo">
        <img src="<%= request.getContextPath() %>/style/img/logo.png" alt="La Catalana">
    </div>

    <h1 class="site-title">La Catalana</h1>

    <nav class="site-nav">
        <a href="<%= request.getContextPath() %>/index.jsp">Inicio</a>
        <a href="<%= request.getContextPath() %>/ventanas/catalogo.jsp">Catálogo</a>
        <a href="<%= request.getContextPath() %>/ventanas/carrito.jsp">Carrito</a>

        <% if (session.getAttribute("usuario_id") == null) { %>
            <a href="#" onclick="abrirModal()">Cuenta</a>
        <% } else { %>
            <span>Hola, <%= session.getAttribute("nombre") %></span>
            <a href="<%= request.getContextPath() %>/ventanas/logout.jsp">Salir</a>
        <% } %>
    </nav>

</header>
