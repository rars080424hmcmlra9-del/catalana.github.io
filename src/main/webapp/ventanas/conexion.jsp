<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>

<%
    Connection con = null;

    try{
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/chocolateria_db?useSSL=false&serverTimezone=UTC",
            "root",
            ""
        );
    }catch(Exception e){
        e.printStackTrace();
    }
%>