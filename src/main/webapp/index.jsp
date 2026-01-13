<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>La Catalana | Chocolatería</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="style/css/styles.css">
</head>

<style>
/* Estilos para el Anuncio CECyTEM */
.anuncio-cecytem {
    background-color: #f4f4f4;
    padding: 40px 20px;
    border-top: 4px solid #007a33; /* Verde institucional */
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

.cecytem-img img {
    width: 120px;
    height: auto;
    border-radius: 10px;
}

.cecytem-info .tag {
    background: #007a33;
    color: white;
    padding: 3px 10px;
    border-radius: 5px;
    font-size: 0.8rem;
    text-transform: uppercase;
    font-weight: bold;
}

.cecytem-info h3 {
    margin: 10px 0 5px 0;
    color: #333;
}

.cecytem-info p {
    color: #666;
    margin-bottom: 15px;
}

.btn-cecytem {
    display: inline-block;
    padding: 10px 20px;
    background-color: #007a33;
    color: white;
    text-decoration: none;
    border-radius: 25px;
    font-weight: bold;
    transition: 0.3s;
}

.btn-cecytem:hover {
    background-color: #005a26;
    transform: scale(1.05);
}

/* Responsivo para celulares */
@media (max-width: 600px) {
    .cecytem-container {
        flex-direction: column;
        text-align: center;
    }
}

/* Estilo para mensajes de error */
.error-msg {
    color: #721c24;
    background-color: #f8d7da;
    border: 1px solid #f5c6cb;
    padding: 10px;
    border-radius: 5px;
    margin-top: 10px;
    font-size: 0.9rem;
}
</style>
<body>

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
            <span class="user-name">Hola, <%= session.getAttribute("nombre") %></span>
            <a href="ventanas/logout.jsp" class="btn-logout">Salir</a>
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
    <h2 class="title">Categorías</h2>
    <div class="categorias">
        <div class="categoria-card"><h3>Trufas</h3></div>
        <div class="categoria-card"><h3>Tabletas</h3></div>
        <div class="categoria-card"><h3>Bombones</h3></div>
        <div class="categoria-card"><h3>Bebidas</h3></div>
    </div>
</section>

<section class="container">
    <h2 class="title">Productos destacados</h2>
    <div class="productos">

<%
    Connection conIndex = null;
    PreparedStatement psIndex = null;
    ResultSet rsIndex = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // Obtener la URL de Railway si existe
        String dbUrl = System.getenv("MYSQL_URL"); 

        if (dbUrl != null) {
            // Conexión automática en Railway
            conIndex = DriverManager.getConnection(dbUrl);
        } else {
            // Conexión manual para tu PC Local -> Railway
            String urlPublica = "jdbc:mysql://shinkansen.proxy.rlwy.net:10984/railway?useSSL=false&serverTimezone=UTC";
            conIndex = DriverManager.getConnection(urlPublica, "root", "fxOJJTEZWGLXDUPFXYQCoSAsJTiUHuT");
        }

        String sqlIndex = "SELECT producto_id, nombre, precio FROM productos LIMIT 3";
        psIndex = conIndex.prepareStatement(sqlIndex);
        rsIndex = psIndex.executeQuery();

        while(rsIndex.next()){
%>
        <div class="producto-card">
            <h4><%= rsIndex.getString("nombre") %></h4>
            <p class="precio">$<%= rsIndex.getBigDecimal("precio") %></p>
            <a class="btn" href="ventanas/catalogo.jsp">Ver más</a>
        </div>
<%
        }
    } catch(Exception e) {
        // En caso de error, muestra productos estáticos para que no CRASHEE la página
%>
        <div class="producto-card"><h4>Trufa de Caramelo</h4><p class="precio">$2.50</p></div>
        <div class="producto-card"><h4>Tableta Almendra</h4><p class="precio">$5.00</p></div>
<%
    } finally {
        if(rsIndex != null) rsIndex.close();
        if(psIndex != null) psIndex.close();
        if(conIndex != null) conIndex.close();
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
    © 2026 La Catalana Chocolatería | <small>S.A.R.R</small>
</footer>

<div id="loginModal" class="modal" <% if ("1".equals(request.getParameter("error"))) { %> style="display:flex;" <% } %>>
    <div class="modal-content">
        <span class="close" onclick="cerrarModal()">&times;</span>
        <h2>Iniciar sesión</h2>

        <form action="ventanas/login.jsp" method="post">
            <input type="email" name="email" placeholder="Correo" required>
            <input type="password" name="password" placeholder="Contraseña" required>
            <button class="btn" type="submit">Ingresar</button>
        </form>

        <% if ("1".equals(request.getParameter("error"))) { %>
            <div class="error-msg">Credenciales incorrectas. Intenta de nuevo.</div>
        <% } %>

        <p class="modal-text">
            ¿No tienes cuenta?
            <a href="#" onclick="abrirRegistro()">Regístrate</a>
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
/* MODALES */
function abrirModal(){
    document.getElementById("loginModal").style.display="flex";
}
function cerrarModal(){
    document.getElementById("loginModal").style.display="none";
}
function abrirRegistro(){
    cerrarModal(); // Cierra el de login si está abierto
    document.getElementById("registroModal").style.display="flex";
}
function cerrarRegistro(){
    document.getElementById("registroModal").style.display="none";
}

/* Cerrar modales al hacer clic fuera de ellos */
window.onclick = function(event) {
    if (event.target == document.getElementById("loginModal")) cerrarModal();
    if (event.target == document.getElementById("registroModal")) cerrarRegistro();
}

/* SLIDER */
let slides = document.querySelectorAll(".slide");
let current = 0;

if(slides.length > 0) {
    setInterval(() => {
        slides[current].classList.remove("active");
        current = (current + 1) % slides.length;
        slides[current].classList.add("active");
    }, 5000);
}
</script>

</body>
</html>































<!-- create by S.A.R.R -->



