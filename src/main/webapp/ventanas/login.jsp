<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String ip = request.getRemoteAddr();

    if(email != null && password != null){

        Connection con = null;

        try{
            // DRIVER
            Class.forName("com.mysql.cj.jdbc.Driver");

            // CONEXIÓN
            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/chocolateria_db?useSSL=false&serverTimezone=UTC",
                "root",
                ""
            );

            // LLAMAR SP
            CallableStatement cs = con.prepareCall("{CALL sp_login_usuario(?,?,?)}");
            cs.setString(1, email);
            cs.setString(2, password);
            cs.setString(3, ip);

            ResultSet rs = cs.executeQuery();

            if(rs.next() && "success".equals(rs.getString("status"))){

                session.setAttribute("usuario_id", rs.getInt("usuario_id"));
                session.setAttribute("nombre", rs.getString("nombre"));
                session.setAttribute("email", rs.getString("email"));

                response.sendRedirect("../index.jsp");
            }else{
                response.sendRedirect("../index.jsp?error=1");
            }

        }catch(Exception e){
            e.printStackTrace();
            response.sendRedirect("../index.jsp?error=2");
        }finally{
            if(con != null){
                try{ con.close(); }catch(Exception e){}
            }
        }

    }else{
        response.sendRedirect("../index.jsp");
    }
%>
