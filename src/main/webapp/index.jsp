<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>La Catalana | Chocolatería</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="style/css/styles.css">
</head>
<body>

<!-- ================= HEADER ================= -->
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
            <span>Hola, <%= session.getAttribute("nombre") %></span>
            <a href="ventanas/logout.jsp">Salir</a>
        <% } %>
    </nav>

</header>

<!-- ================= HERO SLIDER ================= -->
<section class="hero-slider">

    <div class="slide active" style="background-image:url('style/img/hero1.webp')"></div>
    <div class="slide" style="background-image:url('style/img/ER_9062.webp')"></div>
    115

    <div class="hero-content">
        <h2>Chocolate artesanal</h2>
        <p>Tradición, cacao puro y pasión por el chocolate</p>
        <a href="ventanas/catalogo.jsp" class="hero-btn">COMPRAR</a>
    </div>

</section>

<!-- ================= CATEGORÍAS ================= -->
<section class="container">
    <h2 class="title">Categorías</h2>

    <div class="categorias">
        <div class="categoria-card"><h3>Trufas</h3></div>
        <div class="categoria-card"><h3>Tabletas</h3></div>
        <div class="categoria-card"><h3>Bombones</h3></div>
        <div class="categoria-card"><h3>Bebidas</h3></div>
    </div>
</section>

<!-- ================= PRODUCTOS ================= -->
<section class="container">
    <h2 class="title">Productos destacados</h2>

    <div class="productos">

        <div class="producto-card">
            <h4>Trufa de Caramelo Salado</h4>
            <p class="precio">$2.50</p>
            <a class="btn" href="ventanas/agregar_carrito.jsp">Agregar</a>
        </div>

        <div class="producto-card">
            <h4>Tableta con Almendras</h4>
            <p class="precio">$5.00</p>
            <a class="btn" href="ventanas/agregar_carrito.jsp">Agregar</a>
        </div>

        <div class="producto-card">
            <h4>Bombón de Maracuyá</h4>
            <p class="precio">$1.80</p>
            <a class="btn" href="ventanas/agregar_carrito.jsp">Agregar</a>
        </div>

    </div>
</section>

<!-- ================= FOOTER ================= -->
<footer>
    © 2026 La Catalana Chocolatería
</footer>

<!-- ================= MODAL LOGIN ================= -->
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
            ¿No tienes cuenta?
            <a href="#" onclick="abrirRegistro()">Regístrate</a>
        </p>

        <% if ("1".equals(request.getParameter("error"))) { %>
            <p class="error">Credenciales incorrectas</p>
        <% } %>
    </div>
</div>

<!-- ================= MODAL REGISTRO ================= -->
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

<!-- ================= SCRIPTS ================= -->
<script>
/* MODALES */
function abrirModal(){
    document.getElementById("loginModal").style.display="flex";
}
function cerrarModal(){
    document.getElementById("loginModal").style.display="none";
}
function abrirRegistro(){
    document.getElementById("registroModal").style.display="flex";
}
function cerrarRegistro(){
    document.getElementById("registroModal").style.display="none";
}

/* SLIDER */
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































<!-- create by S.A.R.R -->
