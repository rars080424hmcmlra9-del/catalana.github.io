<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.Conexion" %> 
<%
    // Forzamos la codificación para que nombres con tildes no se rompan
    request.setCharacterEncoding("UTF-8");
    
    String nombre = request.getParameter("nombre");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String telefono = request.getParameter("telefono");
    String direccion = request.getParameter("direccion");
    String ip = request.getRemoteAddr();

    // Validación básica de campos obligatorios
    if(nombre != null && !nombre.trim().isEmpty() && email != null && password != null){
        Connection con = null;
        try {
            con = Conexion.getConexion(); // Conexión al esquema 'railway'

            // 1. INSERTAR EL USUARIO
            String sql = "INSERT INTO usuarios(nombre, email, password, telefono, direccion) VALUES (?,?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, nombre);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, telefono);
            ps.setString(5, direccion);
            ps.executeUpdate();

            // 2. RECUPERAR EL ID GENERADO
            ResultSet rs = ps.getGeneratedKeys();
            int usuarioId = 0;
            if(rs.next()){ 
                usuarioId = rs.getInt(1); 
            }
            
            // 3. REGISTRAR EN EL LOG (Solo si el usuario se creó)
            if(usuarioId > 0) {
                String sqlLog = "INSERT INTO log_usuarios(usuario_id, accion, ip_address) VALUES (?,?,?)";
                PreparedStatement psLog = con.prepareStatement(sqlLog);
                psLog.setInt(1, usuarioId);
                psLog.setString(2, "Registro de usuario nuevo");
                psLog.setString(3, ip);
                psLog.executeUpdate();
            }

            // ÉXITO: Redirigir al inicio
            response.sendRedirect("../index.jsp?reg=success");

        } catch(Exception e) {
            // Este error aparecerá en la pestaña 'Logs' de Railway
            System.err.println("Error en proceso de registro: " + e.getMessage());
            response.sendRedirect("../index.jsp?error=db_error");
        } finally {
            // Cerramos la conexión para no saturar el pool de Railway
            if(con != null) {
                try { 
                    con.close(); 
                } catch(Exception e) { 
                    e.printStackTrace(); 
                }
            }
        }
    } else {
        // ERROR: Faltan datos en el formulario
        response.sendRedirect("../index.jsp?error=missing_fields");
    }
%>
