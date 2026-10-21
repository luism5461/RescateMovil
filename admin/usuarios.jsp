<%-- 
    Document   : usuarios
    Created on : 23/09/2026, 10:37:51 p. m.
    Author     : Luis Alejandro Murillo Diaz
--%>

<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.rescatemovil.modelo.Usuario"%>

<%
    String usuarioSesion = (String) session.getAttribute("usuario");
    String rolSesion = (String) session.getAttribute("rol");

    if (usuarioSesion == null || rolSesion == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    if (!"admin".equalsIgnoreCase(rolSesion)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=acceso");
        return;
    }

    List<Usuario> usuarios =
        (List<Usuario>) request.getAttribute("usuarios");

    String mensaje = request.getParameter("mensaje");
    String error = request.getParameter("error");

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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Gestión de usuarios | Rescate Móvil</title>

    <style>
        :root {
            --fondo: #07111f;
            --fondo-secundario: #0a1628;
            --tarjeta: #101e32;
            --tarjeta-hover: #14243a;
            --borde: #263b55;
            --texto: #f1f5f9;
            --texto-secundario: #9aadc4;
            --cian: #00b4d8;
            --azul: #4361ee;
            --verde: #10b981;
            --rojo: #ef4444;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html {
            min-height: 100%;
        }

        body {
            min-height: 100vh;
            font-family: "Segoe UI", Arial, Helvetica, sans-serif;
            color: var(--texto);
            background:
                radial-gradient(
                    circle at 12% 0%,
                    rgba(0, 180, 216, 0.12),
                    transparent 32%
                ),
                radial-gradient(
                    circle at 90% 12%,
                    rgba(67, 97, 238, 0.13),
                    transparent 30%
                ),
                var(--fondo);
        }

        a {
            color: inherit;
        }

        .dashboard {
            display: flex;
            min-height: 100vh;
        }

        /* BARRA LATERAL */

        .sidebar {
            width: 250px;
            min-height: 100vh;
            background: linear-gradient(180deg, #07111f, #0b1d35);
            color: white;
            position: fixed;
            left: 0;
            top: 0;
            bottom: 0;
            display: flex;
            flex-direction: column;
            border-right: 1px solid rgba(0, 180, 216, 0.20);
            box-shadow: 5px 0 30px rgba(0, 0, 0, 0.18);
            z-index: 100;
            overflow-y: auto;
        }

        .logo-area {
            padding: 25px 20px;
            display: flex;
            align-items: center;
            gap: 12px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
        }

        .logo {
            width: 45px;
            height: 45px;
            object-fit: cover;
            border-radius: 11px;
            border: 1px solid rgba(0, 180, 216, 0.35);
            background: #101e32;
        }

        .logo-text h2 {
            font-size: 16px;
            font-weight: 750;
        }

        .logo-text h2 span {
            color: var(--cian);
        }

        .logo-text span {
            display: block;
            margin-top: 4px;
            color: var(--texto-secundario);
            font-size: 10px;
        }

        .menu {
            padding: 22px 13px;
            flex: 1;
        }

        .menu-title {
            padding: 0 12px 12px;
            color: #7187a2;
            font-size: 10px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1.2px;
        }

        .menu a {
            display: flex;
            align-items: center;
            gap: 11px;
            padding: 11px 12px;
            margin-bottom: 5px;
            border: 1px solid transparent;
            border-radius: 9px;
            color: #bdcce0;
            text-decoration: none;
            font-size: 12px;
            transition: 0.2s ease;
        }

        .menu a:hover {
            color: white;
            background: rgba(0, 180, 216, 0.08);
            border-color: rgba(0, 180, 216, 0.15);
        }

        .menu a.activo {
            color: #ffffff;
            background: linear-gradient(
                110deg,
                rgba(0, 180, 216, 0.18),
                rgba(67, 97, 238, 0.18)
            );
            border-color: rgba(0, 180, 216, 0.32);
            box-shadow: inset 3px 0 0 var(--cian);
        }

        .icono-menu {
            width: 29px;
            height: 29px;
            flex-shrink: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.055);
            color: #b8d7f0;
            font-size: 10px;
            font-weight: 800;
        }

        .menu a.activo .icono-menu {
            background: rgba(0, 180, 216, 0.15);
            color: #6be7ff;
        }

        .usuario-sidebar {
            padding: 16px;
            border-top: 1px solid rgba(255, 255, 255, 0.08);
        }

        .usuario-box {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px;
            border: 1px solid rgba(255, 255, 255, 0.06);
            border-radius: 10px;
            background: rgba(255, 255, 255, 0.035);
        }

        .avatar-sidebar {
            width: 35px;
            height: 35px;
            flex-shrink: 0;
            border-radius: 50%;
            background: linear-gradient(135deg, #087ea4, #4361ee);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 13px;
            font-weight: bold;
        }

        .usuario-info {
            min-width: 0;
        }

        .usuario-info strong {
            display: block;
            color: white;
            font-size: 11px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .usuario-info span {
            display: block;
            margin-top: 3px;
            color: var(--texto-secundario);
            font-size: 10px;
        }

        /* CONTENIDO */

        .contenido {
            width: calc(100% - 250px);
            margin-left: 250px;
            min-height: 100vh;
        }

        .topbar {
            min-height: 72px;
            background: rgba(7, 17, 31, 0.88);
            border-bottom: 1px solid var(--borde);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            padding: 15px 32px;
        }

        .breadcrumb {
            color: var(--texto-secundario);
            font-size: 12px;
        }

        .breadcrumb strong {
            color: #e4edf8;
        }

        .topbar-right {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .estado-sistema {
            display: flex;
            align-items: center;
            gap: 7px;
            padding: 7px 10px;
            border-radius: 20px;
            background: rgba(16, 185, 129, 0.09);
            border: 1px solid rgba(16, 185, 129, 0.20);
            color: #8ce8bd;
            font-size: 10px;
            font-weight: 600;
            white-space: nowrap;
        }

        .punto-online {
            width: 7px;
            height: 7px;
            border-radius: 50%;
            background: #34d399;
            box-shadow: 0 0 8px rgba(52, 211, 153, 0.55);
        }

        .btn-panel {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 9px 12px;
            border: 1px solid var(--borde);
            border-radius: 8px;
            background: #101e32;
            color: #dce8f6;
            text-decoration: none;
            font-size: 11px;
            transition: 0.2s;
        }

        .btn-panel:hover {
            border-color: var(--cian);
            background: #142740;
        }

        .principal {
            padding: 32px;
            max-width: 1700px;
            margin: 0 auto;
        }

        .cabecera-pagina {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            margin-bottom: 26px;
        }

        .etiqueta {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 6px 10px;
            margin-bottom: 12px;
            border: 1px solid rgba(0, 180, 216, 0.23);
            border-radius: 20px;
            background: rgba(0, 180, 216, 0.08);
            color: #61def5;
            font-size: 10px;
            font-weight: bold;
            letter-spacing: 0.8px;
            text-transform: uppercase;
        }

        .etiqueta-punto {
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: var(--cian);
        }

        .cabecera-pagina h1 {
            color: #f1f5f9;
            font-size: clamp(25px, 3vw, 32px);
            font-weight: 750;
            letter-spacing: -0.6px;
        }

        .cabecera-pagina p {
            margin-top: 8px;
            color: var(--texto-secundario);
            font-size: 13px;
            line-height: 1.6;
        }

        .btn-nuevo {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 12px 16px;
            flex-shrink: 0;
            border: 1px solid rgba(0, 180, 216, 0.35);
            border-radius: 9px;
            background: linear-gradient(135deg, #087ea4, #3457d5);
            color: white;
            text-decoration: none;
            font-size: 12px;
            font-weight: 700;
            box-shadow: 0 6px 20px rgba(0, 180, 216, 0.12);
            transition: 0.2s;
        }

        .btn-nuevo:hover {
            transform: translateY(-2px);
            filter: brightness(1.1);
        }

        .btn-nuevo span {
            font-size: 18px;
            line-height: 12px;
        }

        /* ESTADÍSTICAS */

        .estadisticas {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 16px;
            margin-bottom: 23px;
        }

        .estadistica {
            min-width: 0;
            display: flex;
            align-items: center;
            gap: 13px;
            padding: 19px;
            border: 1px solid var(--borde);
            border-radius: 13px;
            background: linear-gradient(
                145deg,
                rgba(16, 30, 50, 0.98),
                rgba(11, 24, 42, 0.98)
            );
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.10);
            transition: 0.2s;
        }

        .estadistica:hover {
            transform: translateY(-2px);
            border-color: #385574;
        }

        .icono-estadistica {
            width: 43px;
            height: 43px;
            flex-shrink: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 11px;
            font-size: 12px;
            font-weight: 800;
        }

        .icono-azul {
            background: rgba(0, 180, 216, 0.13);
            color: #6be7ff;
        }

        .icono-morado {
            background: rgba(139, 92, 246, 0.14);
            color: #c4b5fd;
        }

        .icono-verde {
            background: rgba(16, 185, 129, 0.13);
            color: #6ee7b7;
        }

        .icono-naranja {
            background: rgba(249, 115, 22, 0.13);
            color: #fdba74;
        }

        .estadistica-info {
            min-width: 0;
        }

        .estadistica-info span {
            display: block;
            margin-bottom: 7px;
            color: var(--texto-secundario);
            font-size: 11px;
        }

        .estadistica-info strong {
            display: block;
            color: #f1f5f9;
            font-size: 24px;
            line-height: 1;
        }

        /* MENSAJES */

        .mensaje {
            padding: 13px 16px;
            margin-bottom: 18px;
            border-radius: 9px;
            font-size: 12px;
            line-height: 1.6;
        }

        .mensaje-exito {
            color: #a7f3d0;
            background: rgba(16, 185, 129, 0.10);
            border: 1px solid rgba(16, 185, 129, 0.26);
        }

        .mensaje-error {
            color: #fecaca;
            background: rgba(239, 68, 68, 0.10);
            border: 1px solid rgba(239, 68, 68, 0.27);
        }

        /* TABLA */

        .tabla-card {
            overflow: hidden;
            border: 1px solid var(--borde);
            border-radius: 14px;
            background: rgba(13, 27, 46, 0.97);
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.13);
        }

        .tabla-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 16px;
            padding: 20px 22px;
            border-bottom: 1px solid var(--borde);
        }

        .tabla-titulo h2 {
            color: #f1f5f9;
            font-size: 16px;
            font-weight: 700;
        }

        .tabla-titulo p {
            margin-top: 6px;
            color: var(--texto-secundario);
            font-size: 11px;
        }

        .buscador {
            position: relative;
            width: 270px;
            max-width: 100%;
        }

        .buscador input {
            width: 100%;
            height: 40px;
            padding: 0 13px 0 38px;
            border: 1px solid #30445e;
            border-radius: 8px;
            outline: none;
            background: #091526;
            color: #e2eaf5;
            font-family: inherit;
            font-size: 12px;
            transition: 0.2s;
        }

        .buscador input::placeholder {
            color: #7187a2;
        }

        .buscador input:focus {
            border-color: var(--cian);
            box-shadow: 0 0 0 3px rgba(0, 180, 216, 0.10);
        }

        .icono-busqueda {
            position: absolute;
            top: 50%;
            left: 13px;
            transform: translateY(-50%);
            color: #8ba4bf;
            font-size: 15px;
        }

        .tabla-contenedor {
            width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            min-width: 950px;
            border-collapse: collapse;
        }

        thead {
            background: #101f34;
        }

        th {
            padding: 13px 18px;
            color: #9eb4ce;
            text-align: left;
            font-size: 10px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            white-space: nowrap;
            border-bottom: 1px solid var(--borde);
        }

        td {
            padding: 14px 18px;
            color: #cbd8e8;
            font-size: 12px;
            border-bottom: 1px solid rgba(38, 59, 85, 0.68);
            vertical-align: middle;
        }

        tbody tr {
            transition: background 0.2s;
        }

        tbody tr:hover {
            background: rgba(0, 180, 216, 0.035);
        }

        tbody tr:last-child td {
            border-bottom: none;
        }

        .usuario-celda {
            display: flex;
            align-items: center;
            gap: 10px;
            min-width: 170px;
        }

        .avatar {
            width: 37px;
            height: 37px;
            flex-shrink: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 1px solid rgba(0, 180, 216, 0.25);
            border-radius: 50%;
            background: linear-gradient(
                135deg,
                rgba(0, 180, 216, 0.18),
                rgba(67, 97, 238, 0.24)
            );
            color: #8beaff;
            font-size: 13px;
            font-weight: 800;
        }

        .nombre-usuario strong {
            display: block;
            margin-bottom: 4px;
            color: #f1f5f9;
            font-size: 12px;
        }

        .nombre-usuario span {
            display: block;
            color: #8fa5bf;
            font-size: 10px;
        }

        .id-usuario {
            color: #91a8c2;
            font-family: Consolas, monospace;
            font-size: 11px;
        }

        .rol-badge {
            display: inline-flex;
            align-items: center;
            padding: 6px 9px;
            border: 1px solid transparent;
            border-radius: 6px;
            font-size: 10px;
            font-weight: 700;
            text-transform: capitalize;
        }

        .rol-admin {
            color: #d8b4fe;
            background: rgba(168, 85, 247, 0.12);
            border-color: rgba(168, 85, 247, 0.22);
        }

        .rol-tecnico {
            color: #7dd3fc;
            background: rgba(14, 165, 233, 0.11);
            border-color: rgba(14, 165, 233, 0.22);
        }

        .rol-cliente {
            color: #cbd5e1;
            background: rgba(148, 163, 184, 0.10);
            border-color: rgba(148, 163, 184, 0.20);
        }

        .rol-otro {
            color: #a5b4fc;
            background: rgba(99, 102, 241, 0.11);
            border-color: rgba(99, 102, 241, 0.22);
        }

        .estado {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            font-size: 10px;
            font-weight: 700;
            white-space: nowrap;
        }

        .estado-punto {
            width: 7px;
            height: 7px;
            border-radius: 50%;
        }

        .activo {
            color: #86efac;
        }

        .activo .estado-punto {
            background: #22c55e;
            box-shadow: 0 0 7px rgba(34, 197, 94, 0.35);
        }

        .inactivo {
            color: #a7b4c5;
        }

        .inactivo .estado-punto {
            background: #94a3b8;
        }

        .acciones {
            display: flex;
            align-items: center;
            gap: 8px;
            white-space: nowrap;
        }

        .btn-accion {
            width: 33px;
            height: 33px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            text-decoration: none;
            font-size: 11px;
            font-weight: 800;
            transition: 0.2s;
        }

        .btn-editar {
            color: #93c5fd;
            background: rgba(59, 130, 246, 0.12);
            border: 1px solid rgba(59, 130, 246, 0.25);
        }

        .btn-editar:hover {
            background: rgba(59, 130, 246, 0.23);
            transform: translateY(-1px);
        }

        .btn-eliminar {
            color: #fca5a5;
            background: rgba(239, 68, 68, 0.10);
            border: 1px solid rgba(239, 68, 68, 0.25);
        }

        .btn-eliminar:hover {
            background: rgba(239, 68, 68, 0.20);
            transform: translateY(-1px);
        }

        .sin-datos {
            padding: 55px 20px;
            text-align: center;
            color: var(--texto-secundario);
        }

        .sin-datos-icono {
            width: 55px;
            height: 55px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 14px;
            border: 1px solid var(--borde);
            border-radius: 14px;
            background: #101e32;
            color: var(--cian);
            font-size: 14px;
            font-weight: 800;
        }

        .sin-datos h3 {
            margin-bottom: 7px;
            color: #e2eaf5;
            font-size: 15px;
        }

        .sin-datos p {
            font-size: 12px;
        }

        .tabla-footer {
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 10px;
            padding: 14px 22px;
            border-top: 1px solid var(--borde);
            background: #0d1a2d;
            color: #91a6bf;
            font-size: 11px;
        }

        .tabla-footer strong {
            color: #e2eaf5;
        }

        .tabla-footer .total-activos {
            color: #86efac;
        }

        footer {
            padding: 24px 18px;
            border-top: 1px solid rgba(38, 59, 85, 0.55);
            color: #7388a2;
            text-align: center;
            font-size: 11px;
        }

        @media (max-width: 1200px) {
            .estadisticas {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .principal {
                padding: 25px 22px;
            }
        }

        @media (max-width: 850px) {
            .sidebar {
                width: 70px;
            }

            .logo-area {
                justify-content: center;
                padding: 16px 8px;
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

            .menu {
                padding: 20px 8px;
            }

            .menu a {
                justify-content: center;
                padding: 10px 5px;
            }

            .usuario-sidebar {
                padding: 8px;
            }

            .usuario-box {
                justify-content: center;
                padding: 6px;
            }

            .contenido {
                width: calc(100% - 70px);
                margin-left: 70px;
            }

            .topbar {
                padding: 15px 18px;
            }

            .estado-sistema {
                display: none;
            }
        }

        @media (max-width: 580px) {
            .estadisticas {
                grid-template-columns: 1fr;
                gap: 11px;
            }

            .cabecera-pagina {
                align-items: stretch;
                flex-direction: column;
            }

            .btn-nuevo {
                width: 100%;
            }

            .topbar {
                align-items: flex-start;
                flex-direction: column;
            }

            .topbar-right {
                width: 100%;
            }

            .btn-panel {
                width: 100%;
                justify-content: center;
            }

            .principal {
                padding: 22px 12px;
            }

            .tabla-header {
                align-items: stretch;
                flex-direction: column;
                padding: 17px;
            }

            .buscador {
                width: 100%;
            }
        }
    </style>
</head>

<body>

<div class="dashboard">

    <aside class="sidebar">

        <div class="logo-area">
            <img
                src="<%= request.getContextPath() %>/img/logo.jpg"
                alt="Rescate Móvil"
                class="logo">

            <div class="logo-text">
                <h2>Rescate <span>Móvil</span></h2>
                <span>Panel administrativo</span>
            </div>
        </div>

        <nav class="menu">

            <div class="menu-title">Menú principal</div>

            <a href="<%= request.getContextPath() %>/admin/index.jsp">
                <span class="icono-menu">IN</span>
                <span>Inicio</span>
            </a>

            <a href="<%= request.getContextPath() %>/admin/usuarios"
               class="activo">
                <span class="icono-menu">US</span>
                <span>Usuarios</span>
            </a>

            <a href="<%= request.getContextPath() %>/admin/clientes">
                <span class="icono-menu">CL</span>
                <span>Clientes</span>
            </a>

            <a href="<%= request.getContextPath() %>/admin/tecnicos">
                <span class="icono-menu">TE</span>
                <span>Técnicos</span>
            </a>

            <a href="<%= request.getContextPath() %>/admin/productos">
                <span class="icono-menu">PR</span>
                <span>Productos</span>
            </a>

            <a href="<%= request.getContextPath() %>/admin/reparaciones">
                <span class="icono-menu">RE</span>
                <span>Reparaciones</span>
            </a>

            <a href="<%= request.getContextPath() %>/admin/ventas">
                <span class="icono-menu">VE</span>
                <span>Ventas</span>
            </a>

            <a href="<%= request.getContextPath() %>/admin/notificaciones">
                <span class="icono-menu">NO</span>
                <span>Notificaciones</span>
            </a>

            <a href="<%= request.getContextPath() %>/admin/reportes">
                <span class="icono-menu">RP</span>
                <span>Reportes</span>
            </a>

        </nav>

        <div class="usuario-sidebar">
            <div class="usuario-box">

                <div class="avatar-sidebar">
                    <%= usuarioSesion != null && !usuarioSesion.isEmpty()
                        ? usuarioSesion.substring(0, 1).toUpperCase()
                        : "A" %>
                </div>

                <div class="usuario-info">
                    <strong><%= usuarioSesion %></strong>
                    <span>Administrador</span>
                </div>

            </div>
        </div>

    </aside>

    <section class="contenido">

        <header class="topbar">

            <div class="breadcrumb">
                Panel administrativo &nbsp;/&nbsp;
                <strong>Gestión de usuarios</strong>
            </div>

            <div class="topbar-right">

                <div class="estado-sistema">
                    <span class="punto-online"></span>
                    Sistema activo
                </div>

                <a
                    href="<%= request.getContextPath() %>/admin/index.jsp"
                    class="btn-panel">
                    ← Volver al panel
                </a>

            </div>

        </header>

        <main class="principal">

            <div class="cabecera-pagina">

                <div>
                    <div class="etiqueta">
                        <span class="etiqueta-punto"></span>
                        Administración
                    </div>

                    <h1>Gestión de usuarios</h1>

                    <p>
                        Administra las cuentas y permisos de los usuarios
                        de Rescate Móvil.
                    </p>
                </div>

                <a
                    href="<%= request.getContextPath() %>/admin/nuevo-usuario.jsp"
                    class="btn-nuevo">
                    <span>+</span>
                    Nuevo usuario
                </a>

            </div>

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

            <div class="estadisticas">

                <div class="estadistica">
                    <div class="icono-estadistica icono-azul">US</div>
                    <div class="estadistica-info">
                        <span>Total usuarios</span>
                        <strong><%= totalUsuarios %></strong>
                    </div>
                </div>

                <div class="estadistica">
                    <div class="icono-estadistica icono-morado">AD</div>
                    <div class="estadistica-info">
                        <span>Administradores</span>
                        <strong><%= administradores %></strong>
                    </div>
                </div>

                <div class="estadistica">
                    <div class="icono-estadistica icono-verde">TE</div>
                    <div class="estadistica-info">
                        <span>Técnicos</span>
                        <strong><%= tecnicos %></strong>
                    </div>
                </div>

                <div class="estadistica">
                    <div class="icono-estadistica icono-naranja">CL</div>
                    <div class="estadistica-info">
                        <span>Clientes</span>
                        <strong><%= clientes %></strong>
                    </div>
                </div>

            </div>

            <div class="tabla-card">

                <div class="tabla-header">

                    <div class="tabla-titulo">
                        <h2>Usuarios registrados</h2>
                        <p>Consulta y administra las cuentas del sistema.</p>
                    </div>

                    <div class="buscador">
                        <span class="icono-busqueda">⌕</span>
                        <input
                            type="text"
                            id="buscarUsuario"
                            placeholder="Buscar usuario..."
                            onkeyup="filtrarUsuarios()"
                            aria-label="Buscar usuario">
                    </div>

                </div>

                <% if (usuarios == null || usuarios.isEmpty()) { %>

                    <div class="sin-datos">
                        <div class="sin-datos-icono">US</div>
                        <h3>No hay usuarios registrados</h3>
                        <p>Actualmente no existen usuarios para mostrar.</p>
                    </div>

                <% } else { %>

                    <div class="tabla-contenedor">

                        <table id="tablaUsuarios">

                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Usuario</th>
                                    <th>Correo</th>
                                    <th>Teléfono</th>
                                    <th>Rol</th>
                                    <th>Estado</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>

                            <tbody>

                            <%
                                for (Usuario u : usuarios) {

                                    String nombre = u.getNombre() != null
                                        ? u.getNombre() : "";

                                    String usuario = u.getUsuario() != null
                                        ? u.getUsuario() : "";

                                    String correo = u.getCorreo() != null
                                        ? u.getCorreo() : "";

                                    String telefono = u.getTelefono() != null
                                        ? u.getTelefono() : "";

                                    String rolUsuario = u.getRol() != null
                                        ? u.getRol() : "";

                                    String inicial = nombre.isEmpty()
                                        ? "U"
                                        : nombre.substring(0, 1).toUpperCase();

                                    String claseRol = "rol-otro";

                                    if ("admin".equalsIgnoreCase(rolUsuario)) {
                                        claseRol = "rol-admin";
                                    } else if ("tecnico".equalsIgnoreCase(rolUsuario)) {
                                        claseRol = "rol-tecnico";
                                    } else if ("cliente".equalsIgnoreCase(rolUsuario)) {
                                        claseRol = "rol-cliente";
                                    }
                            %>

                                <tr class="fila-usuario">

                                    <td>
                                        <span class="id-usuario">
                                            #<%= u.getId() %>
                                        </span>
                                    </td>

                                    <td>
                                        <div class="usuario-celda">

                                            <div class="avatar">
                                                <%= inicial %>
                                            </div>

                                            <div class="nombre-usuario">
                                                <strong><%= nombre %></strong>
                                                <span>@<%= usuario %></span>
                                            </div>

                                        </div>
                                    </td>

                                    <td><%= correo %></td>

                                    <td><%= telefono %></td>

                                    <td>
                                        <span class="rol-badge <%= claseRol %>">
                                            <%= rolUsuario %>
                                        </span>
                                    </td>

                                    <td>
                                        <% if (u.isActivo()) { %>

                                            <span class="estado activo">
                                                <span class="estado-punto"></span>
                                                Activo
                                            </span>

                                        <% } else { %>

                                            <span class="estado inactivo">
                                                <span class="estado-punto"></span>
                                                Inactivo
                                            </span>

                                        <% } %>
                                    </td>

                                    <td>
                                        <div class="acciones">

                                            <a
                                                href="<%= request.getContextPath() %>/admin/usuarios?action=editar&amp;id=<%= u.getId() %>"
                                                class="btn-accion btn-editar"
                                                title="Editar usuario"
                                                aria-label="Editar usuario">
                                                E
                                            </a>

                                            <a
                                                href="<%= request.getContextPath() %>/admin/usuarios?action=eliminar&amp;id=<%= u.getId() %>"
                                                class="btn-accion btn-eliminar"
                                                title="Eliminar usuario"
                                                aria-label="Eliminar usuario"
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
                        <span>
                            Mostrando <strong id="totalVisible"><%= totalUsuarios %></strong>
                            usuario(s) registrado(s).
                        </span>

                        <span class="total-activos">
                            <strong><%= activos %></strong> usuario(s) activo(s)
                        </span>
                    </div>

                <% } %>

            </div>

        </main>

        <footer>
            © 2026 Rescate Móvil | Sistema de gestión de servicios técnicos
        </footer>

    </section>

</div>

<script>
    function confirmarEliminacion() {
        return confirm(
            "¿Está seguro de eliminar este usuario?"
            + "\n\nEsta acción no se puede deshacer."
        );
    }

    function filtrarUsuarios() {
        const input = document.getElementById("buscarUsuario");
        const filtro = input.value.toLowerCase();
        const filas = document.querySelectorAll(
            "#tablaUsuarios tbody tr"
        );

        let visibles = 0;

        filas.forEach(function(fila) {
            const texto = fila.textContent.toLowerCase();
            const coincide = texto.includes(filtro);

            fila.style.display = coincide ? "" : "none";

            if (coincide) {
                visibles++;
            }
        });

        const totalVisible = document.getElementById("totalVisible");

        if (totalVisible) {
            totalVisible.textContent = visibles;
        }
    }
</script>

</body>
</html>