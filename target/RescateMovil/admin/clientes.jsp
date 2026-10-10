<%--
    Document   : clientes
    Created on : 30/09/2026
    Author     : Luis Alejandro Murillo Diaz
    Proyecto   : Rescate Móvil
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.rescatemovil.modelo.cliente" %>

<%
    /*
     * ==========================================
     * VALIDACIÓN DE SESIÓN
     * ==========================================
     */

    String usuarioSesion =
            (String) session.getAttribute("usuario");

    String rolSesion =
            (String) session.getAttribute("rol");

    if (usuarioSesion == null || rolSesion == null) {

        response.sendRedirect(
                request.getContextPath()
                + "/login.jsp"
        );

        return;
    }


    /*
     * ==========================================
     * VALIDACIÓN DEL ROL
     * ==========================================
     */

    if (!"admin".equalsIgnoreCase(rolSesion)) {

        response.sendRedirect(
                request.getContextPath()
                + "/login.jsp?error=acceso"
        );

        return;
    }


    /*
     * ==========================================
     * OBTENER CLIENTES
     * ==========================================
     */

    List<cliente> clientes =
            (List<cliente>) request.getAttribute("clientes");


    if (clientes == null) {

        clientes =
                new java.util.ArrayList<cliente>();
    }


    /*
     * ==========================================
     * ESTADÍSTICAS
     * ==========================================
     */

    int totalClientes =
            clientes.size();

%>


<!DOCTYPE html>

<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Gestión de Clientes | Rescate Móvil</title>


    <style>

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }


        body {

            font-family:
                Arial,
                Helvetica,
                sans-serif;

            background: #07111f;

            color: #ffffff;

            min-height: 100vh;
        }


        /* ==========================================
           CONTENEDOR PRINCIPAL
        ========================================== */

        .app {

            display: flex;

            min-height: 100vh;
        }


        /* ==========================================
           SIDEBAR
        ========================================== */

        .sidebar {

            width: 250px;

            background: #0a1727;

            border-right: 1px solid #1c354d;

            padding: 25px 15px;

            position: fixed;

            top: 0;

            bottom: 0;

            left: 0;

            overflow-y: auto;
        }


        .logo-area {

            text-align: center;

            padding-bottom: 25px;

            border-bottom:
                1px solid #1c354d;

            margin-bottom: 25px;
        }


        .logo {

            width: 70px;

            height: 70px;

            object-fit: cover;

            border-radius: 18px;

            margin-bottom: 12px;

            box-shadow:
                0 10px 30px
                rgba(0, 0, 0, 0.35);
        }


        .logo-area h2 {

            font-size: 18px;

            margin-bottom: 5px;
        }


        .logo-area p {

            color: #71869b;

            font-size: 12px;
        }


        /* ==========================================
           MENÚ
        ========================================== */

        .menu-title {

            color: #52677d;

            font-size: 11px;

            font-weight: bold;

            letter-spacing: 1px;

            margin:
                0 12px
                12px;
        }


        .menu {

            display: flex;

            flex-direction: column;

            gap: 6px;
        }


        .menu a {

            display: flex;

            align-items: center;

            gap: 12px;

            padding: 12px 14px;

            border-radius: 10px;

            color: #91a4b9;

            text-decoration: none;

            font-size: 14px;

            transition: 0.3s;
        }


        .menu a:hover {

            background:
                rgba(0, 212, 255, 0.08);

            color: #00d4ff;
        }


        .menu a.activo {

            background:
                rgba(0, 212, 255, 0.12);

            color: #00d4ff;

            border:
                1px solid
                rgba(0, 212, 255, 0.18);
        }


        .menu-icon {

            width: 28px;

            text-align: center;

            font-size: 17px;
        }


        /* ==========================================
           CONTENIDO
        ========================================== */

        .main {

            margin-left: 250px;

            width: calc(100% - 250px);

            padding: 30px;
        }


        /* ==========================================
           TOPBAR
        ========================================== */

        .topbar {

            display: flex;

            justify-content: space-between;

            align-items: center;

            margin-bottom: 30px;
        }


        .topbar h1 {

            font-size: 30px;

            margin-bottom: 7px;
        }


        .topbar p {

            color: #71869b;

            font-size: 14px;
        }


        .usuario-info {

            display: flex;

            align-items: center;

            gap: 12px;

            padding:
                10px 14px;

            background: #0a1727;

            border:
                1px solid #1c354d;

            border-radius: 12px;
        }


        .usuario-avatar {

            width: 38px;

            height: 38px;

            display: flex;

            align-items: center;

            justify-content: center;

            border-radius: 50%;

            background: #00d4ff;

            color: #07111f;

            font-weight: bold;
        }


        .usuario-texto strong {

            display: block;

            font-size: 13px;
        }


        .usuario-texto span {

            display: block;

            color: #00d4ff;

            font-size: 11px;

            margin-top: 3px;
        }


        /* ==========================================
           ESTADÍSTICAS
        ========================================== */

        .estadisticas {

            display: grid;

            grid-template-columns:
                repeat(3, 1fr);

            gap: 18px;

            margin-bottom: 25px;
        }


        .card {

            background: #0a1727;

            border:
                1px solid #1c354d;

            border-radius: 16px;

            padding: 22px;

            position: relative;

            overflow: hidden;
        }


        .card::after {

            content: "";

            position: absolute;

            width: 100px;

            height: 100px;

            border-radius: 50%;

            background: #00d4ff;

            opacity: 0.035;

            right: -35px;

            bottom: -35px;
        }


        .card-icon {

            width: 42px;

            height: 42px;

            display: flex;

            align-items: center;

            justify-content: center;

            background:
                rgba(0, 212, 255, 0.10);

            color: #00d4ff;

            border-radius: 11px;

            font-size: 19px;

            margin-bottom: 15px;
        }


        .card-label {

            color: #71869b;

            font-size: 12px;

            margin-bottom: 7px;
        }


        .card-value {

            font-size: 29px;

            font-weight: bold;
        }


        /* ==========================================
           PANEL PRINCIPAL
        ========================================== */

        .panel {

            background: #0a1727;

            border:
                1px solid #1c354d;

            border-radius: 18px;

            overflow: hidden;
        }


        .panel-header {

            padding: 22px 25px;

            display: flex;

            justify-content: space-between;

            align-items: center;

            border-bottom:
                1px solid #1c354d;

            gap: 20px;
        }


        .panel-title h2 {

            font-size: 19px;

            margin-bottom: 5px;
        }


        .panel-title p {

            color: #71869b;

            font-size: 12px;
        }


        /* ==========================================
           BUSCADOR
        ========================================== */

        .acciones {

            display: flex;

            align-items: center;

            gap: 10px;
        }


        .buscador {

            position: relative;
        }


        .buscador input {

            width: 250px;

            padding:
                11px 14px
                11px 38px
                11px 14px;

            background: #07111f;

            border:
                1px solid #294158;

            border-radius: 10px;

            color: white;

            outline: none;

            font-size: 13px;
        }


        .buscador input:focus {

            border-color: #00d4ff;

            box-shadow:
                0 0 0 3px
                rgba(0, 212, 255, 0.07);
        }


        .buscador-icon {

            position: absolute;

            left: 13px;

            top: 50%;

            transform:
                translateY(-50%);

            color: #62758a;
        }


        .btn-nuevo {

            display: inline-flex;

            align-items: center;

            gap: 7px;

            padding:
                11px 16px;

            background: #00d4ff;

            color: #07111f;

            text-decoration: none;

            border-radius: 10px;

            font-size: 13px;

            font-weight: bold;

            transition: 0.3s;
        }


        .btn-nuevo:hover {

            transform:
                translateY(-2px);

            box-shadow:
                0 10px 25px
                rgba(0, 212, 255, 0.18);
        }


        /* ==========================================
           TABLA
        ========================================== */

        .tabla-container {

            overflow-x: auto;
        }


        table {

            width: 100%;

            border-collapse: collapse;

            min-width: 900px;
        }


        thead {

            background: #081523;
        }


        th {

            text-align: left;

            padding:
                15px 18px;

            color: #71869b;

            font-size: 11px;

            text-transform: uppercase;

            letter-spacing: 0.7px;

            font-weight: bold;

            white-space: nowrap;
        }


        td {

            padding:
                16px 18px;

            border-top:
                1px solid #142a3f;

            font-size: 13px;

            color: #c8d5e2;

            vertical-align: middle;
        }


        tbody tr {

            transition: 0.2s;
        }


        tbody tr:hover {

            background:
                rgba(0, 212, 255, 0.035);
        }


        .cliente-nombre {

            display: flex;

            align-items: center;

            gap: 10px;
        }


        .cliente-avatar {

            width: 36px;

            height: 36px;

            min-width: 36px;

            display: flex;

            align-items: center;

            justify-content: center;

            border-radius: 10px;

            background:
                rgba(0, 212, 255, 0.10);

            color: #00d4ff;

            font-weight: bold;

            font-size: 12px;
        }


        .nombre-principal {

            color: #ffffff;

            font-weight: bold;

            margin-bottom: 3px;
        }


        .nombre-secundario {

            color: #62758a;

            font-size: 11px;
        }


        .badge-documento {

            color: #c8d5e2;

            font-size: 12px;
        }


        .correo {

            color: #91a4b9;
        }


        .telefono {

            color: #91a4b9;
        }


        .ciudad {

            color: #91a4b9;
        }


        /* ==========================================
           BOTONES ACCIONES
        ========================================== */

        .acciones-tabla {

            display: flex;

            gap: 7px;
        }


        .btn-accion {

            width: 34px;

            height: 34px;

            display: flex;

            align-items: center;

            justify-content: center;

            border-radius: 9px;

            text-decoration: none;

            transition: 0.2s;

            font-size: 14px;

            cursor: pointer;
        }


        .btn-editar {

            background:
                rgba(0, 212, 255, 0.08);

            color: #00d4ff;

            border:
                1px solid
                rgba(0, 212, 255, 0.15);
        }


        .btn-editar:hover {

            background:
                rgba(0, 212, 255, 0.16);

            transform: translateY(-1px);
        }


        .btn-eliminar {

            background:
                rgba(220, 53, 69, 0.08);

            color: #ff7885;

            border:
                1px solid
                rgba(220, 53, 69, 0.15);
        }


        .btn-eliminar:hover {

            background:
                rgba(220, 53, 69, 0.16);

            transform: translateY(-1px);
        }


        /* ==========================================
           ESTADO VACÍO
        ========================================== */

        .sin-clientes {

            text-align: center;

            padding: 70px 20px;
        }


        .sin-clientes-icon {

            font-size: 45px;

            margin-bottom: 15px;

            opacity: 0.7;
        }


        .sin-clientes h3 {

            font-size: 18px;

            margin-bottom: 8px;
        }


        .sin-clientes p {

            color: #71869b;

            font-size: 13px;

            margin-bottom: 20px;
        }


        /* ==========================================
           PIE
        ========================================== */

        .footer {

            padding:
                25px 5px 10px;

            text-align: center;

            color: #52677d;

            font-size: 11px;
        }


        /* ==========================================
           RESPONSIVE
        ========================================== */

        @media (max-width: 1050px) {

            .estadisticas {

                grid-template-columns:
                    repeat(2, 1fr);
            }


            .panel-header {

                align-items: flex-start;

                flex-direction: column;
            }


            .acciones {

                width: 100%;
            }


            .buscador {

                flex: 1;
            }


            .buscador input {

                width: 100%;
            }

        }


        @media (max-width: 800px) {

            .sidebar {

                width: 210px;
            }


            .main {

                margin-left: 210px;

                width:
                    calc(100% - 210px);

                padding: 20px;
            }


            .topbar {

                align-items: flex-start;

                flex-direction: column;

                gap: 15px;
            }

        }


        @media (max-width: 650px) {

            .sidebar {

                position: relative;

                width: 100%;

                height: auto;
            }


            .app {

                flex-direction: column;
            }


            .main {

                margin-left: 0;

                width: 100%;
            }


            .estadisticas {

                grid-template-columns: 1fr;
            }


            .acciones {

                flex-direction: column;

                align-items: stretch;
            }


            .btn-nuevo {

                justify-content: center;
            }

        }

    </style>

</head>


<body>


<div class="app">


    <!-- ==========================================
         SIDEBAR
    =========================================== -->

    <aside class="sidebar">


        <div class="logo-area">

            <img
                src="<%= request.getContextPath() %>/img/logo.jpg"
                alt="Rescate Móvil"
                class="logo">

            <h2>Rescate Móvil</h2>

            <p>Panel de administración</p>

        </div>


        <div class="menu-title">
            ADMINISTRACIÓN
        </div>


        <nav class="menu">


            <a href="<%= request.getContextPath() %>/admin/index.jsp">

                <span class="menu-icon">⌂</span>

                <span>Dashboard</span>

            </a>


            <a
                href="<%= request.getContextPath() %>/admin/usuarios">

                <span class="menu-icon">👤</span>

                <span>Gestión de usuarios</span>

            </a>


            <a
                href="<%= request.getContextPath() %>/admin/clientes"
                class="activo">

                <span class="menu-icon">👥</span>

                <span>Gestión de clientes</span>

            </a>


            <a href="#">

                <span class="menu-icon">🔧</span>

                <span>Gestión de técnicos</span>

            </a>


            <a href="#">

                <span class="menu-icon">📦</span>

                <span>Gestión de productos</span>

            </a>


            <a href="#">

                <span class="menu-icon">🛠️</span>

                <span>Gestión de reparaciones</span>

            </a>


            <a href="#">

                <span class="menu-icon">💰</span>

                <span>Gestión de ventas</span>

            </a>


            <a href="#">

                <span class="menu-icon">🔔</span>

                <span>Notificaciones</span>

            </a>


            <a href="#">

                <span class="menu-icon">📊</span>

                <span>Reportes</span>

            </a>


        </nav>


    </aside>


    <!-- ==========================================
         CONTENIDO
    =========================================== -->

    <main class="main">


        <!-- TOPBAR -->

        <div class="topbar">


            <div>

                <h1>Gestión de clientes</h1>

                <p>
                    Administra la información de los clientes
                    registrados en Rescate Móvil.
                </p>

            </div>


            <div class="usuario-info">


                <div class="usuario-avatar">

                    <%
                        String inicialUsuario = "";

                        if (usuarioSesion != null
                                && !usuarioSesion.trim().isEmpty()) {

                            inicialUsuario =
                                    usuarioSesion
                                    .substring(0, 1)
                                    .toUpperCase();
                        }
                    %>

                    <%= inicialUsuario %>

                </div>


                <div class="usuario-texto">

                    <strong>
                        <%= usuarioSesion %>
                    </strong>

                    <span>
                        ADMINISTRADOR
                    </span>

                </div>


            </div>


        </div>


        <!-- ==========================================
             ESTADÍSTICAS
        =========================================== -->

        <section class="estadisticas">


            <div class="card">

                <div class="card-icon">
                    👥
                </div>

                <div class="card-label">
                    TOTAL CLIENTES
                </div>

                <div class="card-value">
                    <%= totalClientes %>
                </div>

            </div>


            <div class="card">

                <div class="card-icon">
                    📋
                </div>

                <div class="card-label">
                    REGISTROS DISPONIBLES
                </div>

                <div class="card-value">
                    <%= totalClientes %>
                </div>

            </div>


            <div class="card">

                <div class="card-icon">
                    📅
                </div>

                <div class="card-label">
                    INFORMACIÓN
                </div>

                <div class="card-value">
                    CRM
                </div>

            </div>


        </section>


        <!-- ==========================================
             PANEL CLIENTES
        =========================================== -->

        <section class="panel">


            <div class="panel-header">


                <div class="panel-title">

                    <h2>
                        Clientes registrados
                    </h2>

                    <p>
                        Consulta y administra los clientes
                        de la plataforma.
                    </p>

                </div>


                <div class="acciones">


                    <div class="buscador">

                        <span class="buscador-icon">
                            🔎
                        </span>

                        <input
                            type="text"
                            id="buscarCliente"
                            placeholder="Buscar cliente..."
                            onkeyup="filtrarClientes()">

                    </div>


                    <a
                        href="<%= request.getContextPath() %>/admin/nuevo-cliente.jsp"
                        class="btn-nuevo">

                        <span>＋</span>

                        Nuevo cliente

                    </a>


                </div>


            </div>


            <!-- ======================================
                 TABLA
            ======================================= -->

            <div class="tabla-container">


                <% if (clientes.isEmpty()) { %>


                    <div class="sin-clientes">


                        <div class="sin-clientes-icon">
                            👥
                        </div>


                        <h3>
                            No hay clientes registrados
                        </h3>


                        <p>
                            Todavía no existen clientes
                            registrados en el sistema.
                        </p>


                        <a
                            href="<%= request.getContextPath() %>/admin/nuevo-cliente.jsp"
                            class="btn-nuevo">

                            ＋ Crear primer cliente

                        </a>


                    </div>


                <% } else { %>


                    <table id="tablaClientes">


                        <thead>

                            <tr>

                                <th>
                                    Cliente
                                </th>

                                <th>
                                    Documento
                                </th>

                                <th>
                                    Teléfono
                                </th>

                                <th>
                                    Correo
                                </th>

                                <th>
                                    Ciudad
                                </th>

                                <th>
                                    Registro
                                </th>

                                <th>
                                    Acciones
                                </th>

                            </tr>

                        </thead>


                        <tbody>


                        <% for (cliente clienteActual : clientes) { %>


                            <tr>


                                <td>

                                    <div class="cliente-nombre">


                                        <div class="cliente-avatar">

                                            <%
                                                String inicial = "";

                                                if (clienteActual.getNombre() != null
                                                        && !clienteActual.getNombre().trim().isEmpty()) {

                                                    inicial =
                                                            clienteActual.getNombre()
                                                            .substring(0, 1)
                                                            .toUpperCase();
                                                }
                                            %>

                                            <%= inicial %>

                                        </div>


                                        <div>

                                            <div class="nombre-principal">

                                                <%= clienteActual.getNombre() %>
                                                <%= clienteActual.getApellido() %>

                                            </div>


                                            <div class="nombre-secundario">

                                                ID:
                                                <%= clienteActual.getId() %>

                                            </div>

                                        </div>


                                    </div>

                                </td>


                                <td>

                                    <span class="badge-documento">

                                        <%
                                            if (clienteActual.getDocumento()
                                                    != null
                                                    && !clienteActual.getDocumento()
                                                    .isEmpty()) {
                                        %>

                                            <%= clienteActual.getDocumento() %>

                                        <%
                                            } else {
                                        %>

                                            No registrado

                                        <%
                                            }
                                        %>

                                    </span>

                                </td>


                                <td>

                                    <span class="telefono">

                                        <%= clienteActual.getTelefono() %>

                                    </span>

                                </td>


                                <td>

                                    <span class="correo">

                                        <%= clienteActual.getCorreo() %>

                                    </span>

                                </td>


                                <td>

                                    <span class="ciudad">

                                        <%
                                            if (clienteActual.getCiudad()
                                                    != null
                                                    && !clienteActual.getCiudad()
                                                    .isEmpty()) {
                                        %>

                                            <%= clienteActual.getCiudad() %>

                                        <%
                                            } else {
                                        %>

                                            No registrada

                                        <%
                                            }
                                        %>

                                    </span>

                                </td>


                                <td>

                                    <span class="nombre-secundario">

                                        <%= clienteActual.getFechaRegistro() %>

                                    </span>

                                </td>


                                <td>


                                    <div class="acciones-tabla">


                                        <!--
                                             IMPORTANTE:
                                             El Servlet utiliza el parámetro
                                             "accion", no "action".
                                        -->

                                        <a
                                            href="<%= request.getContextPath() %>/admin/clientes?accion=editar&id=<%= clienteActual.getId() %>"
                                            class="btn-accion btn-editar"
                                            title="Editar cliente">

                                            ✏️

                                        </a>


                                        <a
                                            href="<%= request.getContextPath() %>/admin/clientes?accion=eliminar&id=<%= clienteActual.getId() %>"
                                            class="btn-accion btn-eliminar"
                                            title="Eliminar cliente"
                                            onclick="return confirmarEliminacion();">

                                            🗑️

                                        </a>


                                    </div>


                                </td>


                            </tr>


                        <% } %>


                        </tbody>


                    </table>


                <% } %>


            </div>


        </section>


        <div class="footer">

            © 2026 Rescate Móvil

            <br>

            Plataforma de gestión de servicios técnicos móviles

        </div>


    </main>


</div>


<script>


    /*
     * ==========================================
     * BUSCADOR DE CLIENTES
     * ==========================================
     */

    function filtrarClientes() {

        let input =
                document.getElementById(
                        "buscarCliente"
                );

        let filtro =
                input.value.toLowerCase();

        let tabla =
                document.getElementById(
                        "tablaClientes"
                );

        if (!tabla) {
            return;
        }

        let filas =
                tabla.getElementsByTagName("tbody")[0]
                .getElementsByTagName("tr");


        for (let i = 0; i < filas.length; i++) {

            let texto =
                    filas[i].textContent
                    .toLowerCase();

            if (texto.indexOf(filtro) > -1) {

                filas[i].style.display = "";

            } else {

                filas[i].style.display = "none";
            }

        }

    }


    /*
     * ==========================================
     * CONFIRMAR ELIMINACIÓN
     * ==========================================
     */

    function confirmarEliminacion() {

        return confirm(
            "¿Está seguro de que desea eliminar este cliente?"
        );

    }

</script>


</body>

</html>