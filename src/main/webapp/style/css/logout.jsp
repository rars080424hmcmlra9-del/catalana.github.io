<%@ page import="java.sql.PreparedStatement" %>
<jsp:include page="conexion.jsp"/>

<%
    Integer usuarioId = (Integer) session.getAttribute("usuario_id");
    String ip = request.getRemoteAddr();

    if(usuarioId != null){
        PreparedStatement ps = con.prepareStatement(
            "INSERT INTO log_usuarios(usuario_id, accion, ip_address) VALUES (?,?,?)"
        );
        ps.setInt(1, usuarioId);
        ps.setString(2, "Cierre de sesión");
        ps.setString(3, ip);
        ps.executeUpdate();
    }

    session.invalidate();
    response.sendRedirect("index.jsp");
%><%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    Integer usuarioId = (Integer) session.getAttribute("usuario_id");
    String ip = request.getRemoteAddr();

    Connection con = null;

    try{
        if(usuarioId != null){

            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/chocolateria_db?useSSL=false&serverTimezone=UTC",
                "root",
                ""
            );

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO log_usuarios(usuario_id, accion, ip_address) VALUES (?,?,?)"
            );
            ps.setInt(1, usuarioId);
            ps.setString(2, "Cierre de sesión");
            ps.setString(3, ip);
            ps.executeUpdate();
        }

    }catch(Exception e){
        e.printStackTrace();
    }finally{
        if(con != null){
            try{ con.close(); }catch(Exception e){}
        }
    }

    session.invalidate();
    response.sendRedirect("../index.jsp");
%>

