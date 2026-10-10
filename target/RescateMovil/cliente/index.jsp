<%-- 
    Document   : index.jsp
    Created on : 23/09/2026, 8:50:02 p. m.
    Author     : aleja
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Panel Cliente - Rescate Móvil</title>

</head>

<body>

    <h1>Panel de Cliente</h1>

    <p>
        Bienvenido a Rescate Móvil.
    </p>

    <p>
        Cliente:
        <strong>${sessionScope.nombre}</strong>
    </p>

    <p>
        Rol:
        <strong>${sessionScope.rol}</strong>
    </p>

    <hr>

    <h2>Opciones del cliente</h2>

    <ul>

        <li>Consultar reparaciones</li>
        <li>Consultar estado de reparación</li>
        <li>Consultar equipos</li>
        <li>Consultar historial</li>
        <li>Consultar notificaciones</li>
        <li>Consultar ventas</li>

    </ul>

    <hr>

    <p>
        <a href="${pageContext.request.contextPath}/login.jsp">
            Cerrar sesión
        </a>
    </p>

</body>

</html>