P Status 500 - Unable to compile class for JSP:
type Exception report

message Unable to compile class for JSP:

description The server encountered an internal error that prevented it from fulfilling this request.

exception

org.apache.jasper.JasperException: Unable to compile class for JSP: 

An error occurred at line: 18 in the jsp file: /ventanas/login.jsp
System cannot be resolved
15:             Class.forName("com.mysql.cj.jdbc.Driver");
16: 
17:             // --- INICIO DE CONEXIÓN HÍBRIDA RAILWAY ---
18:             String dbUrl = System.getenv("MYSQL_URL"); 
19: 
20:             if (dbUrl != null) {
21:                 // Conexión automática dentro de Railway (Producción)


Stacktrace:
	org.apache.jasper.compiler.DefaultErrorHandler.javacError(DefaultErrorHandler.java:103)
	org.apache.jasper.compiler.ErrorDispatcher.javacError(ErrorDispatcher.java:366)
	org.apache.jasper.compiler.JDTCompiler.generateClass(JDTCompiler.java:468)
	org.apache.jasper.compiler.Compiler.compile(Compiler.java:378)
	org.apache.jasper.compiler.Compiler.compile(Compiler.java:353)
	org.apache.jasper.compiler.Compiler.compile(Compiler.java:340)
	org.apache.jasper.JspCompilationContext.compile(JspCompilationContext.java:646)
	org.apache.jasper.servlet.JspServletWrapper.service(JspServletWrapper.java:357)
	org.apache.jasper.servlet.JspServlet.serviceJspFile(JspServlet.java:390)
	org.apache.jasper.servlet.JspServlet.service(JspServlet.java:334)
	javax.servlet.http.HttpServlet.service(HttpServlet.java:728)
	org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:51)
note The full stack trace of the root cause is available in the Apache Tomcat/7.0.47 logs.

