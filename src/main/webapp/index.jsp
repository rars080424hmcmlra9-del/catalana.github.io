<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.Conexion" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>La Catalana | Chocolatería</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="style/css/styles.css">
    <style>
        /* Estilos para el Anuncio CECyTEM */
        .anuncio-cecytem {
            background-color: #f4f4f4;
            padding: 40px 20px;
            border-top: 4px solid #007a33; 
            display: flex;
            justify-content: center;
        }
        .cecytem-container {
            max-width: 1000px;
            display: flex;
            align-items: center;
            gap: 30px;
            background: white;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .cecytem-img img { width: 120px; height: auto; border-radius: 10px; }
        .cecytem-info .tag {
            background: #007a33; color: white; padding: 3px 10px;
            border-radius: 5px; font-size: 0.8rem; text-transform: uppercase; font-weight: bold;
        }
        .cecytem-info h3 { margin: 10px 0 5px 0; color: #333; }
        .cecytem-info p { color: #666; margin-bottom: 15px; }
        .btn-cecytem {
            display: inline-block; padding: 10px 20px; background-color: #007a33;
            color: white; text-decoration: none; border-radius: 25px; font-weight: bold; transition: 0.3s;
        }
        .btn-cecytem:hover { background-color: #005a26; transform: scale(1.05); }
        
        /* Mensajes de Alerta */
        .alert { padding: 15px; margin: 10px auto; max-width: 800px; border-radius: 5px; text-align: center; font-weight: bold; }
        .alert-success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }

        @media (max-width: 600px) { .cecytem-container { flex-direction: column; text-align: center; } }
    </style>
</head>
<body>

<%
    String error = request.getParameter("error");
    String reg = request.getParameter("reg");
    String login = request.getParameter("login");
    
    if("success".equals(reg)) { %>
        <div class="alert alert-success">¡Cuenta creada con éxito! Ya puedes iniciar sesión.</div>
<%  } 
    if("login_incorrecto".equals(error)) { %>
        <div class="alert alert-error">Correo o contraseña incorrectos. Inténtalo de nuevo.</div>
<%  }
    if("db".equals(error)) { %>
        <div class="alert alert-error">Error de conexión con la base de datos de Railway.</div>
<%  } %>

<header class="site-header">
    <div class="logo">
        <img src="style/img/logo.png" alt="La Catalana">
    </div>
    <h1 class="site-title">La Catalana</h1>
    <nav class="site-nav">
        <a href="index.jsp">Inicio</a>
        <a href="ventanas/catalogo.jsp">Catálogo</a>
        <a href="ventanas/carrito.jsp">Carrito</a>
        <a href="admin/login_admin.jsp">Admin</a>

        <% if (session.getAttribute("usuario_id") == null) { %>
            <a href="#" onclick="abrirModal()">Cuenta</a>
        <% } else { %>
            <span style="color: #5d4037; font-weight: bold;">Hola, <%= session.getAttribute("nombre") %></span>
            <a href="ventanas/logout.jsp">Salir</a>
        <% } %>
    </nav>
</header>

<section class="hero-slider">
    <div class="slide active" style="background-image:url('style/img/hero1.webp')"></div>
    <div class="slide" style="background-image:url('style/img/ER_9062.webp')"></div>
    <div class="hero-content">
        <h2>Chocolate artesanal</h2>
        <p>Tradición, cacao puro y pasión por el chocolate</p>
        <a href="ventanas/catalogo.jsp" class="hero-btn">COMPRAR</a>
    </div>
</section>

<section class="container">
    <h2 class="title">Productos destacados</h2>
    <div class="productos">
        <%
            Connection con = null;
            try {
                con = Conexion.getConexion();
                if(con != null) {
                    // Consultamos los productos de la tabla que moviste a railway
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
                } else { %>
                    <p>No se pudo cargar los productos (Error de Conexión).</p>
                <% }
            } catch(Exception e) {
                out.print("<p>Error al cargar productos: " + e.getMessage() + "</p>");
            } finally {
                if(con != null) con.close();
            }
        %>

        <%
    } catch(Exception e) {
        // ESTA LÍNEA TE DIRÁ EL ERROR REAL EN LA PÁGINA
        out.print("<p style='color:red;'>Error real: " + e.getMessage() + "</p>");
        e.printStackTrace();
    }
%>
    </div>
</section>

<section class="anuncio-cecytem">
    <div class="cecytem-container">
        <div class="cecytem-img">
            <img src="style/img/mascota_cecytem.png" alt="Mascota CECyTEM">
        </div>
        <div class="cecytem-info">
            <span class="tag">Orgullosamente</span>
            <h3>Comunidad CECyTEM</h3>
            <p>Formando técnicos de excelencia para el futuro de Michoacán.</p>
            <a href="https://cecytem.edu.mx/" target="_blank" class="btn-cecytem">Ver Oferta Educativa</a>
        </div>
    </div>
</section>

<footer>
    © 2026 La Catalana Chocolatería | <small>Desarrollado por S.A.R.R</small>
</footer>

<div id="loginModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="cerrarModal()">&times;</span>
        <h2>Iniciar sesión</h2>
        <form action="ventanas/login.jsp" method="post">
            <input type="email" name="email" placeholder="Correo" required>
            <input type="password" name="password" placeholder="Contraseña" required>
            <button class="btn" type="submit">Ingresar</button>
        </form>
        <p class="modal-text">
            ¿No tienes cuenta? <a href="#" onclick="abrirRegistro()">Regístrate</a>
        </p>
    </div>
</div>

<div id="registroModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="cerrarRegistro()">&times;</span>
        <h2>Crear cuenta</h2>
        <form action="ventanas/registro.jsp" method="post">
            <input type="text" name="nombre" placeholder="Nombre completo" required>
            <input type="email" name="email" placeholder="Correo electrónico" required>
            <input type="password" name="password" placeholder="Contraseña" required>
            <input type="text" name="telefono" placeholder="Teléfono">
            <input type="text" name="direccion" placeholder="Dirección">
            <button class="btn" type="submit">Registrarse</button>
        </form>
    </div>
</div>

<script>
function abrirModal(){ document.getElementById("loginModal").style.display="flex"; }
function cerrarModal(){ document.getElementById("loginModal").style.display="none"; }
function abrirRegistro(){ 
    cerrarModal();
    document.getElementById("registroModal").style.display="flex"; 
}
function cerrarRegistro(){ document.getElementById("registroModal").style.display="none"; }

let slides = document.querySelectorAll(".slide");
let current = 0;
setInterval(() => {
    slides[current].classList.remove("active");
    current = (current + 1) % slides.length;
    slides[current].classList.add("active");
}, 5000);
</script>
</body>
</html>

