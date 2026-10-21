<%-- 
    Document   : tecnicos
    Created on : 11/10/2026, 9:49:38 p. m.
    Author     : aleja
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.rescatemovil.modelo.Tecnico"%>

<%!
    private String escaparHTML(String texto) {
        if (texto == null) {
            return "";
        }

        return texto.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<%
    List<Tecnico> tecnicos =
        (List<Tecnico>) request.getAttribute("tecnicos");

    if (tecnicos == null) {
        tecnicos = new ArrayList<>();
    }

    int totalTecnicos = tecnicos.size();
    int totalActivos = 0;
    int totalInactivos = 0;

    for (Tecnico t : tecnicos) {
        if (t.isActivo()) {
            totalActivos++;
        } else {
            totalInactivos++;
        }
    }

    String buscar = request.getParameter("buscar");
    if (buscar == null) {
        buscar = "";
    }

    String mensaje = request.getParameter("mensaje");
    String error = request.getParameter("error");

    String contexto = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Gestión de técnicos | Rescate Móvil</title>

    <style>
        :root {
            --fondo: #07111f;
            --panel: #101e30;
            --panel-claro: #172940;
            --borde: #263b53;
            --texto: #f0f6ff;
            --texto-secundario: #9eb0c7;
            --azul: #4361ee;
            --cian: #00b4d8;
            --verde: #23c483;
            --rojo: #ff647c;
            --amarillo: #ffca64;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, Helvetica, sans-serif;
            background:
                radial-gradient(
                    circle at top right,
                    rgba(0, 180, 216, .12),
                    transparent 35%
                ),
                var(--fondo);
            color: var(--texto);
            min-height: 100vh;
        }

        a {
            color: inherit;
            text-decoration: none;
        }

        .barra {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            padding: 18px 5%;
            background: rgba(7, 17, 31, .94);
            border-bottom: 1px solid var(--borde);
        }

        .marca {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 21px;
            font-weight: bold;
        }

        .marca-icono {
            width: 45px;
            height: 45px;
            display: grid;
            place-items: center;
            border-radius: 13px;
            background: linear-gradient(135deg, var(--cian), var(--azul));
            font-size: 25px;
        }

        .marca small {
            display: block;
            margin-top: 4px;
            font-size: 11px;
            color: var(--texto-secundario);
            font-weight: normal;
        }

        .enlace-volver {
            padding: 10px 15px;
            border: 1px solid var(--borde);
            border-radius: 10px;
            color: #d8e6f8;
            font-size: 13px;
        }

        .enlace-volver:hover {
            border-color: var(--cian);
            color: var(--cian);
        }

        .contenedor {
            width: 92%;
            max-width: 1450px;
            margin: 35px auto;
        }

        .encabezado {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 28px;
        }

        .encabezado h1 {
            margin: 0 0 9px;
            font-size: clamp(25px, 4vw, 34px);
        }

        .encabezado p {
            margin: 0;
            color: var(--texto-secundario);
            line-height: 1.6;
        }

        .boton {
            display: inline-flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            padding: 12px 17px;
            border: none;
            border-radius: 10px;
            font-weight: bold;
            font-size: 13px;
            cursor: pointer;
            transition: .2s;
        }

        .boton:hover {
            transform: translateY(-2px);
            filter: brightness(1.1);
        }

        .boton-principal {
            color: white;
            background: linear-gradient(135deg, var(--azul), var(--cian));
        }

        .estadisticas {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 18px;
            margin-bottom: 25px;
        }

        .tarjeta {
            padding: 23px;
            border: 1px solid var(--borde);
            border-radius: 16px;
            background: linear-gradient(
                145deg,
                rgba(23, 41, 64, .96),
                rgba(16, 30, 48, .96)
            );
        }

        .tarjeta .etiqueta {
            color: var(--texto-secundario);
            font-size: 13px;
        }

        .tarjeta .numero {
            margin-top: 12px;
            font-size: 31px;
            font-weight: bold;
        }

        .tarjeta.total .numero {
            color: var(--cian);
        }

        .tarjeta.activos .numero {
            color: var(--verde);
        }

        .tarjeta.inactivos .numero {
            color: var(--amarillo);
        }

        .panel {
            overflow: hidden;
            border: 1px solid var(--borde);
            border-radius: 16px;
            background: rgba(16, 30, 48, .95);
        }

        .panel-superior {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
            padding: 22px;
            border-bottom: 1px solid var(--borde);
        }

        .panel-superior h2 {
            margin: 0;
            font-size: 19px;
        }

        .buscador {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .buscador input {
            width: 270px;
            max-width: 100%;
            padding: 11px 13px;
            border: 1px solid var(--borde);
            border-radius: 9px;
            outline: none;
            background: var(--fondo);
            color: white;
        }

        .buscador input:focus {
            border-color: var(--cian);
        }

        .boton-buscar {
            background: var(--panel-claro);
            color: white;
            border: 1px solid var(--borde);
        }

        .boton-limpiar {
            background: transparent;
            border: 1px solid var(--borde);
            color: var(--texto-secundario);
        }

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
            background: rgba(7, 17, 31, .65);
        }

        th {
            padding: 16px;
            text-align: left;
            color: var(--texto-secundario);
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: .6px;
        }

        td {
            padding: 17px 16px;
            border-top: 1px solid rgba(38, 59, 83, .7);
            font-size: 13px;
            vertical-align: middle;
        }

        tbody tr:hover {
            background: rgba(67, 97, 238, .06);
        }

        .identidad {
            display: flex;
            align-items: center;
            gap: 12px;
            min-width: 180px;
        }

        .avatar {
            display: grid;
            place-items: center;
            width: 40px;
            height: 40px;
            flex-shrink: 0;
            border-radius: 12px;
            color: var(--cian);
            background: rgba(0, 180, 216, .12);
            font-weight: bold;
        }

        .nombre {
            font-weight: bold;
            color: var(--texto);
        }

        .subtexto {
            display: block;
            margin-top: 5px;
            color: var(--texto-secundario);
            font-size: 11px;
        }

        .estado {
            display: inline-block;
            padding: 6px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: bold;
        }

        .estado-activo {
            background: rgba(35, 196, 131, .12);
            color: #59e5ae;
        }

        .estado-inactivo {
            background: rgba(255, 202, 100, .12);
            color: var(--amarillo);
        }

        .acciones {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .btn-accion {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 68px;
            padding: 8px 10px;
            border-radius: 8px;
            font-size: 11px;
            font-weight: bold;
            cursor: pointer;
        }

        .btn-editar {
            color: #8bd9ff;
            border: 1px solid rgba(0, 180, 216, .3);
            background: rgba(0, 180, 216, .08);
        }

        .btn-eliminar {
            color: #ff9aa9;
            border: 1px solid rgba(255, 100, 124, .3);
            background: rgba(255, 100, 124, .08);
        }

        .form-eliminar {
            display: inline;
            margin: 0;
        }

        .alerta {
            padding: 14px 17px;
            margin-bottom: 20px;
            border-radius: 10px;
            font-size: 13px;
            line-height: 1.5;
        }

        .alerta-exito {
            color: #83f0c2;
            background: rgba(35, 196, 131, .1);
            border: 1px solid rgba(35, 196, 131, .25);
        }

        .alerta-error {
            color: #ffacb8;
            background: rgba(255, 100, 124, .1);
            border: 1px solid rgba(255, 100, 124, .25);
        }

        .sin-resultados {
            text-align: center;
            padding: 45px 20px;
            color: var(--texto-secundario);
        }

        .sin-resultados strong {
            display: block;
            margin-bottom: 9px;
            color: var(--texto);
            font-size: 17px;
        }

        .pie {
            padding: 25px 10px;
            text-align: center;
            color: var(--texto-secundario);
            font-size: 12px;
        }

        @media (max-width: 760px) {
            .estadisticas {
                grid-template-columns: 1fr;
            }

            .encabezado {
                align-items: flex-start;
            }

            .encabezado .boton {
                width: 100%;
            }

            .panel-superior {
                align-items: stretch;
            }

            .buscador {
                width: 100%;
            }

            .buscador input {
                flex: 1;
                width: 100%;
            }

            .barra {
                padding: 14px 4%;
            }

            .contenedor {
                width: 94%;
                margin-top: 25px;
            }
        }
    </style>
</head>

<body>

<header class="barra">
    <a class="marca" href="<%= contexto %>/admin/index.jsp">
        <span class="marca-icono">📱</span>
        <span>
            Rescate Móvil
            <small>Administración del sistema</small>
        </span>
    </a>

    <a class="enlace-volver"
       href="<%= contexto %>/admin/index.jsp">
        ← Volver al panel
    </a>
</header>

<main class="contenedor">

    <section class="encabezado">
        <div>
            <h1>Gestión de técnicos</h1>
            <p>
                Administra los especialistas, sus datos de contacto
                y su estado dentro de Rescate Móvil.
            </p>
        </div>

        <a class="boton boton-principal"
           href="<%= contexto %>/admin/nuevo-tecnico.jsp">
            + Nuevo técnico
        </a>
    </section>

    <% if ("registrado".equals(mensaje)) { %>
        <div class="alerta alerta-exito">
            El técnico se registró correctamente.
        </div>
    <% } else if ("actualizado".equals(mensaje)) { %>
        <div class="alerta alerta-exito">
            Los datos del técnico se actualizaron correctamente.
        </div>
    <% } else if ("eliminado".equals(mensaje)) { %>
        <div class="alerta alerta-exito">
            El técnico se eliminó correctamente.
        </div>
    <% } %>

    <% if ("campos".equals(error)) { %>
        <div class="alerta alerta-error">
            Verifica que todos los campos obligatorios estén completos
            y que el correo electrónico sea válido.
        </div>
    <% } else if ("registrar".equals(error)) { %>
        <div class="alerta alerta-error">
            No fue posible registrar al técnico. Revisa la consola
            de Tomcat para conocer el error de MySQL.
        </div>
    <% } else if ("actualizar".equals(error)) { %>
        <div class="alerta alerta-error">
            No fue posible actualizar al técnico.
            Revisa la consola de Tomcat.
        </div>
    <% } else if ("eliminar".equals(error)) { %>
        <div class="alerta alerta-error">
            No fue posible eliminar al técnico. Comprueba que no tenga
            reparaciones activas y revisa los registros de Tomcat.
        </div>
    <% } else if ("noencontrado".equals(error)) { %>
        <div class="alerta alerta-error">
            No se encontró el técnico solicitado.
        </div>
    <% } else if ("id".equals(error)) { %>
        <div class="alerta alerta-error">
            El identificador del técnico no es válido.
        </div>
    <% } %>

    <section class="estadisticas">
        <article class="tarjeta total">
            <div class="etiqueta">Técnicos encontrados</div>
            <div class="numero"><%= totalTecnicos %></div>
        </article>

        <article class="tarjeta activos">
            <div class="etiqueta">Técnicos activos</div>
            <div class="numero"><%= totalActivos %></div>
        </article>

        <article class="tarjeta inactivos">
            <div class="etiqueta">Técnicos inactivos</div>
            <div class="numero"><%= totalInactivos %></div>
        </article>
    </section>

    <section class="panel">

        <div class="panel-superior">
            <h2>Directorio de técnicos</h2>

            <form class="buscador"
                  action="<%= contexto %>/admin/tecnicos"
                  method="get">

                <input type="search"
                       name="buscar"
                       value="<%= escaparHTML(buscar) %>"
                       placeholder="Nombre, especialidad, teléfono..."
                       aria-label="Buscar técnicos">

                <button class="boton boton-buscar" type="submit">
                    Buscar
                </button>

                <a class="boton boton-limpiar"
                   href="<%= contexto %>/admin/tecnicos">
                    Limpiar
                </a>
            </form>
        </div>

        <div class="tabla-contenedor">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Técnico</th>
                        <th>Especialidad</th>
                        <th>Teléfono</th>
                        <th>Correo</th>
                        <th>Reparaciones activas</th>
                        <th>Estado</th>
                        <th>Acciones</th>
                    </tr>
                </thead>

                <tbody>
                    <% if (tecnicos.isEmpty()) { %>
                        <tr>
                            <td colspan="8">
                                <div class="sin-resultados">
                                    <strong>No hay técnicos para mostrar</strong>
                                    No se encontraron registros para esta consulta.
                                </div>
                            </td>
                        </tr>
                    <% } else { %>

                        <% for (Tecnico tecnico : tecnicos) { %>
                            <tr>
                                <td>
                                    #<%= tecnico.getId() %>
                                </td>

                                <td>
                                    <div class="identidad">
                                        <div class="avatar">
                                            <%= escaparHTML(
                                                tecnico.getNombre().isEmpty()
                                                    ? "T"
                                                    : tecnico.getNombre()
                                                        .substring(0, 1)
                                                        .toUpperCase()
                                            ) %>
                                        </div>

                                        <div>
                                            <span class="nombre">
                                                <%= escaparHTML(tecnico.getNombre()) %>
                                            </span>

                                            <span class="subtexto">
                                                Técnico especializado
                                            </span>
                                        </div>
                                    </div>
                                </td>

                                <td>
                                    <%= escaparHTML(tecnico.getEspecialidad()) %>
                                </td>

                                <td>
                                    <%= escaparHTML(tecnico.getTelefono()) %>
                                </td>

                                <td>
                                    <%= escaparHTML(tecnico.getCorreo()) %>
                                </td>

                                <td>
                                    <%= tecnico.getReparacionesActivas() %>
                                </td>

                                <td>
                                    <% if (tecnico.isActivo()) { %>
                                        <span class="estado estado-activo">
                                            Activo
                                        </span>
                                    <% } else { %>
                                        <span class="estado estado-inactivo">
                                            Inactivo
                                        </span>
                                    <% } %>
                                </td>

                                <td>
                                    <div class="acciones">
                                        <a class="btn-accion btn-editar"
                                           href="<%= contexto %>/admin/tecnicos?accion=editar&amp;id=<%= tecnico.getId() %>">
                                            Editar
                                        </a>

                                        <form class="form-eliminar"
                                              action="<%= contexto %>/admin/tecnicos"
                                              method="post"
                                              onsubmit="return confirm('¿Seguro que deseas eliminar este técnico? Esta acción no se puede deshacer.');">

                                            <input type="hidden"
                                                   name="accion"
                                                   value="eliminar">

                                            <input type="hidden"
                                                   name="id"
                                                   value="<%= tecnico.getId() %>">

                                            <button type="submit"
                                                    class="btn-accion btn-eliminar">
                                                Eliminar
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        <% } %>

                    <% } %>
                </tbody>
            </table>
        </div>
    </section>

    <footer class="pie">
        © 2026 Rescate Móvil | Sistema de gestión de servicios técnicos
    </footer>

</main>

</body>
</html>
