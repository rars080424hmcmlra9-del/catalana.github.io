<%@ page import="java.sql.*" %>
<%
String user = request.getParameter("username");
String pass = request.getParameter("password");

Connection con=null;
PreparedStatement ps=null;
ResultSet rs=null;

try{
    Class.forName("com.mysql.cj.jdbc.Driver");
    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/chocolateria_db","root",""
    );

    ps = con.prepareStatement(
        "SELECT * FROM admins WHERE username=? AND password=?"
    );
    ps.setString(1,user);
    ps.setString(2,pass);

    rs = ps.executeQuery();

    if(rs.next()){
        session.setAttribute("admin_id", rs.getInt("admin_id"));
        session.setAttribute("admin_user", rs.getString("username"));
        response.sendRedirect("dashboard.jsp");
    }else{
        response.sendRedirect("login_admin.jsp?error=1");
    }
}catch(Exception e){
    e.printStackTrace();
}
%>
