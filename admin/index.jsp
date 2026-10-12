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

    String ctx = request.getContextPath();
    String nombreUsuario = usuario.trim();
    String iniciales = nombreUsuario.isEmpty()
            ? "AD"
            : nombreUsuario.substring(0, 1).toUpperCase();

    String[] partes = nombreUsuario.split("\\s+");
    if (partes.length >= 2) {
        iniciales = partes[0].substring(0, 1).toUpperCase()
                + partes[1].substring(0, 1).toUpperCase();
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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

        a {
            -webkit-tap-highlight-color: transparent;
        }

        .layout {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 260px;
            background: #081522;
            border-right: 1px solid #1a3046;
            padding: 25px 18px;
            position: fixed;
            inset: 0 auto 0 0;
            display: flex;
            flex-direction: column;
            z-index: 100;
            overflow-y: auto;
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

        .brand-text span,
        .welcome h1 span {
            color: #00d4ff;
        }

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
            padding: 11px 12px;
            border-radius: 10px;
            color: #9cafc1;
            text-decoration: none;
            font-size: 13px;
            transition: 0.25s;
        }

        .menu a:hover,
        .menu a.activo {
            background: rgba(0, 212, 255, 0.09);
            color: #00d4ff;
        }

        .menu a.activo {
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

        .proximamente {
            margin-left: auto;
            font-size: 9px;
            color: #8b9caf;
            background: #101f2e;
            padding: 4px 6px;
            border-radius: 5px;
        }

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
            background: linear-gradient(135deg, #00d4ff, #0066ff);
            color: #07111f;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 14px;
            flex-shrink: 0;
        }

        .user-info {
            overflow: hidden;
        }

        .user-info strong {
            display: block;
            font-size: 13px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
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

        .main {
            margin-left: 260px;
            width: calc(100% - 260px);
            padding: 35px 40px;
        }

        .top-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 30px;
            gap: 15px;
        }

        .welcome h1 {
            font-size: 29px;
            margin-bottom: 8px;
        }

        .welcome p {
            color: #708398;
            font-size: 14px;
            line-height: 1.5;
        }

        .date-box {
            padding: 11px 16px;
            background: #0c1a2b;
            border: 1px solid #1b3047;
            border-radius: 10px;
            color: #91a4b9;
            font-size: 12px;
            white-space: nowrap;
        }

        .hero-card {
            background: linear-gradient(
                120deg,
                rgba(0, 212, 255, 0.12),
                rgba(0, 102, 255, 0.04)
            );
            border: 1px solid #1b3b53;
            border-radius: 18px;
            padding: 28px 30px;
            margin-bottom: 30px;
            position: relative;
            overflow: hidden;
        }

        .hero-card::after {
            content: "📱";
            position: absolute;
            right: 40px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 85px;
            opacity: 0.07;
        }

        .hero-card h2 {
            font-size: 22px;
            margin-bottom: 8px;
        }

        .hero-card p {
            color: #91a4b9;
            font-size: 14px;
            line-height: 1.7;
            max-width: 650px;
        }

        .stats {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 16px;
            margin-bottom: 35px;
        }

        .stat-card {
            background: #0c1a2b;
            border: 1px solid #1b3047;
            border-radius: 15px;
            padding: 19px;
        }

        .stat-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            gap: 8px;
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
            color: #91a4b9;
            font-size: 12px;
        }

        .stat-number {
            font-size: 25px;
            font-weight: bold;
            color: #00d4ff;
        }

        .section-header {
            margin-bottom: 18px;
        }

        .section-header h2 {
            font-size: 20px;
            margin-bottom: 6px;
        }

        .section-header p {
            color: #60768c;
            font-size: 12px;
        }

        .modules {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 18px;
        }

        .module {
            background: #0c1a2b;
            border: 1px solid #1b3047;
            border-radius: 15px;
            padding: 22px;
            text-decoration: none;
            color: white;
            transition: 0.25s;
            min-height: 165px;
            display: flex;
            flex-direction: column;
        }

        .module:hover {
            transform: translateY(-4px);
            border-color: #00d4ff;
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.18);
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
            margin-bottom: 16px;
        }

        .module h3 {
            font-size: 15px;
            margin-bottom: 8px;
        }

        .module p {
            color: #91a4b9;
            font-size: 12px;
            line-height: 1.6;
            margin-top: auto;
        }

        .module.disabled {
            opacity: 0.62;
            cursor: not-allowed;
        }

        @media (max-width: 1200px) {
            .modules {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .stats {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .main {
                padding: 30px 25px;
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

            .user-mini {
                justify-content: center;
                padding: 5px;
            }

            .main {
                margin-left: 75px;
                width: calc(100% - 75px);
                padding: 25px 18px;
            }

            .date-box {
                display: none;
            }
        }

        @media (max-width: 550px) {
            .top-header {
                display: block;
            }

            .welcome h1 {
                font-size: 24px;
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

    <aside class="sidebar">
        <div class="brand">
            <img src="<%= ctx %>/img/logo.jpg" alt="Logo Rescate Móvil">
            <div class="brand-text">Rescate <span>Móvil</span></div>
        </div>

        <div class="menu-title">Menú principal</div>

        <nav class="menu">
            <a href="<%= ctx %>/admin/index.jsp" class="activo">
                <span class="menu-icon">🏠</span>
                <span>Inicio</span>
            </a>

            <a href="<%= ctx %>/admin/usuarios">
                <span class="menu-icon">👥</span>
                <span>Gestión de usuarios</span>
            </a>

            <a href="<%= ctx %>/admin/clientes">
                <span class="menu-icon">👤</span>
                <span>Clientes</span>
            </a>

            <a href="<%= ctx %>/admin/tecnicos">
                <span class="menu-icon">🛠️</span>
                <span>Técnicos</span>
            </a>

            <a href="<%= ctx %>/admin/productos">
                <span class="menu-icon">📦</span>
                <span>Productos</span>
            </a>

            <a href="<%= ctx %>/admin/reparaciones">
                <span class="menu-icon">🔧</span>
                <span>Reparaciones</span>
            </a>

            <a href="<%= ctx %>/admin/ventas" title="Ventas">
                <span class="menu-icon">💰</span>
                <span>Ventas</span>
                <small class="proximamente">Próximo</small>
            </a>

            <a href="javascript:void(0)" class="disabled" aria-disabled="true">
                <span class="menu-icon">🔔</span>
                <span>Notificaciones</span>
                <small class="proximamente">Próximo</small>
            </a>

            <a href="javascript:void(0)" class="disabled" aria-disabled="true">
                <span class="menu-icon">📊</span>
                <span>Reportes</span>
                <small class="proximamente">Próximo</small>
            </a>
        </nav>

        <div class="sidebar-bottom">
            <div class="user-mini">
                <div class="avatar"><%= iniciales %></div>
                <div class="user-info">
                    <strong><%= usuario %></strong>
                    <span>Administrador</span>
                </div>
            </div>

            <a href="<%= ctx %>/login.jsp?mensaje=logout" class="logout">
                🚪 Cerrar sesión
            </a>
        </div>
    </aside>

    <main class="main">
        <header class="top-header">
            <div class="welcome">
                <h1>Panel de <span>Administrador</span></h1>
                <p>Gestiona y supervisa Rescate Móvil desde un solo lugar.</p>
            </div>
            <div class="date-box">🛡️ Sesión de administrador</div>
        </header>

        <section class="hero-card">
            <h2>¡Bienvenido, <%= usuario %>! 👋</h2>
            <p>
                Desde este panel puedes administrar los componentes de
                Rescate Móvil. Selecciona un módulo para comenzar a trabajar.
            </p>
        </section>

        <section class="stats">
            <div class="stat-card">
                <div class="stat-top">
                    <div class="stat-icon">👥</div>
                    <span class="stat-label">Usuarios</span>
                </div>
                <div class="stat-number">—</div>
            </div>

            <div class="stat-card">
                <div class="stat-top">
                    <div class="stat-icon">👤</div>
                    <span class="stat-label">Clientes</span>
                </div>
                <div class="stat-number">—</div>
            </div>

            <div class="stat-card">
                <div class="stat-top">
                    <div class="stat-icon">🔧</div>
                    <span class="stat-label">Reparaciones</span>
                </div>
                <div class="stat-number">—</div>
            </div>

            <div class="stat-card">
                <div class="stat-top">
                    <div class="stat-icon">💰</div>
                    <span class="stat-label">Ventas</span>
                </div>
                <div class="stat-number">—</div>
            </div>
        </section>

        <div class="section-header">
            <h2>Módulos del sistema</h2>
            <p>Selecciona una opción para continuar.</p>
        </div>

        <section class="modules">
            <a href="<%= ctx %>/admin/usuarios" class="module">
                <div class="module-icon">👥</div>
                <h3>Gestión de usuarios</h3>
                <p>Crear, consultar y administrar los usuarios del sistema.</p>
            </a>

            <a href="<%= ctx %>/admin/clientes" class="module">
                <div class="module-icon">👤</div>
                <h3>Gestión de clientes</h3>
                <p>Consultar, buscar, editar y administrar clientes.</p>
            </a>

            <a href="<%= ctx %>/admin/tecnicos" class="module">
                <div class="module-icon">🛠️</div>
                <h3>Gestión de técnicos</h3>
                <p>Administrar el personal técnico de la empresa.</p>
            </a>

            <a href="<%= ctx %>/admin/productos" class="module">
                <div class="module-icon">📦</div>
                <h3>Gestión de productos</h3>
                <p>Controlar productos e inventario.</p>
            </a>

            <a href="<%= ctx %>/admin/reparaciones" class="module">
                <div class="module-icon">🔧</div>
                <h3>Gestión de reparaciones</h3>
                <p>Registrar reparaciones y consultar su estado.</p>
            </a>

            <a href="<%= ctx %>/admin/ventas" class="module">
                <div class="module-icon">💰</div>
                <h3>Gestión de ventas</h3>
                <p>Acceder a la gestión de ventas.</p>
                <p style="color:#00d4ff;margin-top:10px;">Módulo por verificar</p>
            </a>

            <div class="module disabled">
                <div class="module-icon">🔔</div>
                <h3>Notificaciones</h3>
                <p>Avisos y comunicaciones del sistema.</p>
                <p style="margin-top:10px;">Próximamente</p>
            </div>

            <div class="module disabled">
                <div class="module-icon">📊</div>
                <h3>Reportes</h3>
                <p>Información y estadísticas del sistema.</p>
                <p style="margin-top:10px;">Próximamente</p>
            </div>
        </section>
    </main>
</div>
</body>
</html>