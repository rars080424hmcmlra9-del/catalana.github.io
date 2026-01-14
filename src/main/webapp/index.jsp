<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.Conexion" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>La Catalana | Chocolatería</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="style/css/styles.css">
</head>
<body>

<%
    String error = request.getParameter("error");
    String reg = request.getParameter("reg");
    
    if("success".equals(reg)) { %>
        <div style="background:#d4edda; color:#155724; padding:15px; text-align:center;">¡Registro exitoso! Ya puedes iniciar sesión.</div>
<%  } 
    if("db".equals(error)) { %>
        <div style="background:#f8d7da; color:#721c24; padding:15px; text-align:center;">Error de conexión con Railway.</div>
<%  } %>

<header class="site-header">
    <div class="logo"><img src="style/img/logo.png" alt="Logo"></div>
    <h1 class="site-title">La Catalana</h1>
    <nav class="site-nav">
        <a href="index.jsp">Inicio</a>
        <a href="ventanas/catalogo.jsp">Catálogo</a>
        <a href="ventanas/carrito.jsp">Carrito</a>
        <% if (session.getAttribute("usuario_id") == null) { %>
            <a href="#" onclick="abrirModal()">Cuenta</a>
        <% } else { %>
            <span>Hola, <%= session.getAttribute("nombre") %></span>
            <a href="ventanas/logout.jsp">Salir</a>
        <% } %>
    </nav>
</header>

<section class="container">
    <h2 class="title">Productos destacados</h2>
    <div class="productos">
        <%
            Connection con = null;
            try {
                con = Conexion.getConexion();
                if(con != null) {
                    String sql = "SELECT nombre, precio FROM productos LIMIT 3";
                    Statement st = con.createStatement();
                    ResultSet rs = st.executeQuery(sql);
                    while(rs.next()){ %>
                        <div class="producto-card">
                            <h4><%= rs.getString("nombre") %></h4>
                            <p class="precio">$<%= rs.getDouble("precio") %></p>
                            <a class="btn" href="ventanas/agregar_carrito.jsp">Agregar</a>
                        </div>
                    <% }
                }
            } catch(Exception e) {
                // El error se imprime en el log de Railway, no rompe el HTML
                System.err.println("Error JSP: " + e.getMessage());
            } finally {
                if(con != null) { try { con.close(); } catch(Exception e) {} }
            }
        %>
    </div>
</section>

<div id="loginModal" class="modal" style="display:none;">
    <div class="modal-content">
        <span onclick="cerrarModal()">&times;</span>
        <h2>Iniciar sesión</h2>
        <form action="ventanas/login.jsp" method="post">
            <input type="email" name="email" placeholder="Correo" required>
            <input type="password" name="password" placeholder="Contraseña" required>
            <button type="submit">Ingresar</button>
        </form>
        <p>¿No tienes cuenta? <a href="#" onclick="abrirRegistro()">Regístrate</a></p>
    </div>
</div>

<div id="registroModal" class="modal" style="display:none;">
    <div class="modal-content">
        <span onclick="cerrarRegistro()">&times;</span>
        <h2>Crear cuenta</h2>
        <form action="ventanas/registro.jsp" method="post">
            <input type="text" name="nombre" placeholder="Nombre" required>
            <input type="email" name="email" placeholder="Correo" required>
            <input type="password" name="password" placeholder="Contraseña" required>
            <button type="submit">Registrarse</button>
        </form>
    </div>
</div>

<script>
function abrirModal(){ document.getElementById("loginModal").style.display="flex"; }
function cerrarModal(){ document.getElementById("loginModal").style.display="none"; }
function abrirRegistro(){ cerrarModal(); document.getElementById("registroModal").style.display="flex"; }
function cerrarRegistro(){ document.getElementById("registroModal").style.display="none"; }
</script>

</body>
</html>
