<%@ page contentType="text/html; charset=UTF-8" %>
<%
if(session.getAttribute("admin_id")==null){
    response.sendRedirect("login_admin.jsp");
    return;
}
%>

<!DOCTYPE html>
<html lang="es">
<head>
<title>Dashboard | Admin</title>

<link rel="stylesheet" href="../style/css/styles.css">
<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<style>
body{
    background:#0f0f0f;
    color:#fff;
}
.admin-header{
    margin-bottom:30px;
}
.admin-header h2{
    margin:0;
    font-size:28px;
}
.admin-header p{
    color:#aaa;
}

.grid-admin{
    display:grid;
    grid-template-columns:repeat(auto-fit,minmax(220px,1fr));
    gap:20px;
}

.admin-card{
    background:#1b1918;
    padding:25px;
    border-radius:12px;
    text-align:center;
    text-decoration:none;
    color:white;
    transition:.25s;
    box-shadow:0 0 0 rgba(0,0,0,.3);
}

.admin-card i{
    font-size:32px;
    margin-bottom:10px;
    color:#c49a6c;
}

.admin-card span{
    display:block;
    margin-top:8px;
    font-size:16px;
}

.admin-card:hover{
    transform:translateY(-6px);
    box-shadow:0 12px 30px rgba(0,0,0,.6);
}

.logout{
    background:#8b1e1e;
}

.logout i{
    color:#ffb3b3;
}
</style>
</head>

<body>

<section class="container">

    <div class="admin-header">
        <h2>Panel de Administración</h2>
        <p>Bienvenido, <b><%= session.getAttribute("admin_user") %></b></p>
    </div>

    <div class="grid-admin">

        <a class="admin-card" href="productos.jsp">
            <i class="fas fa-box"></i>
            <span>Productos</span>
        </a>

        <a class="admin-card" href="inventario.jsp">
            <i class="fas fa-warehouse"></i>
            <span>Inventario</span>
        </a>

        <a class="admin-card" href="ventas.jsp">
            <i class="fas fa-cash-register"></i>
            <span>Ventas</span>
        </a>

        <a class="admin-card" href="usuarios.jsp">
            <i class="fas fa-users"></i>
            <span>Usuarios</span>
        </a>

        <a class="admin-card" href="log_usuarios.jsp">
            <i class="fas fa-clipboard-list"></i>
            <span>Log de Usuarios</span>
        </a>

        <a class="admin-card logout" href="logout.jsp">
            <i class="fas fa-right-from-bracket"></i>
            <span>Salir</span>
        </a>

    </div>

</section>

</body>
</html>
