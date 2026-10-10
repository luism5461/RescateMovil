<%-- 
    Document   : usuarios
    Created on : 23/09/2026, 10:37:51 p. m.
    Author     : Luis Alejandro Murillo Diaz
--%>

<%@page import="java.util.List"%>
<%@page import="com.rescatemovil.modelo.Usuario"%>

<%
    String usuarioSesion =
            (String) session.getAttribute("usuario");

    String rolSesion =
            (String) session.getAttribute("rol");

    if (usuarioSesion == null || rolSesion == null) {
        response.sendRedirect(
                request.getContextPath() + "/login.jsp"
        );
        return;
    }

    if (!"admin".equalsIgnoreCase(rolSesion)) {
        response.sendRedirect(
                request.getContextPath()
                + "/login.jsp?error=acceso"
        );
        return;
    }

    List<Usuario> usuarios =
            (List<Usuario>) request.getAttribute("usuarios");

    String mensaje =
            request.getParameter("mensaje");

    String error =
            request.getParameter("error");

    int totalUsuarios = 0;
    int administradores = 0;
    int tecnicos = 0;
    int clientes = 0;
    int activos = 0;

    if (usuarios != null) {

        totalUsuarios = usuarios.size();

        for (Usuario u : usuarios) {

            if (u.isActivo()) {
                activos++;
            }

            if (u.getRol() != null) {

                if ("admin".equalsIgnoreCase(u.getRol())) {
                    administradores++;
                }

                if ("tecnico".equalsIgnoreCase(u.getRol())) {
                    tecnicos++;
                }

                if ("cliente".equalsIgnoreCase(u.getRol())) {
                    clientes++;
                }
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0">

    <title>Gestión de Usuarios | Rescate Móvil</title>

    <style>

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family:
                "Segoe UI",
                Arial,
                Helvetica,
                sans-serif;

            background: #f5f7fb;
            color: #1e293b;
        }

        /* ================================
           CONTENEDOR PRINCIPAL
           ================================ */

        .dashboard {
            display: flex;
            min-height: 100vh;
        }

        /* ================================
           SIDEBAR
           ================================ */

        .sidebar {
            width: 250px;
            min-height: 100vh;

            background:
                linear-gradient(
                    180deg,
                    #0f172a 0%,
                    #172554 100%
                );

            color: white;

            position: fixed;
            left: 0;
            top: 0;
            bottom: 0;

            display: flex;
            flex-direction: column;

            box-shadow:
                5px 0 25px rgba(
                    15,
                    23,
                    42,
                    0.12
                );

            z-index: 100;
        }

        .logo-area {
            padding: 28px 22px;

            display: flex;
            align-items: center;
            gap: 13px;

            border-bottom:
                1px solid
                rgba(
                    255,
                    255,
                    255,
                    0.08
                );
        }

        .logo {
            width: 46px;
            height: 46px;

            object-fit: cover;

            border-radius: 12px;

            border:
                2px solid
                rgba(
                    255,
                    255,
                    255,
                    0.2
                );
        }

        .logo-text h2 {
            font-size: 17px;
            font-weight: 700;
            letter-spacing: 0.2px;
        }

        .logo-text span {
            display: block;

            margin-top: 3px;

            color: #94a3b8;

            font-size: 11px;
        }

        .menu {
            padding: 25px 14px;
            flex: 1;
        }

        .menu-title {
            padding:
                0 12px 10px;

            color: #64748b;

            font-size: 10px;
            font-weight: 700;

            text-transform: uppercase;

            letter-spacing: 1.2px;
        }

        .menu a {
            display: flex;
            align-items: center;
            gap: 12px;

            padding: 12px 13px;

            margin-bottom: 5px;

            border-radius: 9px;

            color: #cbd5e1;

            text-decoration: none;

            font-size: 13px;

            transition:
                background 0.2s,
                color 0.2s,
                transform 0.2s;
        }

        .menu a:hover {
            background:
                rgba(
                    255,
                    255,
                    255,
                    0.07
                );

            color: white;

            transform:
                translateX(2px);
        }

        .menu a.activo {
            background:
                linear-gradient(
                    135deg,
                    #2563eb,
                    #1d4ed8
                );

            color: white;

            box-shadow:
                0 5px 15px
                rgba(
                    37,
                    99,
                    235,
                    0.25
                );
        }

        .icono-menu {
            width: 27px;
            height: 27px;

            display: flex;
            align-items: center;
            justify-content: center;

            border-radius: 7px;

            background:
                rgba(
                    255,
                    255,
                    255,
                    0.06
                );

            font-size: 13px;
        }

        .menu a.activo .icono-menu {
            background:
                rgba(
                    255,
                    255,
                    255,
                    0.15
                );
        }

        .usuario-sidebar {
            padding: 18px;

            border-top:
                1px solid
                rgba(
                    255,
                    255,
                    255,
                    0.08
                );
        }

        .usuario-box {
            display: flex;
            align-items: center;
            gap: 10px;

            padding: 10px;

            border-radius: 10px;

            background:
                rgba(
                    255,
                    255,
                    255,
                    0.05
                );
        }

        .avatar-sidebar {
            width: 35px;
            height: 35px;

            border-radius: 50%;

            background:
                linear-gradient(
                    135deg,
                    #3b82f6,
                    #6366f1
                );

            display: flex;
            align-items: center;
            justify-content: center;

            font-size: 13px;
            font-weight: bold;
        }

        .usuario-info {
            overflow: hidden;
        }

        .usuario-info strong {
            display: block;

            color: white;

            font-size: 12px;

            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .usuario-info span {
            color: #94a3b8;
            font-size: 10px;
        }

        /* ================================
           CONTENIDO
           ================================ */

        .contenido {
            width: calc(100% - 250px);

            margin-left: 250px;

            min-height: 100vh;
        }

        /* ================================
           TOPBAR
           ================================ */

        .topbar {
            height: 76px;

            background: white;

            border-bottom:
                1px solid #e2e8f0;

            display: flex;
            align-items: center;
            justify-content: space-between;

            padding:
                0 35px;
        }

        .breadcrumb {
            color: #64748b;
            font-size: 12px;
        }

        .breadcrumb strong {
            color: #1e293b;
        }

        .topbar-right {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .estado-sistema {
            display: flex;
            align-items: center;
            gap: 7px;

            padding:
                7px 11px;

            border-radius: 20px;

            background: #f0fdf4;

            color: #15803d;

            font-size: 11px;
            font-weight: 600;
        }

        .punto-online {
            width: 7px;
            height: 7px;

            border-radius: 50%;

            background: #22c55e;
        }

        .btn-panel {
            display: inline-flex;
            align-items: center;
            gap: 7px;

            padding:
                9px 14px;

            border:
                1px solid #e2e8f0;

            border-radius: 8px;

            background: white;

            color: #475569;

            text-decoration: none;

            font-size: 12px;
            font-weight: 600;

            transition: 0.2s;
        }

        .btn-panel:hover {
            background: #f8fafc;
            border-color: #cbd5e1;
        }

        /* ================================
           AREA PRINCIPAL
           ================================ */

        .principal {
            padding: 32px 35px 45px;
        }

        .cabecera-pagina {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;

            gap: 20px;

            margin-bottom: 27px;
        }

        .cabecera-pagina h1 {
            color: #0f172a;

            font-size: 28px;
            font-weight: 750;

            letter-spacing: -0.6px;
        }

        .cabecera-pagina p {
            margin-top: 7px;

            color: #64748b;

            font-size: 13px;
        }

        .btn-nuevo {
            display: inline-flex;
            align-items: center;
            gap: 8px;

            padding:
                11px 17px;

            border-radius: 9px;

            background:
                linear-gradient(
                    135deg,
                    #2563eb,
                    #1d4ed8
                );

            color: white;

            text-decoration: none;

            font-size: 12px;
            font-weight: 700;

            box-shadow:
                0 5px 14px
                rgba(
                    37,
                    99,
                    235,
                    0.2
                );

            transition: 0.2s;
        }

        .btn-nuevo:hover {
            transform:
                translateY(-1px);

            box-shadow:
                0 8px 20px
                rgba(
                    37,
                    99,
                    235,
                    0.28
                );
        }

        .btn-nuevo span {
            font-size: 18px;
            line-height: 12px;
        }

        /* ================================
           TARJETAS ESTADISTICAS
           ================================ */

        .estadisticas {
            display: grid;

            grid-template-columns:
                repeat(
                    4,
                    minmax(
                        0,
                        1fr
                    )
                );

            gap: 17px;

            margin-bottom: 25px;
        }

        .estadistica {
            background: white;

            border:
                1px solid #e5e7eb;

            border-radius: 13px;

            padding: 19px;

            display: flex;
            align-items: center;

            gap: 14px;

            box-shadow:
                0 2px 8px
                rgba(
                    15,
                    23,
                    42,
                    0.03
                );

            transition: 0.2s;
        }

        .estadistica:hover {
            transform:
                translateY(-2px);

            box-shadow:
                0 8px 20px
                rgba(
                    15,
                    23,
                    42,
                    0.07
                );
        }

        .icono-estadistica {
            width: 43px;
            height: 43px;

            flex-shrink: 0;

            border-radius: 11px;

            display: flex;
            align-items: center;
            justify-content: center;

            font-size: 18px;
        }

        .icono-azul {
            background: #eff6ff;
            color: #2563eb;
        }

        .icono-morado {
            background: #f5f3ff;
            color: #7c3aed;
        }

        .icono-verde {
            background: #ecfdf5;
            color: #059669;
        }

        .icono-naranja {
            background: #fff7ed;
            color: #ea580c;
        }

        .estadistica-info span {
            display: block;

            color: #64748b;

            font-size: 11px;

            margin-bottom: 4px;
        }

        .estadistica-info strong {
            display: block;

            color: #0f172a;

            font-size: 22px;
            line-height: 1;
        }

        /* ================================
           MENSAJES
           ================================ */

        .mensaje {
            padding:
                13px 16px;

            border-radius: 9px;

            margin-bottom: 20px;

            font-size: 13px;
        }

        .mensaje-exito {
            background: #ecfdf5;
            border: 1px solid #bbf7d0;
            color: #166534;
        }

        .mensaje-error {
            background: #fef2f2;
            border: 1px solid #fecaca;
            color: #991b1b;
        }

        /* ================================
           TARJETA TABLA
           ================================ */

        .tabla-card {
            background: white;

            border:
                1px solid #e5e7eb;

            border-radius: 14px;

            overflow: hidden;

            box-shadow:
                0 2px 10px
                rgba(
                    15,
                    23,
                    42,
                    0.035
                );
        }

        .tabla-header {
            padding:
                20px 22px;

            display: flex;
            align-items: center;
            justify-content: space-between;

            gap: 20px;

            border-bottom:
                1px solid #e5e7eb;
        }

        .tabla-titulo h2 {
            color: #0f172a;

            font-size: 16px;
            font-weight: 700;
        }

        .tabla-titulo p {
            margin-top: 4px;

            color: #94a3b8;

            font-size: 11px;
        }

        /* ================================
           BUSCADOR
           ================================ */

        .buscador {
            position: relative;

            width: 270px;
        }

        .buscador input {
            width: 100%;

            height: 38px;

            padding:
                0 13px 0 37px;

            border:
                1px solid #e2e8f0;

            border-radius: 8px;

            background: #f8fafc;

            color: #334155;

            outline: none;

            font-family: inherit;

            font-size: 11px;

            transition: 0.2s;
        }

        .buscador input:focus {
            background: white;

            border-color: #93c5fd;

            box-shadow:
                0 0 0 3px
                rgba(
                    59,
                    130,
                    246,
                    0.08
                );
        }

        .icono-busqueda {
            position: absolute;

            left: 13px;
            top: 50%;

            transform:
                translateY(-50%);

            color: #94a3b8;

            font-size: 14px;
        }

        /* ================================
           TABLA
           ================================ */

        .tabla-contenedor {
            width: 100%;

            overflow-x: auto;
        }

        table {
            width: 100%;

            border-collapse: collapse;

            min-width: 1000px;
        }

        thead {
            background: #f8fafc;
        }

        th {
            padding:
                12px 20px;

            color: #64748b;

            text-align: left;

            font-size: 10px;

            font-weight: 700;

            text-transform: uppercase;

            letter-spacing: 0.6px;

            white-space: nowrap;

            border-bottom:
                1px solid #e5e7eb;
        }

        td {
            padding:
                14px 20px;

            color: #475569;

            font-size: 12px;

            border-bottom:
                1px solid #f1f5f9;

            vertical-align: middle;
        }

        tbody tr {
            transition:
                background 0.15s;
        }

        tbody tr:hover {
            background: #fafcff;
        }

        tbody tr:last-child td {
            border-bottom: none;
        }

        /* ================================
           USUARIO
           ================================ */

        .usuario-celda {
            display: flex;
            align-items: center;
            gap: 10px;

            min-width: 170px;
        }

        .avatar {
            width: 36px;
            height: 36px;

            flex-shrink: 0;

            border-radius: 50%;

            background:
                linear-gradient(
                    135deg,
                    #dbeafe,
                    #bfdbfe
                );

            color: #1d4ed8;

            display: flex;
            align-items: center;
            justify-content: center;

            font-size: 12px;
            font-weight: 800;
        }

        .nombre-usuario strong {
            display: block;

            color: #1e293b;

            font-size: 12px;

            margin-bottom: 3px;
        }

        .nombre-usuario span {
            display: block;

            color: #94a3b8;

            font-size: 10px;
        }

        /* ================================
           ID
           ================================ */

        .id-usuario {
            color: #94a3b8;

            font-family:
                Consolas,
                monospace;

            font-size: 11px;
        }

        /* ================================
           ROL
           ================================ */

        .rol-badge {
            display: inline-flex;
            align-items: center;

            padding:
                5px 9px;

            border-radius: 6px;

            font-size: 10px;

            font-weight: 700;

            text-transform: capitalize;
        }

        .rol-admin {
            background: #f3e8ff;
            color: #7e22ce;
        }

        .rol-tecnico {
            background: #e0f2fe;
            color: #0369a1;
        }

        .rol-cliente {
            background: #f1f5f9;
            color: #475569;
        }

        .rol-otro {
            background: #f8fafc;
            color: #64748b;
        }

        /* ================================
           ESTADO
           ================================ */

        .estado {
            display: inline-flex;
            align-items: center;
            gap: 6px;

            font-size: 10px;
            font-weight: 700;
        }

        .estado-punto {
            width: 7px;
            height: 7px;

            border-radius: 50%;
        }

        .activo {
            color: #15803d;
        }

        .activo .estado-punto {
            background: #22c55e;
        }

        .inactivo {
            color: #64748b;
        }

        .inactivo .estado-punto {
            background: #94a3b8;
        }

        /* ================================
           ACCIONES
           ================================ */

        .acciones {
            display: flex;
            align-items: center;

            gap: 7px;

            white-space: nowrap;
        }

        .btn-accion {
            width: 31px;
            height: 31px;

            display: inline-flex;
            align-items: center;
            justify-content: center;

            border-radius: 7px;

            text-decoration: none;

            font-size: 11px;
            font-weight: 700;

            transition: 0.2s;
        }

        .btn-editar {
            background: #eff6ff;

            color: #2563eb;

            border:
                1px solid #dbeafe;
        }

        .btn-editar:hover {
            background: #dbeafe;

            transform:
                translateY(-1px);
        }

        .btn-eliminar {
            background: #fef2f2;

            color: #dc2626;

            border:
                1px solid #fee2e2;
        }

        .btn-eliminar:hover {
            background: #fee2e2;

            transform:
                translateY(-1px);
        }

        /* ================================
           SIN DATOS
           ================================ */

        .sin-datos {
            text-align: center;

            padding:
                60px 20px;

            color: #64748b;
        }

        .sin-datos-icono {
            width: 55px;
            height: 55px;

            margin:
                0 auto 15px;

            border-radius: 14px;

            background: #f1f5f9;

            display: flex;
            align-items: center;
            justify-content: center;

            font-size: 22px;
        }

        .sin-datos h3 {
            margin-bottom: 6px;

            color: #334155;

            font-size: 15px;
        }

        .sin-datos p {
            font-size: 12px;
        }

        /* ================================
           PIE DE TABLA
           ================================ */

        .tabla-footer {
            padding:
                14px 22px;

            border-top:
                1px solid #e5e7eb;

            background: #fafbfc;

            color: #94a3b8;

            font-size: 10px;
        }

        /* ================================
           RESPONSIVE
           ================================ */

        @media (max-width: 1100px) {

            .estadisticas {
                grid-template-columns:
                    repeat(
                        2,
                        minmax(
                            0,
                            1fr
                        )
                    );
            }

        }

        @media (max-width: 850px) {

            .sidebar {
                width: 70px;
            }

            .logo-area {
                justify-content: center;

                padding:
                    18px 10px;
            }

            .logo {
                width: 40px;
                height: 40px;
            }

            .logo-text,
            .menu-title,
            .menu a span:not(.icono-menu),
            .usuario-info {
                display: none;
            }

            .menu a {
                justify-content: center;

                padding: 12px;
            }

            .usuario-sidebar {
                padding: 10px;
            }

            .usuario-box {
                justify-content: center;

                padding: 8px;
            }

            .contenido {
                width: calc(100% - 70px);

                margin-left: 70px;
            }

            .topbar {
                padding:
                    0 20px;
            }

            .principal {
                padding:
                    25px 20px 35px;
            }

            .estado-sistema {
                display: none;
            }

        }

        @media (max-width: 650px) {

            .estadisticas {
                grid-template-columns: 1fr;
            }

            .cabecera-pagina {
                align-items: stretch;

                flex-direction: column;
            }

            .btn-nuevo {
                justify-content: center;
            }

            .tabla-header {
                align-items: stretch;

                flex-direction: column;
            }

            .buscador {
                width: 100%;
            }

            .topbar {
                height: 65px;
            }

            .breadcrumb {
                font-size: 10px;
            }

        }

    </style>

</head>

<body>

<div class="dashboard">

    <!-- =================================
         SIDEBAR
         ================================= -->

    <aside class="sidebar">

        <div class="logo-area">

            <img
                src="<%= request.getContextPath() %>/img/logo.jpg"
                alt="Rescate Móvil"
                class="logo">

            <div class="logo-text">

                <h2>
                    Rescate Móvil
                </h2>

                <span>
                    Panel administrativo
                </span>

            </div>

        </div>


        <nav class="menu">

            <div class="menu-title">
                Menú principal
            </div>


            <a
                href="<%= request.getContextPath() %>/admin/index.jsp">

                <span class="icono-menu">
                    IN
                </span>

                <span>
                    Inicio
                </span>

            </a>


            <a
                href="<%= request.getContextPath() %>/admin/usuarios"
                class="activo">

                <span class="icono-menu">
                    US
                </span>

                <span>
                    Usuarios
                </span>

            </a>


            <a href="#">

                <span class="icono-menu">
                    CL
                </span>

                <span>
                    Clientes
                </span>

            </a>


            <a href="#">

                <span class="icono-menu">
                    TE
                </span>

                <span>
                    Técnicos
                </span>

            </a>


            <a href="#">

                <span class="icono-menu">
                    PR
                </span>

                <span>
                    Productos
                </span>

            </a>


            <a href="#">

                <span class="icono-menu">
                    RE
                </span>

                <span>
                    Reparaciones
                </span>

            </a>


            <a href="#">

                <span class="icono-menu">
                    VE
                </span>

                <span>
                    Ventas
                </span>

            </a>


            <a href="#">

                <span class="icono-menu">
                    NO
                </span>

                <span>
                    Notificaciones
                </span>

            </a>


            <a href="#">

                <span class="icono-menu">
                    RP
                </span>

                <span>
                    Reportes
                </span>

            </a>

        </nav>


        <div class="usuario-sidebar">

            <div class="usuario-box">

                <div class="avatar-sidebar">

                    <%= usuarioSesion != null
                            && !usuarioSesion.isEmpty()
                            ? usuarioSesion
                                .substring(0, 1)
                                .toUpperCase()
                            : "A" %>

                </div>

                <div class="usuario-info">

                    <strong>
                        <%= usuarioSesion %>
                    </strong>

                    <span>
                        Administrador
                    </span>

                </div>

            </div>

        </div>

    </aside>


    <!-- =================================
         CONTENIDO
         ================================= -->

    <section class="contenido">


        <!-- TOPBAR -->

        <header class="topbar">

            <div class="breadcrumb">

                Panel administrativo
                &nbsp;/&nbsp;

                <strong>
                    Gestión de usuarios
                </strong>

            </div>


            <div class="topbar-right">

                <div class="estado-sistema">

                    <span class="punto-online"></span>

                    Sistema activo

                </div>


                <a
                    href="<%= request.getContextPath() %>/admin/index.jsp"
                    class="btn-panel">

                    Volver al panel

                </a>

            </div>

        </header>


        <!-- CONTENIDO PRINCIPAL -->

        <main class="principal">


            <!-- CABECERA -->

            <div class="cabecera-pagina">

                <div>

                    <h1>
                        Gestión de usuarios
                    </h1>

                    <p>
                        Administra las cuentas y permisos
                        de los usuarios de Rescate Móvil.
                    </p>

                </div>


                <a
                    href="<%= request.getContextPath() %>/admin/nuevo-usuario.jsp"
                    class="btn-nuevo">

                    <span>
                        +
                    </span>

                    Nuevo usuario

                </a>

            </div>


            <!-- MENSAJES -->

            <% if ("eliminado".equals(mensaje)) { %>

                <div class="mensaje mensaje-exito">

                    El usuario fue eliminado correctamente.

                </div>

            <% } %>


            <% if ("noencontrado".equals(error)) { %>

                <div class="mensaje mensaje-error">

                    No se encontró el usuario solicitado.

                </div>

            <% } %>


            <% if ("eliminar".equals(error)) { %>

                <div class="mensaje mensaje-error">

                    No fue posible eliminar el usuario.

                </div>

            <% } %>


            <% if ("id".equals(error)) { %>

                <div class="mensaje mensaje-error">

                    El identificador del usuario no es válido.

                </div>

            <% } %>


            <!-- ESTADISTICAS -->

            <div class="estadisticas">


                <div class="estadistica">

                    <div
                        class="icono-estadistica icono-azul">

                        US

                    </div>

                    <div class="estadistica-info">

                        <span>
                            Total usuarios
                        </span>

                        <strong>
                            <%= totalUsuarios %>
                        </strong>

                    </div>

                </div>


                <div class="estadistica">

                    <div
                        class="icono-estadistica icono-morado">

                        AD

                    </div>

                    <div class="estadistica-info">

                        <span>
                            Administradores
                        </span>

                        <strong>
                            <%= administradores %>
                        </strong>

                    </div>

                </div>


                <div class="estadistica">

                    <div
                        class="icono-estadistica icono-verde">

                        TE

                    </div>

                    <div class="estadistica-info">

                        <span>
                            Técnicos
                        </span>

                        <strong>
                            <%= tecnicos %>
                        </strong>

                    </div>

                </div>


                <div class="estadistica">

                    <div
                        class="icono-estadistica icono-naranja">

                        CL

                    </div>

                    <div class="estadistica-info">

                        <span>
                            Clientes
                        </span>

                        <strong>
                            <%= clientes %>
                        </strong>

                    </div>

                </div>

            </div>


            <!-- TABLA -->

            <div class="tabla-card">


                <div class="tabla-header">

                    <div class="tabla-titulo">

                        <h2>
                            Usuarios registrados
                        </h2>

                        <p>
                            Consulta y administra
                            las cuentas del sistema.
                        </p>

                    </div>


                    <div class="buscador">

                        <span class="icono-busqueda">
                            ?
                        </span>

                        <input
                            type="text"
                            id="buscarUsuario"
                            placeholder="Buscar usuario..."
                            onkeyup="filtrarUsuarios()">

                    </div>

                </div>


                <% if (usuarios == null
                        || usuarios.isEmpty()) { %>


                    <div class="sin-datos">

                        <div class="sin-datos-icono">
                            US
                        </div>

                        <h3>
                            No hay usuarios registrados
                        </h3>

                        <p>
                            Actualmente no existen
                            usuarios para mostrar.
                        </p>

                    </div>


                <% } else { %>


                    <div class="tabla-contenedor">

                        <table id="tablaUsuarios">

                            <thead>

                                <tr>

                                    <th>
                                        ID
                                    </th>

                                    <th>
                                        Usuario
                                    </th>

                                    <th>
                                        Correo
                                    </th>

                                    <th>
                                        Teléfono
                                    </th>

                                    <th>
                                        Rol
                                    </th>

                                    <th>
                                        Estado
                                    </th>

                                    <th>
                                        Acciones
                                    </th>

                                </tr>

                            </thead>


                            <tbody>


                            <%
                                for (Usuario u : usuarios) {

                                    String nombre =
                                            u.getNombre() != null
                                            ? u.getNombre()
                                            : "";

                                    String usuario =
                                            u.getUsuario() != null
                                            ? u.getUsuario()
                                            : "";

                                    String correo =
                                            u.getCorreo() != null
                                            ? u.getCorreo()
                                            : "";

                                    String telefono =
                                            u.getTelefono() != null
                                            ? u.getTelefono()
                                            : "";

                                    String rolUsuario =
                                            u.getRol() != null
                                            ? u.getRol()
                                            : "";

                                    String inicial =
                                            nombre.isEmpty()
                                            ? "U"
                                            : nombre
                                                .substring(0, 1)
                                                .toUpperCase();

                                    String claseRol =
                                            "rol-otro";

                                    if ("admin".equalsIgnoreCase(
                                            rolUsuario)) {

                                        claseRol =
                                                "rol-admin";

                                    } else if (
                                            "tecnico".equalsIgnoreCase(
                                                    rolUsuario)) {

                                        claseRol =
                                                "rol-tecnico";

                                    } else if (
                                            "cliente".equalsIgnoreCase(
                                                    rolUsuario)) {

                                        claseRol =
                                                "rol-cliente";
                                    }
                            %>


                                <tr class="fila-usuario">


                                    <!-- ID -->

                                    <td>

                                        <span class="id-usuario">

                                            #<%= u.getId() %>

                                        </span>

                                    </td>


                                    <!-- USUARIO -->

                                    <td>

                                        <div class="usuario-celda">

                                            <div class="avatar">

                                                <%= inicial %>

                                            </div>


                                            <div class="nombre-usuario">

                                                <strong>
                                                    <%= nombre %>
                                                </strong>

                                                <span>
                                                    @<%= usuario %>
                                                </span>

                                            </div>

                                        </div>

                                    </td>


                                    <!-- CORREO -->

                                    <td>

                                        <%= correo %>

                                    </td>


                                    <!-- TELEFONO -->

                                    <td>

                                        <%= telefono %>

                                    </td>


                                    <!-- ROL -->

                                    <td>

                                        <span
                                            class="rol-badge <%= claseRol %>">

                                            <%= rolUsuario %>

                                        </span>

                                    </td>


                                    <!-- ESTADO -->

                                    <td>

                                        <% if (u.isActivo()) { %>

                                            <span
                                                class="estado activo">

                                                <span
                                                    class="estado-punto">
                                                </span>

                                                Activo

                                            </span>

                                        <% } else { %>

                                            <span
                                                class="estado inactivo">

                                                <span
                                                    class="estado-punto">
                                                </span>

                                                Inactivo

                                            </span>

                                        <% } %>

                                    </td>


                                    <!-- ACCIONES -->

                                    <td>

                                        <div class="acciones">


                                            <a
                                                href="<%= request.getContextPath() %>/admin/usuarios?action=editar&id=<%= u.getId() %>"
                                                class="btn-accion btn-editar"
                                                title="Editar usuario">

                                                E

                                            </a>


                                            <a
                                                href="<%= request.getContextPath() %>/admin/usuarios?action=eliminar&id=<%= u.getId() %>"
                                                class="btn-accion btn-eliminar"
                                                title="Eliminar usuario"
                                                onclick="return confirmarEliminacion();">

                                                X

                                            </a>


                                        </div>

                                    </td>


                                </tr>


                            <%
                                }
                            %>


                            </tbody>

                        </table>

                    </div>


                    <div class="tabla-footer">

                        Mostrando
                        <strong>
                            <%= totalUsuarios %>
                        </strong>
                        usuario(s) registrado(s).

                        &nbsp;

                        <span>
                            <%= activos %>
                        </span>

                    </div>


                <% } %>


            </div>


        </main>

    </section>

</div>


<!-- =================================
     JAVASCRIPT
     ================================= -->

<script>

    function confirmarEliminacion() {

        return confirm(
            "¿Está seguro de eliminar este usuario?"
            + "\n\nEsta acción no se puede deshacer."
        );
    }


    function filtrarUsuarios() {

        const input =
            document.getElementById(
                "buscarUsuario"
            );

        const filtro =
            input.value.toLowerCase();

        const filas =
            document.querySelectorAll(
                "#tablaUsuarios tbody tr"
            );


        filas.forEach(function(fila) {

            const texto =
                fila.textContent.toLowerCase();

            if (texto.includes(filtro)) {

                fila.style.display = "";

            } else {

                fila.style.display = "none";
            }

        });

    }

</script>


</body>

</html>