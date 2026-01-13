<%@ page import="com.itextpdf.text.*" %>
<%@ page import="com.itextpdf.text.pdf.*" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="application/pdf" %>

<%
int ventaId = Integer.parseInt(request.getParameter("venta"));

Document doc = new Document();
PdfWriter.getInstance(doc, response.getOutputStream());
doc.open();

Font f = new Font(Font.FontFamily.HELVETICA,12);

doc.add(new Paragraph("La Catalana 🍫", f));
doc.add(new Paragraph("Venta #: " + ventaId));
doc.add(new Paragraph(" "));

Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/chocolateria_db","root","");

PreparedStatement ps = con.prepareStatement(
"SELECT metodo_pago,total FROM ventas WHERE venta_id=?");
ps.setInt(1, ventaId);
ResultSet rs = ps.executeQuery();

String metodo=""; 
if(rs.next()){
    metodo = rs.getString("metodo_pago");
    doc.add(new Paragraph("Método: " + metodo));
    doc.add(new Paragraph("TOTAL: $" + rs.getBigDecimal("total")));
}

doc.close();
con.close();
%>
