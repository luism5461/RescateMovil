<%-- 
    Document   : index
    Created on : 23/09/2026, 8:48:12 p. m.
    Author     : Luis alejandro Murillo Diaz
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String usuario = (String) session.getAttribute("usuario");
    String rol = (String) session.getAttribute("rol");

    if (usuario == null || rol == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    if (!"admin".equalsIgnoreCase(rol)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=acceso");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Panel de Administrador | Rescate Móvil</title>

    <style>

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {

            font-family: Arial, Helvetica, sans-serif;

            background: #07111f;

            color: #ffffff;

            min-height: 100vh;

        }


        /* ==================================
           ESTRUCTURA
        ================================== */

        .layout {

            display: flex;

            min-height: 100vh;

        }


        /* ==================================
           SIDEBAR
        ================================== */

        .sidebar {

            width: 260px;

            background: #081522;

            border-right: 1px solid #1a3046;

            padding: 25px 18px;

            position: fixed;

            left: 0;

            top: 0;

            bottom: 0;

            display: flex;

            flex-direction: column;

            z-index: 100;

        }


        .brand {

            display: flex;

            align-items: center;

            gap: 12px;

            padding: 5px 8px 28px;

            border-bottom: 1px solid #1a3046;

            margin-bottom: 25px;

        }


        .brand img {

            width: 48px;

            height: 48px;

            object-fit: contain;

            border-radius: 12px;

        }


        .brand-text {

            font-size: 17px;

            font-weight: bold;

        }


        .brand-text span {

            color: #00d4ff;

        }


        /* ==================================
           MENU
        ================================== */

        .menu-title {

            color: #60768c;

            font-size: 11px;

            font-weight: bold;

            letter-spacing: 1.5px;

            text-transform: uppercase;

            padding: 0 12px;

            margin-bottom: 12px;

        }


        .menu {

            display: flex;

            flex-direction: column;

            gap: 6px;

        }


        .menu a {

            display: flex;

            align-items: center;

            gap: 13px;

            padding: 13px 12px;

            border-radius: 10px;

            color: #9cafc1;

            text-decoration: none;

            font-size: 14px;

            transition: 0.25s;

        }


        .menu a:hover {

            background: rgba(0, 212, 255, 0.08);

            color: #ffffff;

        }


        .menu a.activo {

            background: rgba(0, 212, 255, 0.12);

            color: #00d4ff;

            border: 1px solid rgba(0, 212, 255, 0.15);

        }


        .menu-icon {

            width: 30px;

            height: 30px;

            display: flex;

            align-items: center;

            justify-content: center;

            border-radius: 8px;

            background: rgba(255,255,255,0.04);

            font-size: 16px;

            flex-shrink: 0;

        }


        .menu a.activo .menu-icon {

            background: rgba(0, 212, 255, 0.12);

        }


        /* ==================================
           PRÓXIMAMENTE
        ================================== */

        .proximamente {

            margin-left: auto;

            font-size: 9px;

            color: #52677d;

            background: #101f2e;

            padding: 4px 6px;

            border-radius: 5px;

        }


        /* ==================================
           USUARIO SIDEBAR
        ================================== */

        .sidebar-bottom {

            margin-top: auto;

            border-top: 1px solid #1a3046;

            padding-top: 18px;

        }


        .user-mini {

            display: flex;

            align-items: center;

            gap: 11px;

            padding: 10px;

            margin-bottom: 12px;

        }


        .avatar {

            width: 38px;

            height: 38px;

            border-radius: 50%;

            background: linear-gradient(
                135deg,
                #00d4ff,
                #0066ff
            );

            color: #07111f;

            display: flex;

            align-items: center;

            justify-content: center;

            font-weight: bold;

            font-size: 14px;

        }


        .user-info {

            overflow: hidden;

        }


        .user-info strong {

            display: block;

            font-size: 13px;

            white-space: nowrap;

            overflow: hidden;

            text-overflow: ellipsis;

        }


        .user-info span {

            display: block;

            color: #60768c;

            font-size: 11px;

            margin-top: 3px;

        }


        .logout {

            display: flex;

            align-items: center;

            justify-content: center;

            gap: 8px;

            width: 100%;

            padding: 11px;

            border: 1px solid #263b50;

            border-radius: 9px;

            color: #9cafc1;

            text-decoration: none;

            font-size: 13px;

            transition: 0.25s;

        }


        .logout:hover {

            border-color: #ff5c6c;

            color: #ff7c88;

            background: rgba(255, 92, 108, 0.06);

        }


        /* ==================================
           CONTENIDO
        ================================== */

        .main {

            margin-left: 260px;

            width: calc(100% - 260px);

            padding: 35px 45px;

        }


        /* ==================================
           HEADER
        ================================== */

        .top-header {

            display: flex;

            align-items: center;

            justify-content: space-between;

            margin-bottom: 35px;

        }


        .welcome h1 {

            font-size: 30px;

            margin-bottom: 8px;

        }


        .welcome h1 span {

            color: #00d4ff;

        }


        .welcome p {

            color: #708398;

            font-size: 14px;

        }


        .date-box {

            padding: 11px 16px;

            background: #0c1a2b;

            border: 1px solid #1b3047;

            border-radius: 10px;

            color: #91a4b9;

            font-size: 12px;

        }


        /* ==================================
           TARJETA BIENVENIDA
        ================================== */

        .hero-card {

            background:
                linear-gradient(
                    120deg,
                    rgba(0, 212, 255, 0.12),
                    rgba(0, 102, 255, 0.04)
                );

            border: 1px solid #1b3b53;

            border-radius: 18px;

            padding: 28px 30px;

            margin-bottom: 35px;

            position: relative;

            overflow: hidden;

        }


        .hero-card::after {

            content: "📱";

            position: absolute;

            right: 40px;

            top: 50%;

            transform: translateY(-50%);

            font-size: 90px;

            opacity: 0.07;

        }


        .hero-card h2 {

            font-size: 22px;

            margin-bottom: 8px;

        }


        .hero-card p {

            color: #91a4b9;

            font-size: 14px;

            line-height: 1.6;

            max-width: 650px;

        }


        /* ==================================
           ESTADÍSTICAS
        ================================== */

        .stats {

            display: grid;

            grid-template-columns:
                repeat(4, 1fr);

            gap: 18px;

            margin-bottom: 38px;

        }


        .stat-card {

            background: #0c1a2b;

            border: 1px solid #1b3047;

            border-radius: 15px;

            padding: 20px;

            transition: 0.25s;

        }


        .stat-card:hover {

            transform: translateY(-3px);

            border-color: #29465f;

        }


        .stat-top {

            display: flex;

            justify-content: space-between;

            align-items: center;

            margin-bottom: 17px;

        }


        .stat-icon {

            width: 40px;

            height: 40px;

            display: flex;

            align-items: center;

            justify-content: center;

            border-radius: 10px;

            background: rgba(0, 212, 255, 0.08);

            font-size: 19px;

        }


        .stat-label {

            color: #71869b;

            font-size: 12px;

        }


        .stat-number {

            font-size: 27px;

            font-weight: bold;

        }


        /* ==================================
           SECCIÓN MÓDULOS
        ================================== */

        .section-header {

            display: flex;

            align-items: center;

            justify-content: space-between;

            margin-bottom: 18px;

        }


        .section-header h2 {

            font-size: 20px;

        }


        .section-header p {

            color: #60768c;

            font-size: 12px;

        }


        .modules {

            display: grid;

            grid-template-columns:
                repeat(4, 1fr);

            gap: 18px;

        }


        .module {

            background: #0c1a2b;

            border: 1px solid #1b3047;

            border-radius: 15px;

            padding: 23px;

            text-decoration: none;

            color: white;

            transition: 0.3s;

            min-height: 160px;

            display: flex;

            flex-direction: column;

        }


        .module:hover {

            transform: translateY(-5px);

            border-color: #00d4ff;

            box-shadow:
                0 15px 35px rgba(0, 0, 0, 0.18);

        }


        .module-icon {

            width: 45px;

            height: 45px;

            border-radius: 12px;

            background: rgba(0, 212, 255, 0.09);

            display: flex;

            align-items: center;

            justify-content: center;

            font-size: 21px;

            margin-bottom: 17px;

        }


        .module h3 {

            font-size: 15px;

            margin-bottom: 7px;

        }


        .module p {

            color: #6f8499;

            font-size: 11px;

            line-height: 1.5;

            margin-top: auto;

        }


        .module.disabled {

            opacity: 0.62;

            cursor: default;

        }


        .module.disabled:hover {

            transform: none;

            border-color: #1b3047;

            box-shadow: none;

        }


        /* ==================================
           RESPONSIVE
        ================================== */

        @media (max-width: 1100px) {

            .stats {

                grid-template-columns:
                    repeat(2, 1fr);

            }


            .modules {

                grid-template-columns:
                    repeat(2, 1fr);

            }

        }


        @media (max-width: 800px) {

            .sidebar {

                width: 75px;

                padding: 20px 10px;

            }


            .brand-text,

            .menu-title,

            .menu a span:not(.menu-icon),

            .proximamente,

            .user-info,

            .logout {

                display: none;

            }


            .brand {

                justify-content: center;

                padding-left: 0;

                padding-right: 0;

            }


            .brand img {

                width: 45px;

                height: 45px;

            }


            .menu a {

                justify-content: center;

                padding: 10px;

            }


            .menu-icon {

                margin: 0;

            }


            .user-mini {

                justify-content: center;

                padding: 5px;

            }


            .main {

                margin-left: 75px;

                width: calc(100% - 75px);

                padding: 25px;

            }


            .date-box {

                display: none;

            }

        }


        @media (max-width: 600px) {

            .top-header {

                display: block;

            }


            .welcome h1 {

                font-size: 25px;

            }


            .stats,

            .modules {

                grid-template-columns: 1fr;

            }


            .hero-card {

                padding: 22px;

            }


            .hero-card::after {

                display: none;

            }

        }

    </style>

</head>


<body>


<div class="layout">


    <!-- ==================================
         BARRA LATERAL
    ================================== -->

    <aside class="sidebar">


        <div class="brand">

            <img
                src="<%= request.getContextPath() %>/img/logo.jpg"
                alt="Rescate Móvil">

            <div class="brand-text">
                Rescate <span>Móvil</span>
            </div>

        </div>


        <div class="menu-title">
            Menú principal
        </div>


        <nav class="menu">


            <a
                href="<%= request.getContextPath() %>/admin/index.jsp"
                class="activo">

                <span class="menu-icon">
                    🏠
                </span>

                <span>
                    Inicio
                </span>

            </a>


            <a
                href="<%= request.getContextPath() %>/admin/usuarios">

                <span class="menu-icon">
                    👥
                </span>

                <span>
                    Gestión de usuarios
                </span>

            </a>


            <a href="javascript:void(0)"
               class="disabled">

                <span class="menu-icon">
                    👤
                </span>

                <span>
                    Clientes
                </span>

                <small class="proximamente">
                    Próximo
                </small>

            </a>


            <a href="javascript:void(0)"
               class="disabled">

                <span class="menu-icon">
                    🛠️
                </span>

                <span>
                    Técnicos
                </span>

                <small class="proximamente">
                    Próximo
                </small>

            </a>


            <a href="javascript:void(0)"
               class="disabled">

                <span class="menu-icon">
                    📦
                </span>

                <span>
                    Productos
                </span>

                <small class="proximamente">
                    Próximo
                </small>

            </a>


            <a href="javascript:void(0)"
               class="disabled">

                <span class="menu-icon">
                    🔧
                </span>

                <span>
                    Reparaciones
                </span>

                <small class="proximamente">
                    Próximo
                </small>

            </a>


            <a href="javascript:void(0)"
               class="disabled">

                <span class="menu-icon">
                    💰
                </span>

                <span>
                    Ventas
                </span>

                <small class="proximamente">
                    Próximo
                </small>

            </a>


            <a href="javascript:void(0)"
               class="disabled">

                <span class="menu-icon">
                    🔔
                </span>

                <span>
                    Notificaciones
                </span>

                <small class="proximamente">
                    Próximo
                </small>

            </a>


            <a href="javascript:void(0)"
               class="disabled">

                <span class="menu-icon">
                    📊
                </span>

                <span>
                    Reportes
                </span>

                <small class="proximamente">
                    Próximo
                </small>

            </a>


        </nav>


        <!-- USUARIO -->

        <div class="sidebar-bottom">


            <div class="user-mini">

                <div class="avatar">

                    <%
                        String nombreUsuario = usuario != null
                                ? usuario.trim()
                                : "AD";

                        String iniciales = "";

                        String[] partes =
                                nombreUsuario.split("\\s+");

                        if (partes.length >= 2) {

                            iniciales =
                                    partes[0].substring(0, 1).toUpperCase()
                                    +
                                    partes[1].substring(0, 1).toUpperCase();

                        } else if (!nombreUsuario.isEmpty()) {

                            iniciales =
                                    nombreUsuario.substring(0, 1).toUpperCase();

                        } else {

                            iniciales = "AD";

                        }
                    %>

                    <%= iniciales %>

                </div>


                <div class="user-info">

                    <strong>
                        <%= usuario %>
                    </strong>

                    <span>
                        Administrador
                    </span>

                </div>

            </div>


            <a
                href="<%= request.getContextPath() %>/login.jsp?mensaje=logout"
                class="logout">

                🚪

                Cerrar sesión

            </a>


        </div>


    </aside>


    <!-- ==================================
         CONTENIDO PRINCIPAL
    ================================== -->

    <main class="main">


        <!-- HEADER -->

        <header class="top-header">


            <div class="welcome">

                <h1>
                    Panel de <span>Administrador</span>
                </h1>

                <p>
                    Gestiona y supervisa Rescate Móvil desde un solo lugar.
                </p>

            </div>


            <div class="date-box">

                🛡️ Sesión de administrador

            </div>


        </header>


        <!-- ==================================
             BIENVENIDA
        ================================== -->

        <section class="hero-card">

            <h2>
                ¡Bienvenido, <%= usuario %>! 👋
            </h2>

            <p>
                Desde este panel puedes administrar los diferentes
                componentes de la plataforma Rescate Móvil.
                Selecciona un módulo para comenzar a trabajar.
            </p>

        </section>


        <!-- ==================================
             ESTADÍSTICAS
        ================================== -->

        <section class="stats">


            <div class="stat-card">

                <div class="stat-top">

                    <div class="stat-icon">
                        👥
                    </div>

                    <span class="stat-label">
                        Usuarios
                    </span>

                </div>

                <div class="stat-number">
                    —
                </div>

            </div>


            <div class="stat-card">

                <div class="stat-top">

                    <div class="stat-icon">
                        👤
                    </div>

                    <span class="stat-label">
                        Clientes
                    </span>

                </div>

                <div class="stat-number">
                    —
                </div>

            </div>


            <div class="stat-card">

                <div class="stat-top">

                    <div class="stat-icon">
                        🔧
                    </div>

                    <span class="stat-label">
                        Reparaciones
                    </span>

                </div>

                <div class="stat-number">
                    —
                </div>

            </div>


            <div class="stat-card">

                <div class="stat-top">

                    <div class="stat-icon">
                        💰
                    </div>

                    <span class="stat-label">
                        Ventas
                    </span>

                </div>

                <div class="stat-number">
                    —
                </div>

            </div>


        </section>


        <!-- ==================================
             MÓDULOS
        ================================== -->

        <div class="section-header">

            <div>

                <h2>
                    Módulos del sistema
                </h2>

                <p>
                    Selecciona una opción para continuar
                </p>

            </div>

        </div>


        <section class="modules">


            <!-- USUARIOS -->

            <a
                href="<%= request.getContextPath() %>/admin/usuarios"
                class="module">

                <div class="module-icon">
                    👥
                </div>

                <h3>
                    Gestión de usuarios
                </h3>

                <p>
                    Crear, consultar y administrar
                    los usuarios del sistema.
                </p>

            </a>


            <!-- CLIENTES -->

            <div class="module disabled">

                <div class="module-icon">
                    👤
                </div>

                <h3>
                    Gestión de clientes
                </h3>

                <p>
                    Administración de información
                    de los clientes.
                </p>

            </div>


            <!-- TÉCNICOS -->

            <div class="module disabled">

                <div class="module-icon">
                    🛠️
                </div>

                <h3>
                    Gestión de técnicos
                </h3>

                <p>
                    Administración del personal técnico.
                </p>

            </div>


            <!-- PRODUCTOS -->

            <div class="module disabled">

                <div class="module-icon">
                    📦
                </div>

                <h3>
                    Gestión de productos
                </h3>

                <p>
                    Control y administración del inventario.
                </p>

            </div>


            <!-- REPARACIONES -->

            <div class="module disabled">

                <div class="module-icon">
                    🔧
                </div>

                <h3>
                    Gestión de reparaciones
                </h3>

                <p>
                    Seguimiento de servicios técnicos.
                </p>

            </div>


            <!-- VENTAS -->

            <div class="module disabled">

                <div class="module-icon">
                    💰
                </div>

                <h3>
                    Gestión de ventas
                </h3>

                <p>
                    Administración de ventas y operaciones.
                </p>

            </div>


            <!-- NOTIFICACIONES -->

            <div class="module disabled">

                <div class="module-icon">
                    🔔
                </div>

                <h3>
                    Notificaciones
                </h3>

                <p>
                    Avisos y comunicaciones del sistema.
                </p>

            </div>


            <!-- REPORTES -->

            <div class="module disabled">

                <div class="module-icon">
                    📊
                </div>

                <h3>
                    Reportes
                </h3>

                <p>
                    Información y estadísticas del sistema.
                </p>

            </div>


        </section>


    </main>

</div>


</body>

</html>