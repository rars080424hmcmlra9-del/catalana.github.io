<%@ page import="com.itextpdf.text.*" %>
<%@ page import="com.itextpdf.text.pdf.*" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="application/pdf" %>

<%
    // Obtener ID de venta
    String ventaParam = request.getParameter("venta");
    if(ventaParam == null) return;
    int ventaId = Integer.parseInt(ventaParam);

    // Configurar el documento PDF
    Document doc = new Document();
    
    try {
        PdfWriter.getInstance(doc, response.getOutputStream());
        doc.open();

        Font tituloFont = new Font(Font.FontFamily.HELVETICA, 16, Font.BOLD);
        Font normalFont = new Font(Font.FontFamily.HELVETICA, 12, Font.NORMAL);

        doc.add(new Paragraph("La Catalana 🍫", tituloFont));
        doc.add(new Paragraph("Ticket de Compra Digital", normalFont));
        doc.add(new Paragraph("Venta #: " + ventaId, normalFont));
        doc.add(new Paragraph(" ")); // Espacio

        // --- INICIO DE CONEXIÓN HÍBRIDA RAILWAY ---
        Connection con = null;
        Class.forName("com.mysql.cj.jdbc.Driver");
        String dbUrl = System.getenv("MYSQL_URL"); 

        if (dbUrl != null) {
            // Conexión automática dentro de Railway (Producción)
            con = DriverManager.getConnection(dbUrl);
        } else {
            // Conexión manual desde tu PC -> Railway (Desarrollo)
            String host = "shinkansen.proxy.rlwy.net";
            String port = "10984";
            String dbName = "railway"; 
            String user = "root";
            String pass = "fxOJJTEZWGLXDUPFXYQCoSAsJTiUHuT";

            String urlPublica = "jdbc:mysql://" + host + ":" + port + "/" + dbName + "?useSSL=false&serverTimezone=UTC";
            con = DriverManager.getConnection(urlPublica, user, pass);
        }
        // --- FIN DE CONEXIÓN HÍBRIDA ---

        // Consultar datos de la venta
        PreparedStatement ps = con.prepareStatement(
            "SELECT metodo_pago, total, fecha FROM ventas WHERE venta_id=?"
        );
        ps.setInt(1, ventaId);
        ResultSet rs = ps.executeQuery();

        if(rs.next()){
            doc.add(new Paragraph("Fecha: " + rs.getTimestamp("fecha"), normalFont));
            doc.add(new Paragraph("Método de pago: " + rs.getString("metodo_pago"), normalFont));
            doc.add(new Paragraph(" "));
            doc.add(new Paragraph("TOTAL A PAGAR: $" + rs.getBigDecimal("total"), tituloFont));
        }

        doc.add(new Paragraph("\n\nGracias por su preferencia.", normalFont));

        // Cerrar recursos de BD
        rs.close();
        ps.close();
        con.close();

    } catch (Exception e) {
        // Si hay error, intentamos escribirlo en el PDF
        try {
            doc.add(new Paragraph("Error al generar el PDF: " + e.getMessage()));
        } catch (DocumentException de) {
            e.printStackTrace();
        }
    } finally {
        if(doc.isOpen()) {
            doc.close();
        }
    }
%>
