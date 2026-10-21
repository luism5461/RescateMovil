
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

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

    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nuevo usuario | Rescate Móvil</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: "Segoe UI", Arial, sans-serif;
            background:
                radial-gradient(circle at top right, rgba(230,57,70,.16), transparent 30%),
                radial-gradient(circle at bottom left, rgba(255,183,3,.08), transparent 30%),
                #080b12;
            color: #fff;
            min-height: 100vh;
        }

        .sidebar {
            position: fixed;
            left: 0;
            top: 0;
            width: 260px;
            height: 100vh;
            background: rgba(13,17,27,.97);
            border-right: 1px solid rgba(255,255,255,.08);
            padding: 25px 18px;
            z-index: 100;
            overflow-y: auto;
        }

        .logo-area {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 5px 10px 28px;
            border-bottom: 1px solid rgba(255,255,255,.08);
            margin-bottom: 22px;
        }

        .logo-area img {
            width: 48px;
            height: 48px;
            object-fit: contain;
            border-radius: 12px;
        }

        .logo-text h2 {
            font-size: 18px;
        }

        .logo-text span {
            color: #8f98aa;
            font-size: 12px;
        }

        .menu-title {
            color: #687386;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 1.5px;
            padding: 0 12px 10px;
            text-transform: uppercase;
        }

        .menu {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .menu a {
            text-decoration: none;
            color: #aab2c0;
            display: flex;
            align-items: center;
            gap: 13px;
            padding: 13px 14px;
            border-radius: 10px;
            font-size: 14px;
            transition: .25s;
        }

        .menu a:hover {
            background: rgba(255,255,255,.06);
            color: white;
            transform: translateX(3px);
        }

        .menu a.active {
            background: linear-gradient(135deg, rgba(230,57,70,.20), rgba(230,57,70,.08));
            color: white;
            border: 1px solid rgba(230,57,70,.25);
        }

        .menu-icon {
            width: 22px;
            text-align: center;
            font-size: 17px;
        }

        .user-box {
            position: absolute;
            bottom: 20px;
            left: 18px;
            right: 18px;
            padding: 14px;
            background: rgba(255,255,255,.04);
            border: 1px solid rgba(255,255,255,.07);
            border-radius: 12px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 12px;
        }

        .avatar {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            background: linear-gradient(135deg, #e63946, #ff8800);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }

        .user-name {
            font-size: 13px;
            font-weight: 600;
        }

        .user-role {
            font-size: 11px;
            color: #8992a3;
            margin-top: 2px;
        }

        .logout {
            display: block;
            text-align: center;
            text-decoration: none;
            color: #ff7b86;
            border: 1px solid rgba(230,57,70,.2);
            padding: 8px;
            border-radius: 8px;
            font-size: 12px;
            transition: .2s;
        }

        .logout:hover {
            background: rgba(230,57,70,.12);
        }

        .main {
            margin-left: 260px;
            min-height: 100vh;
            padding: 35px 45px;
        }

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            margin-bottom: 30px;
        }

        .breadcrumb {
            color: #707a8c;
            font-size: 13px;
            margin-bottom: 8px;
        }

        .breadcrumb span {
            color: #e63946;
        }

        .title-area h1 {
            font-size: 31px;
            margin-bottom: 7px;
        }

        .title-area p {
            color: #8f98aa;
            font-size: 14px;
        }

        .back-button {
            text-decoration: none;
            color: #c5cbd5;
            border: 1px solid rgba(255,255,255,.1);
            padding: 11px 18px;
            border-radius: 10px;
            font-size: 13px;
            white-space: nowrap;
            transition: .25s;
        }

        .back-button:hover {
            background: rgba(255,255,255,.06);
            color: white;
        }

        .form-container {
            max-width: 950px;
            margin: auto;
        }

        .form-card {
            background: rgba(17,22,34,.90);
            border: 1px solid rgba(255,255,255,.08);
            border-radius: 18px;
            padding: 32px;
            box-shadow: 0 25px 60px rgba(0,0,0,.35);
        }

        .form-header {
            display: flex;
            align-items: center;
            gap: 18px;
            padding-bottom: 25px;
            margin-bottom: 28px;
            border-bottom: 1px solid rgba(255,255,255,.08);
        }

        .form-icon {
            width: 58px;
            height: 58px;
            flex-shrink: 0;
            border-radius: 15px;
            background: linear-gradient(135deg, rgba(230,57,70,.22), rgba(255,136,0,.12));
            border: 1px solid rgba(230,57,70,.25);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 27px;
        }

        .form-header h2 {
            font-size: 21px;
            margin-bottom: 5px;
        }

        .form-header p {
            color: #818b9c;
            font-size: 13px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 22px;
        }

        .field {
            display: flex;
            flex-direction: column;
            gap: 8px;
            min-width: 0;
        }

        .field.full {
            grid-column: 1 / -1;
        }

        .field label {
            font-size: 13px;
            color: #c5ccd7;
            font-weight: 600;
        }

        .required {
            color: #e63946;
        }

        .field input,
        .field select {
            width: 100%;
            height: 48px;
            padding: 0 15px;
            border-radius: 10px;
            border: 1px solid rgba(255,255,255,.10);
            background: #0c111c;
            color: #fff;
            outline: none;
            font-size: 13px;
            transition: .25s;
        }

        .field input::placeholder {
            color: #5e6878;
        }

        .field input:focus,
        .field select:focus {
            border-color: #e63946;
            box-shadow: 0 0 0 3px rgba(230,57,70,.10);
        }

        .field input:invalid:not(:placeholder-shown) {
            border-color: rgba(230,57,70,.65);
        }

        .field select option {
            background: #101622;
            color: white;
        }

        .input-icon {
            position: relative;
        }

        .input-icon span {
            position: absolute;
            right: 15px;
            top: 14px;
            color: #626d7f;
            font-size: 17px;
            pointer-events: none;
        }

        .input-icon input {
            padding-right: 45px;
        }

        .help {
            color: #8f98aa;
            font-size: 11px;
            line-height: 1.5;
        }

        .alert {
            margin-bottom: 22px;
            padding: 14px 16px;
            border-radius: 10px;
            font-size: 13px;
            line-height: 1.6;
            border: 1px solid rgba(230,57,70,.25);
            background: rgba(230,57,70,.10);
            color: #ffb2b8;
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 32px;
            padding-top: 25px;
            border-top: 1px solid rgba(255,255,255,.08);
        }

        .btn {
            border: none;
            text-decoration: none;
            padding: 13px 23px;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: .25s;
        }

        .btn-cancel {
            background: rgba(255,255,255,.05);
            color: #aeb6c4;
            border: 1px solid rgba(255,255,255,.09);
        }

        .btn-cancel:hover {
            background: rgba(255,255,255,.09);
            color: white;
        }

        .btn-save {
            background: linear-gradient(135deg, #e63946, #d62839);
            color: white;
            box-shadow: 0 8px 25px rgba(230,57,70,.25);
        }

        .btn-save:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 30px rgba(230,57,70,.35);
        }

        @media (max-width: 1000px) {
            .sidebar {
                width: 220px;
            }

            .main {
                margin-left: 220px;
                padding: 25px;
            }
        }

        @media (max-width: 800px) {
            .top-bar {
                align-items: flex-start;
                flex-direction: column;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .field.full {
                grid-column: auto;
            }
        }

        @media (max-width: 700px) {
            .sidebar {
                position: relative;
                width: 100%;
                height: auto;
                overflow: visible;
            }

            .user-box {
                position: relative;
                left: auto;
                right: auto;
                bottom: auto;
                margin-top: 20px;
            }

            .main {
                margin-left: 0;
                padding: 22px;
            }

            .form-card {
                padding: 22px;
            }

            .form-actions {
                flex-direction: column-reverse;
            }

            .btn {
                width: 100%;
                text-align: center;
            }

            .title-area h1 {
                font-size: 26px;
            }
        }
    </style>
</head>

<body>

<aside class="sidebar">
    <div class="logo-area">
        <img
            src="<%= request.getContextPath() %>/img/logo.jpg"
            alt="Logo Rescate Móvil">

        <div class="logo-text">
            <h2>Rescate Móvil</h2>
            <span>Panel administrativo</span>
        </div>
    </div>

    <div class="menu-title">Menú principal</div>

    <nav class="menu">
        <a href="<%= request.getContextPath() %>/admin/index.jsp">
            <span class="menu-icon">⌂</span> Inicio
        </a>

        <a class="active" href="<%= request.getContextPath() %>/admin/usuarios">
            <span class="menu-icon">👥</span> Gestión de usuarios
        </a>

        <a href="<%= request.getContextPath() %>/admin/clientes.jsp">
            <span class="menu-icon">👤</span> Clientes
        </a>

        <a href="#">
            <span class="menu-icon">🔧</span> Técnicos
        </a>

        <a href="#">
            <span class="menu-icon">📦</span> Productos
        </a>

        <a href="#">
            <span class="menu-icon">🛠️</span> Reparaciones
        </a>

        <a href="#">
            <span class="menu-icon">💰</span> Ventas
        </a>

        <a href="#">
            <span class="menu-icon">🔔</span> Notificaciones
        </a>

        <a href="#">
            <span class="menu-icon">📊</span> Reportes
        </a>
    </nav>

    <div class="user-box">
        <div class="user-info">
            <div class="avatar">
                <%= usuarioSesion.substring(0, 1).toUpperCase() %>
            </div>

            <div>
                <div class="user-name"><%= usuarioSesion %></div>
                <div class="user-role">Administrador</div>
            </div>
        </div>

        <a class="logout"
           href="<%= request.getContextPath() %>/login.jsp?mensaje=logout">
            Cerrar sesión
        </a>
    </div>
</aside>

<main class="main">

    <div class="top-bar">
        <div class="title-area">
            <div class="breadcrumb">
                Panel de administrador
                <span>/</span> Gestión de usuarios
                <span>/</span> Nuevo usuario
            </div>

            <h1>Crear nuevo usuario</h1>

            <p>Registra un nuevo usuario para acceder al sistema.</p>
        </div>

        <a class="back-button"
           href="<%= request.getContextPath() %>/admin/usuarios">
            ← Volver a usuarios
        </a>
    </div>

    <div class="form-container">
        <div class="form-card">

            <div class="form-header">
                <div class="form-icon">👤+</div>

                <div>
                    <h2>Información del usuario</h2>
                    <p>Completa los datos necesarios para registrar el nuevo usuario.</p>
                </div>
            </div>

            <% if ("datos".equals(error)) { %>
                <div class="alert" role="alert">
                    ⚠️ Completa todos los campos obligatorios.
                </div>
            <% } else if ("usuario".equals(error)) { %>
                <div class="alert" role="alert">
                    ⚠️ Ese nombre de usuario ya está registrado.
                    Elige otro nombre de usuario.
                </div>
            <% } else if ("correo".equals(error)) { %>
                <div class="alert" role="alert">
                    ⚠️ Ese correo electrónico ya está registrado.
                    Utiliza otra dirección de correo.
                </div>
            <% } else if ("formatoCorreo".equals(error)) { %>
                <div class="alert" role="alert">
                    ⚠️ El correo electrónico no tiene un formato válido.
                    Ejemplo: usuario@ejemplo.com.
                </div>
            <% } else if ("password".equals(error)) { %>
                <div class="alert" role="alert">
                    ⚠️ La contraseña debe tener al menos 8 caracteres.
                </div>
            <% } else if ("rol".equals(error)) { %>
                <div class="alert" role="alert">
                    ⚠️ Selecciona un rol válido.
                </div>
            <% } else if ("registro".equals(error)) { %>
                <div class="alert" role="alert">
                    ⚠️ No fue posible registrar el usuario.
                    Comprueba los datos e inténtalo nuevamente.
                </div>
            <% } %>

            <form
                action="<%= request.getContextPath() %>/admin/usuarios"
                method="post">

                <div class="form-grid">

                    <div class="field full">
                        <label for="nombre">
                            Nombre completo <span class="required">*</span>
                        </label>

                        <div class="input-icon">
                            <input
                                type="text"
                                id="nombre"
                                name="nombre"
                                placeholder="Ej. Carlos Pérez"
                                minlength="2"
                                maxlength="100"
                                autocomplete="name"
                                required>
                            <span>👤</span>
                        </div>
                    </div>

                    <div class="field">
                        <label for="usuario">
                            Nombre de usuario <span class="required">*</span>
                        </label>

                        <div class="input-icon">
                            <input
                                type="text"
                                id="usuario"
                                name="usuario"
                                placeholder="Ej. carlos.perez"
                                minlength="3"
                                maxlength="50"
                                pattern="[A-Za-z0-9._-]+"
                                title="Usa letras, números, puntos, guiones o guiones bajos."
                                autocomplete="username"
                                required>
                            <span>@</span>
                        </div>

                        <span class="help">
                            Mínimo 3 caracteres. Puedes usar letras, números, puntos,
                            guiones y guiones bajos.
                        </span>
                    </div>

                    <div class="field">
                        <label for="correo">
                            Correo electrónico <span class="required">*</span>
                        </label>

                        <div class="input-icon">
                            <input
                                type="email"
                                id="correo"
                                name="correo"
                                placeholder="correo@ejemplo.com"
                                maxlength="150"
                                autocomplete="email"
                                required>
                            <span>✉</span>
                        </div>
                    </div>

                    <div class="field">
                        <label for="telefono">Teléfono</label>

                        <div class="input-icon">
                            <input
                                type="tel"
                                id="telefono"
                                name="telefono"
                                placeholder="Ej. 3001234567"
                                maxlength="20"
                                pattern="[0-9+() -]{7,20}"
                                title="Introduce un teléfono válido."
                                autocomplete="tel">
                            <span>☎</span>
                        </div>
                    </div>

                    <div class="field">
                        <label for="password">
                            Contraseña <span class="required">*</span>
                        </label>

                        <div class="input-icon">
                            <input
                                type="password"
                                id="password"
                                name="password"
                                placeholder="Ingresa una contraseña"
                                minlength="8"
                                maxlength="100"
                                autocomplete="new-password"
                                required>
                            <span>🔒</span>
                        </div>

                        <span class="help">
                            La contraseña debe tener al menos 8 caracteres.
                        </span>
                    </div>

                    <div class="field">
                        <label for="rol">
                            Rol del usuario <span class="required">*</span>
                        </label>

                        <select id="rol" name="rol" required>
                            <option value="">Selecciona un rol</option>
                            <option value="admin">Administrador</option>
                            <option value="tecnico">Técnico</option>
                            <option value="cliente">Cliente</option>
                        </select>
                    </div>

                    <div class="field">
                        <label for="activo">Estado de la cuenta</label>

                        <select id="activo" name="activo">
                            <option value="1" selected>Activo</option>
                            <option value="0">Inactivo</option>
                        </select>
                    </div>

                </div>

                <div class="form-actions">
                    <a
                        class="btn btn-cancel"
                        href="<%= request.getContextPath() %>/admin/usuarios">
                        Cancelar
                    </a>

                    <button type="submit" class="btn btn-save">
                        ✓ Crear usuario
                    </button>
                </div>
            </form>
        </div>
    </div>
</main>

</body>
</html>