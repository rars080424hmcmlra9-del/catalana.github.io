<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>Admin | La Catalana</title>
    <link rel="stylesheet" href="../style/css/styles.css">
</head>
<body>

<section class="container" style="max-width:400px;margin-top:80px;">
    <h2>Panel Administrador</h2>

    <form action="validar_admin.jsp" method="post">
        <input type="text" name="username" placeholder="Usuario" required>
        <input type="password" name="password" placeholder="Contraseña" required>

        <button class="btn" type="submit">Ingresar</button>
    </form>

    <% if(request.getParameter("error") != null){ %>
        <p style="color:red;">Credenciales incorrectas</p>
    <% } %>
</section>

</body>
</html>
