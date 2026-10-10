<%-- 
    Document   : index.jsp
    Created on : 23/09/2026, 8:49:11 p. m.
    Author     : aleja
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Panel Técnico - Rescate Móvil</title>

</head>

<body>

    <h1>Panel de Técnico</h1>

    <p>
        Bienvenido a Rescate Móvil.
    </p>

    <p>
        Técnico:
        <strong>${sessionScope.nombre}</strong>
    </p>

    <p>
        Rol:
        <strong>${sessionScope.rol}</strong>
    </p>

    <hr>

    <h2>Módulos del técnico</h2>

    <ul>

        <li>Reparaciones asignadas</li>
        <li>Detalles de equipos</li>
        <li>Actualización de estados</li>
        <li>Productos utilizados</li>
        <li>Historial de reparaciones</li>
        <li>Notificaciones</li>

    </ul>

    <hr>

    <p>
        <a href="${pageContext.request.contextPath}/login.jsp">
            Cerrar sesión
        </a>
    </p>

</body>

</html>
