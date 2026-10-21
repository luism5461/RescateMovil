
<%--
    Documento : clientes.jsp
    Proyecto  : Rescate Móvil
    Función   : Gestión de clientes
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.rescatemovil.modelo.cliente" %>

<%
    String usuarioSesion = (String) session.getAttribute("usuario");
    String rolSesion = (String) session.getAttribute("rol");

    if (usuarioSesion == null || rolSesion == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    if (!"admin".equalsIgnoreCase(rolSesion)) {
        response.sendError(
            javax.servlet.http.HttpServletResponse.SC_FORBIDDEN,
            "No tienes permiso para acceder a esta página."
        );
        return;
    }

    List<cliente> clientes =
        (List<cliente>) request.getAttribute("clientes");

    if (clientes == null) {
        clientes = new ArrayList<cliente>();
    }

    int totalClientes = clientes.size();

    String mensaje = request.getParameter("mensaje");
    String error = request.getParameter("error");

    String contexto = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Gestión de Clientes | Rescate Móvil</title>

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

        .app {
            display: flex;
            min-height: 100vh;
        }

        /* MENÚ LATERAL */

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
            z-index: 10;
        }

        .logo-area {
            text-align: center;
            padding-bottom: 25px;
            border-bottom: 1px solid #1c354d;
            margin-bottom: 25px;
        }

        .logo {
            width: 70px;
            height: 70px;
            object-fit: contain;
            border-radius: 18px;
            margin-bottom: 12px;
        }

        .logo-area h2 {
            font-size: 18px;
            margin-bottom: 5px;
        }

        .logo-area p {
            color: #71869b;
            font-size: 12px;
        }

        .menu-title {
            color: #52677d;
            font-size: 11px;
            font-weight: bold;
            letter-spacing: 1px;
            margin: 0 12px 12px;
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
            background: rgba(0, 212, 255, 0.08);
            color: #00d4ff;
        }

        .menu a.activo {
            background: rgba(0, 212, 255, 0.12);
            color: #00d4ff;
            border: 1px solid rgba(0, 212, 255, 0.18);
        }

        .menu-icon {
            width: 28px;
            text-align: center;
            font-size: 17px;
        }

        /* CONTENIDO PRINCIPAL */

        .main {
            margin-left: 250px;
            width: calc(100% - 250px);
            padding: 30px;
            min-width: 0;
        }

        .topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            margin-bottom: 30px;
        }

        .topbar h1 {
            font-size: 30px;
            margin-bottom: 7px;
        }

        .topbar p {
            color: #71869b;
            font-size: 14px;
            line-height: 1.6;
        }

        .usuario-info {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 14px;
            background: #0a1727;
            border: 1px solid #1c354d;
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
            flex-shrink: 0;
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

        /* ESTADÍSTICAS */

        .estadisticas {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 18px;
            margin-bottom: 25px;
        }

        .card {
            background: #0a1727;
            border: 1px solid #1c354d;
            border-radius: 16px;
            padding: 22px;
        }

        .card-icon {
            width: 42px;
            height: 42px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(0, 212, 255, 0.10);
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
            overflow-wrap: anywhere;
        }

        /* PANEL DE CLIENTES */

        .panel {
            background: #0a1727;
            border: 1px solid #1c354d;
            border-radius: 18px;
            overflow: hidden;
        }

        .panel-header {
            padding: 22px 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            border-bottom: 1px solid #1c354d;
        }

        .panel-title h2 {
            font-size: 19px;
            margin-bottom: 5px;
        }

        .panel-title p {
            color: #71869b;
            font-size: 12px;
            line-height: 1.6;
        }

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
            padding: 11px 14px 11px 38px;
            background: #07111f;
            border: 1px solid #294158;
            border-radius: 10px;
            color: white;
            outline: none;
            font-size: 13px;
        }

        .buscador input:focus {
            border-color: #00d4ff;
        }

        .buscador input::placeholder {
            color: #71869b;
        }

        .buscador-icon {
            position: absolute;
            left: 13px;
            top: 50%;
            transform: translateY(-50%);
            color: #62758a;
            pointer-events: none;
        }

        .btn-nuevo {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            padding: 11px 16px;
            background: #00d4ff;
            color: #07111f;
            text-decoration: none;
            border: none;
            border-radius: 10px;
            font-size: 13px;
            font-weight: bold;
            cursor: pointer;
            white-space: nowrap;
            transition: background 0.2s;
        }

        .btn-nuevo:hover {
            background: #69e6ff;
        }

        /* MENSAJES */

        .mensaje {
            margin: 20px 25px 0;
            padding: 14px 16px;
            border-radius: 10px;
            font-size: 13px;
            line-height: 1.6;
        }

        .mensaje-exito {
            background: rgba(25, 135, 84, 0.15);
            border: 1px solid rgba(25, 135, 84, 0.5);
            color: #75e6aa;
        }

        .mensaje-error {
            background: rgba(220, 53, 69, 0.12);
            border: 1px solid rgba(220, 53, 69, 0.4);
            color: #ff9ba5;
        }

        /* TABLA */

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
            padding: 15px 18px;
            color: #71869b;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.7px;
            white-space: nowrap;
        }

        td {
            padding: 16px 18px;
            border-top: 1px solid #142a3f;
            font-size: 13px;
            color: #c8d5e2;
            vertical-align: middle;
        }

        tbody tr:hover {
            background: rgba(0, 212, 255, 0.035);
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
            background: rgba(0, 212, 255, 0.10);
            color: #00d4ff;
            font-weight: bold;
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

        .acciones-tabla {
            display: flex;
            align-items: center;
            gap: 7px;
        }

        .btn-accion {
            width: 34px;
            height: 34px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 9px;
            text-decoration: none;
            transition: 0.2s;
            font-family: Arial, Helvetica, sans-serif;
            font-size: 14px;
            cursor: pointer;
            padding: 0;
        }

        .btn-editar {
            background: rgba(0, 212, 255, 0.08);
            color: #00d4ff;
            border: 1px solid rgba(0, 212, 255, 0.15);
        }

        .btn-editar:hover {
            background: rgba(0, 212, 255, 0.16);
        }

        .btn-eliminar {
            background: rgba(220, 53, 69, 0.08);
            color: #ff7885;
            border: 1px solid rgba(220, 53, 69, 0.15);
        }

        .btn-eliminar:hover {
            background: rgba(220, 53, 69, 0.16);
        }

        .form-eliminar {
            display: inline;
            margin: 0;
        }

        /* ESTADO VACÍO */

        .sin-clientes {
            text-align: center;
            padding: 70px 20px;
        }

        .sin-clientes-icon {
            font-size: 45px;
            margin-bottom: 15px;
        }

        .sin-clientes h3 {
            font-size: 18px;
            margin-bottom: 8px;
        }

        .sin-clientes p {
            color: #71869b;
            font-size: 13px;
            margin: 12px 0 20px;
        }

        /* PIE DE PÁGINA */

        .footer {
            padding: 25px 5px 10px;
            text-align: center;
            color: #52677d;
            font-size: 11px;
            line-height: 1.8;
        }

        /* DISEÑO RESPONSIVE */

        @media (max-width: 1100px) {
            .estadisticas {
                grid-template-columns: repeat(2, minmax(0, 1fr));
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
                min-width: 0;
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
                width: calc(100% - 210px);
                padding: 20px;
            }

            .topbar {
                align-items: flex-start;
                flex-direction: column;
            }
        }

        @media (max-width: 600px) {
            .app {
                flex-direction: column;
            }

            .sidebar {
                position: relative;
                width: 100%;
                height: auto;
                max-height: none;
            }

            .main {
                margin-left: 0;
                width: 100%;
                padding: 15px;
            }

            .estadisticas {
                grid-template-columns: 1fr;
            }

            .acciones {
                align-items: stretch;
                flex-direction: column;
            }

            .buscador input {
                width: 100%;
            }

            .topbar h1 {
                font-size: 24px;
            }

            .panel-header {
                padding: 18px;
            }
        }
    </style>
</head>

<body>

<div class="app">

    <!-- MENÚ LATERAL -->

    <aside class="sidebar">

        <div class="logo-area">

            <img
                src="<%= contexto %>/img/logo.jpg"
                alt="Logo Rescate Móvil"
                class="logo">

            <h2>Rescate Móvil</h2>
            <p>Panel de administración</p>

        </div>

        <div class="menu-title">ADMINISTRACIÓN</div>

        <nav class="menu">

            <a href="<%= contexto %>/admin/index.jsp">
                <span class="menu-icon">⌂</span>
                <span>Dashboard</span>
            </a>

            <a href="<%= contexto %>/admin/usuarios">
                <span class="menu-icon">👤</span>
                <span>Gestión de usuarios</span>
            </a>

            <a href="<%= contexto %>/admin/clientes" class="activo">
                <span class="menu-icon">👥</span>
                <span>Gestión de clientes</span>
            </a>

            <a href="<%= contexto %>/admin/tecnicos">
                <span class="menu-icon">🔧</span>
                <span>Gestión de técnicos</span>
            </a>

            <a href="<%= contexto %>/admin/productos">
                <span class="menu-icon">📦</span>
                <span>Gestión de productos</span>
            </a>

            <a href="<%= contexto %>/admin/reparaciones">
                <span class="menu-icon">🛠️</span>
                <span>Gestión de reparaciones</span>
            </a>

            <a href="<%= contexto %>/admin/ventas">
                <span class="menu-icon">💰</span>
                <span>Gestión de ventas</span>
            </a>

            <a href="<%= contexto %>/admin/notificaciones">
                <span class="menu-icon">🔔</span>
                <span>Notificaciones</span>
            </a>

            <a href="<%= contexto %>/admin/reportes">
                <span class="menu-icon">📊</span>
                <span>Reportes</span>
            </a>

        </nav>

    </aside>

    <!-- CONTENIDO PRINCIPAL -->

    <main class="main">

        <header class="topbar">

            <div>
                <h1>Gestión de clientes</h1>

                <p>
                    Administra la información de los clientes
                    registrados en Rescate Móvil.
                </p>
            </div>

            <div class="usuario-info">

                <div class="usuario-avatar">
                    <%= usuarioSesion.trim().isEmpty()
                        ? "A"
                        : usuarioSesion.trim().substring(0, 1).toUpperCase() %>
                </div>

                <div class="usuario-texto">
                    <strong><%= usuarioSesion %></strong>
                    <span>ADMINISTRADOR</span>
                </div>

            </div>

        </header>

        <!-- MENSAJES DE RESULTADO -->

        <% if ("creado".equals(mensaje)) { %>
            <div class="mensaje mensaje-exito">
                El cliente se registró correctamente.
            </div>
        <% } else if ("eliminado".equals(mensaje)) { %>
            <div class="mensaje mensaje-exito">
                El cliente se eliminó correctamente.
            </div>
        <% } else if ("actualizado".equals(mensaje)) { %>
            <div class="mensaje mensaje-exito">
                Los datos del cliente se actualizaron correctamente.
            </div>
        <% } %>

        <% if ("eliminar".equals(error)) { %>
            <div class="mensaje mensaje-error">
                No fue posible eliminar el cliente. Puede estar relacionado
                con reparaciones o ventas, o puede haber ocurrido un error
                en la base de datos. Revisa la consola de Tomcat.
            </div>
        <% } else if ("id".equals(error)) { %>
            <div class="mensaje mensaje-error">
                El identificador del cliente no es válido.
            </div>
        <% } else if ("noencontrado".equals(error)) { %>
            <div class="mensaje mensaje-error">
                No se encontró el cliente solicitado.
            </div>
        <% } else if ("campos".equals(error)) { %>
            <div class="mensaje mensaje-error">
                Completa los campos obligatorios del formulario.
            </div>
        <% } else if ("correo".equals(error)) { %>
            <div class="mensaje mensaje-error">
                El correo electrónico no tiene un formato válido.
            </div>
        <% } else if ("actualizar".equals(error)) { %>
            <div class="mensaje mensaje-error">
                No fue posible actualizar el cliente.
            </div>
        <% } else if ("registrar".equals(error)) { %>
            <div class="mensaje mensaje-error">
                No fue posible registrar el cliente. Verifica los datos
                y revisa la consola de Tomcat para identificar el error.
            </div>
        <% } %>

        <!-- ESTADÍSTICAS -->

        <section class="estadisticas">

            <div class="card">
                <div class="card-icon">👥</div>
                <div class="card-label">TOTAL CLIENTES</div>
                <div class="card-value"><%= totalClientes %></div>
            </div>

            <div class="card">
                <div class="card-icon">📋</div>
                <div class="card-label">REGISTROS DISPONIBLES</div>
                <div class="card-value"><%= totalClientes %></div>
            </div>

            <div class="card">
                <div class="card-icon">📅</div>
                <div class="card-label">MÓDULO</div>
                <div class="card-value">CRM</div>
            </div>

        </section>

        <!-- TABLA DE CLIENTES -->

        <section class="panel">

            <div class="panel-header">

                <div class="panel-title">
                    <h2>Clientes registrados</h2>
                    <p>
                        Consulta y administra los clientes de la plataforma.
                    </p>
                </div>

                <div class="acciones">

                    <div class="buscador">
                        <span class="buscador-icon">🔎</span>

                        <input
                            type="text"
                            id="buscarCliente"
                            placeholder="Buscar cliente..."
                            oninput="filtrarClientes()"
                            aria-label="Buscar clientes">
                    </div>

                    <!-- CORREGIDO: ABRIR FORMULARIO MEDIANTE EL SERVLET -->

                    <a
                        href="<%= contexto %>/admin/clientes?accion=nuevo"
                        class="btn-nuevo">
                        ＋ Nuevo cliente
                    </a>

                </div>

            </div>

            <div class="tabla-container">

                <% if (clientes.isEmpty()) { %>

                    <div class="sin-clientes">

                        <div class="sin-clientes-icon">👥</div>

                        <h3>No hay clientes registrados</h3>

                        <p>
                            Todavía no existen clientes registrados en el sistema.
                        </p>

                        <!-- CORREGIDO: MISMA RUTA DEL SERVLET -->

                        <a
                            href="<%= contexto %>/admin/clientes?accion=nuevo"
                            class="btn-nuevo">
                            ＋ Crear primer cliente
                        </a>

                    </div>

                <% } else { %>

                    <table id="tablaClientes">

                        <thead>
                            <tr>
                                <th>Cliente</th>
                                <th>Documento</th>
                                <th>Teléfono</th>
                                <th>Correo</th>
                                <th>Ciudad</th>
                                <th>Registro</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>

                        <tbody>

                        <% for (cliente clienteActual : clientes) { %>

                            <tr>

                                <!-- NOMBRE DEL CLIENTE -->

                                <td>
                                    <div class="cliente-nombre">

                                        <div class="cliente-avatar">
                                            <%
                                                String nombre = clienteActual.getNombre();

                                                String inicial =
                                                    (nombre != null && !nombre.trim().isEmpty())
                                                    ? nombre.trim().substring(0, 1).toUpperCase()
                                                    : "?";
                                            %>

                                            <%= inicial %>
                                        </div>

                                        <div>

                                            <div class="nombre-principal">
                                                <%= clienteActual.getNombre() == null
                                                    ? ""
                                                    : clienteActual.getNombre() %>

                                                <%= clienteActual.getApellido() == null
                                                    ? ""
                                                    : clienteActual.getApellido() %>
                                            </div>

                                            <div class="nombre-secundario">
                                                ID: <%= clienteActual.getId() %>
                                            </div>

                                        </div>

                                    </div>
                                </td>

                                <!-- DOCUMENTO -->

                                <td>
                                    <%= clienteActual.getDocumento() == null
                                        || clienteActual.getDocumento().trim().isEmpty()
                                        ? "No registrado"
                                        : clienteActual.getDocumento() %>
                                </td>

                                <!-- TELÉFONO -->

                                <td>
                                    <%= clienteActual.getTelefono() == null
                                        || clienteActual.getTelefono().trim().isEmpty()
                                        ? "No registrado"
                                        : clienteActual.getTelefono() %>
                                </td>

                                <!-- CORREO -->

                                <td>
                                    <%= clienteActual.getCorreo() == null
                                        || clienteActual.getCorreo().trim().isEmpty()
                                        ? "No registrado"
                                        : clienteActual.getCorreo() %>
                                </td>

                                <!-- CIUDAD -->

                                <td>
                                    <%= clienteActual.getCiudad() == null
                                        || clienteActual.getCiudad().trim().isEmpty()
                                        ? "No registrada"
                                        : clienteActual.getCiudad() %>
                                </td>

                                <!-- FECHA DE REGISTRO -->

                                <td>
                                    <%= clienteActual.getFechaRegistro() == null
                                        ? "Sin fecha"
                                        : clienteActual.getFechaRegistro() %>
                                </td>

                                <!-- ACCIONES -->

                                <td>

                                    <div class="acciones-tabla">

                                        <a
                                            href="<%= contexto %>/admin/clientes?accion=editar&id=<%= clienteActual.getId() %>"
                                            class="btn-accion btn-editar"
                                            title="Editar cliente"
                                            aria-label="Editar cliente">
                                            ✏️
                                        </a>

                                        <form
                                            class="form-eliminar"
                                            action="<%= contexto %>/admin/clientes"
                                            method="post"
                                            onsubmit="return confirmarEliminacion(this);">

                                            <input
                                                type="hidden"
                                                name="accion"
                                                value="eliminar">

                                            <input
                                                type="hidden"
                                                name="id"
                                                value="<%= clienteActual.getId() %>">

                                            <button
                                                type="submit"
                                                class="btn-accion btn-eliminar"
                                                title="Eliminar cliente"
                                                aria-label="Eliminar cliente">
                                                🗑️
                                            </button>

                                        </form>

                                    </div>

                                </td>

                            </tr>

                        <% } %>

                        </tbody>

                    </table>

                <% } %>

            </div>

        </section>

        <!-- PIE DE PÁGINA -->

        <footer class="footer">
            © 2026 Rescate Móvil
            <br>
            Plataforma de gestión de servicios técnicos móviles
        </footer>

    </main>

</div>

<script>
    function filtrarClientes() {
        const input = document.getElementById("buscarCliente");
        const tabla = document.getElementById("tablaClientes");

        if (!input || !tabla) {
            return;
        }

        const filtro = input.value.toLowerCase().trim();
        const filas = tabla.querySelectorAll("tbody tr");

        filas.forEach(function(fila) {
            const texto = fila.textContent.toLowerCase();
            fila.style.display = texto.includes(filtro) ? "" : "none";
        });
    }

    function confirmarEliminacion(formulario) {
        const campoId = formulario.querySelector('input[name="id"]');

        if (!campoId) {
            return false;
        }

        const id = campoId.value;

        return confirm(
            "¿Está seguro de que desea eliminar al cliente con ID " + id + "?\n\n" +
            "Esta operación puede afectar los registros relacionados y no se puede deshacer."
        );
    }
</script>

</body>
</html>