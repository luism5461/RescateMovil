<%-- 
    Document   : reparaciones
    Created on : 11/10/2026, 10:23:56 p. m.
    Author     : aleja
--%>

<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.rescatemovil.modelo.Reparacion"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>

<%
    request.setCharacterEncoding("UTF-8");

    if (session.getAttribute("usuario") == null
            || !"admin".equalsIgnoreCase(
                String.valueOf(session.getAttribute("rol")))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Reparacion> reparaciones =
        (List<Reparacion>) request.getAttribute("reparaciones");

    String buscar = (String) request.getAttribute("buscar");
    if (buscar == null) {
        buscar = "";
    }

    SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");
    NumberFormat formatoDinero =
        NumberFormat.getCurrencyInstance(new Locale("es", "CO"));

    String mensaje = request.getParameter("mensaje");
    String error = request.getParameter("error");
    String textoMensaje = null;
    String textoError = null;

    if ("registrada".equals(mensaje)) {
        textoMensaje = "La reparación se registró correctamente.";
    } else if ("actualizada".equals(mensaje)) {
        textoMensaje = "La reparación se actualizó correctamente.";
    } else if ("estado_actualizado".equals(mensaje)) {
        textoMensaje = "El estado se actualizó correctamente.";
    } else if ("eliminada".equals(mensaje)) {
        textoMensaje = "La reparación se eliminó correctamente.";
    } else if ("error_eliminar".equals(mensaje)) {
        textoError = "No fue posible eliminar la reparación. "
            + "Verifica si existen restricciones en la base de datos.";
    }

    if ("id".equals(error)) {
        textoError = "El identificador de la reparación no es válido.";
    } else if ("no_encontrada".equals(error)) {
        textoError = "La reparación solicitada no existe.";
    } else if ("estado".equals(error)) {
        textoError = "El estado seleccionado no es válido.";
    } else if ("datos".equals(error)) {
        textoError = "Verifica los datos enviados.";
    } else if ("actualizar".equals(error)) {
        textoError = "No fue posible actualizar la reparación.";
    } else if ("registrar".equals(error)) {
        textoError = "No fue posible registrar la reparación.";
    }

    String buscarSeguro = buscar
        .replace("&", "&amp;")
        .replace("\"", "&quot;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace("'", "&#39;");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Gestión de reparaciones | Rescate Móvil</title>

    <style>
        :root {
            --fondo: #07111f;
            --fondo-secundario: #0a1628;
            --tarjeta: #101e32;
            --tarjeta-hover: #162740;
            --borde: #263b55;
            --texto: #f1f5f9;
            --texto-secundario: #9aadc4;
            --cian: #00b4d8;
            --azul: #4361ee;
            --verde: #10b981;
            --rojo: #ef4444;
        }

        * {
            box-sizing: border-box;
        }

        html {
            min-height: 100%;
            scroll-behavior: smooth;
        }

        body {
            min-height: 100vh;
            margin: 0;
            font-family: Arial, Helvetica, sans-serif;
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

        .barra {
            position: relative;
            background: rgba(7, 17, 31, 0.94);
            border-bottom: 1px solid rgba(0, 180, 216, 0.22);
            padding: 18px 5%;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 15px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.15);
        }

        .marca {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 23px;
            font-weight: 800;
            letter-spacing: -0.5px;
        }

        .marca-icono {
            width: 43px;
            height: 43px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 12px;
            color: var(--cian);
            background: rgba(0, 180, 216, 0.10);
            border: 1px solid rgba(0, 180, 216, 0.28);
            font-size: 23px;
        }

        .marca span {
            color: var(--cian);
        }

        .volver {
            color: #dce8f6;
            text-decoration: none;
            border: 1px solid var(--borde);
            border-radius: 9px;
            padding: 10px 15px;
            background: rgba(255, 255, 255, 0.025);
            transition: 0.2s ease;
            font-size: 13px;
        }

        .volver:hover {
            border-color: var(--cian);
            background: rgba(0, 180, 216, 0.09);
            transform: translateY(-1px);
        }

        .contenedor {
            width: 100%;
            max-width: 1500px;
            margin: 0 auto;
            padding: 35px 24px;
        }

        .encabezado {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 27px;
        }

        .etiqueta {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: var(--cian);
            background: rgba(0, 180, 216, 0.09);
            border: 1px solid rgba(0, 180, 216, 0.20);
            padding: 6px 11px;
            border-radius: 30px;
            font-size: 11px;
            font-weight: bold;
            letter-spacing: 1px;
            text-transform: uppercase;
            margin-bottom: 13px;
        }

        .punto {
            width: 7px;
            height: 7px;
            border-radius: 50%;
            background: var(--cian);
            box-shadow: 0 0 10px rgba(0, 180, 216, 0.7);
        }

        h1 {
            margin: 0 0 10px;
            font-size: clamp(25px, 3vw, 34px);
            line-height: 1.2;
            letter-spacing: -0.7px;
        }

        .subtitulo {
            margin: 0;
            color: var(--texto-secundario);
            line-height: 1.7;
            font-size: 14px;
        }

        .boton {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 7px;
            border: 1px solid transparent;
            border-radius: 9px;
            padding: 11px 15px;
            text-decoration: none;
            font-weight: bold;
            cursor: pointer;
            font-size: 13px;
            text-align: center;
            transition: 0.2s ease;
            font-family: inherit;
        }

        .boton:hover {
            transform: translateY(-1px);
            filter: brightness(1.1);
        }

        .boton-principal {
            color: #ffffff;
            background: linear-gradient(135deg, #087ea4, #4361ee);
            box-shadow: 0 5px 18px rgba(0, 180, 216, 0.13);
        }

        .boton-secundario {
            color: #dce8f6;
            background: #17283e;
            border-color: var(--borde);
        }

        .boton-editar {
            color: #dbeafe;
            background: rgba(67, 97, 238, 0.14);
            border-color: rgba(99, 130, 255, 0.32);
        }

        .boton-estado {
            color: #b9f8df;
            background: rgba(16, 185, 129, 0.12);
            border-color: rgba(16, 185, 129, 0.28);
        }

        .boton-eliminar {
            width: 100%;
            color: #fecaca;
            background: rgba(239, 68, 68, 0.10);
            border-color: rgba(239, 68, 68, 0.27);
        }

        .busqueda {
            background: linear-gradient(
                145deg,
                rgba(16, 30, 50, 0.96),
                rgba(11, 24, 42, 0.96)
            );
            border: 1px solid var(--borde);
            padding: 21px;
            border-radius: 15px;
            margin-bottom: 22px;
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.12);
        }

        .busqueda-titulo {
            margin: 0 0 15px;
            font-size: 15px;
            font-weight: bold;
        }

        .busqueda form {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .busqueda input {
            flex: 1;
            min-width: 220px;
            padding: 12px 14px;
            color: var(--texto);
            background: #091526;
            border: 1px solid #30445e;
            border-radius: 9px;
            font-size: 14px;
            outline: none;
            font-family: inherit;
        }

        .busqueda input::placeholder {
            color: #70849d;
        }

        .busqueda input:focus {
            border-color: var(--cian);
            box-shadow: 0 0 0 3px rgba(0, 180, 216, 0.10);
        }

        .tabla-contenedor {
            overflow-x: auto;
            background: rgba(13, 27, 46, 0.96);
            border: 1px solid var(--borde);
            border-radius: 15px;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.16);
        }

        .tabla-cabecera {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px;
            padding: 19px 21px;
            border-bottom: 1px solid var(--borde);
        }

        .tabla-cabecera h2 {
            margin: 0;
            font-size: 16px;
        }

        .tabla-cabecera p {
            margin: 6px 0 0;
            font-size: 12px;
            color: var(--texto-secundario);
        }

        .contador {
            color: #b8f4ff;
            background: rgba(0, 180, 216, 0.10);
            border: 1px solid rgba(0, 180, 216, 0.20);
            border-radius: 20px;
            padding: 7px 11px;
            font-size: 12px;
            font-weight: bold;
        }

        table {
            width: 100%;
            min-width: 1180px;
            border-collapse: collapse;
        }

        th,
        td {
            padding: 15px 13px;
            text-align: left;
            border-bottom: 1px solid rgba(38, 59, 85, 0.75);
            vertical-align: middle;
        }

        th {
            background: #101f34;
            color: #9eb4ce;
            font-size: 10px;
            letter-spacing: 0.7px;
            text-transform: uppercase;
            white-space: nowrap;
        }

        td {
            color: #dce6f3;
            font-size: 12px;
            line-height: 1.6;
        }

        tbody tr {
            transition: background 0.2s ease;
        }

        tbody tr:hover {
            background: rgba(0, 180, 216, 0.035);
        }

        tbody tr:last-child td {
            border-bottom: none;
        }

        .codigo {
            color: var(--cian);
            font-weight: 800;
            white-space: nowrap;
        }

        .nombre {
            color: #f1f5f9;
            font-weight: bold;
        }

        .dinero {
            color: #9cebd0;
            font-weight: bold;
            white-space: nowrap;
        }

        .estado {
            display: inline-block;
            padding: 6px 9px;
            border-radius: 20px;
            color: #b8f4ff;
            background: rgba(0, 180, 216, 0.10);
            border: 1px solid rgba(0, 180, 216, 0.18);
            font-size: 10px;
            font-weight: bold;
            white-space: nowrap;
        }

        .form-estado {
            display: flex;
            flex-direction: column;
            gap: 8px;
            min-width: 155px;
        }

        .form-estado select {
            width: 100%;
            padding: 9px;
            color: #e2eaf5;
            border: 1px solid #30445e;
            border-radius: 7px;
            background: #091526;
            font-size: 12px;
            outline: none;
            font-family: inherit;
        }

        .form-estado select:focus {
            border-color: var(--cian);
        }

        .form-estado select option {
            color: #e2eaf5;
            background: #101e32;
        }

        .acciones {
            display: flex;
            flex-direction: column;
            gap: 8px;
            min-width: 95px;
        }

        .acciones form {
            margin: 0;
        }

        .vacio {
            text-align: center;
            padding: 40px 20px;
            color: var(--texto-secundario);
            font-size: 14px;
        }

        .vacio-icono {
            display: block;
            font-size: 30px;
            margin-bottom: 10px;
        }

        .mensaje {
            margin-bottom: 18px;
            padding: 14px 17px;
            border-radius: 10px;
            color: #a7f3d0;
            background: rgba(16, 185, 129, 0.10);
            border: 1px solid rgba(16, 185, 129, 0.25);
            line-height: 1.6;
            font-size: 13px;
        }

        .error {
            color: #fecaca;
            background: rgba(239, 68, 68, 0.10);
            border-color: rgba(239, 68, 68, 0.28);
        }

        footer {
            text-align: center;
            color: #7388a2;
            padding: 27px 18px;
            margin-top: 10px;
            border-top: 1px solid rgba(38, 59, 85, 0.55);
            font-size: 12px;
        }

        @media (max-width: 700px) {
            .barra {
                padding: 15px 18px;
            }

            .marca {
                font-size: 20px;
            }

            .contenedor {
                padding: 25px 13px;
            }

            .encabezado {
                align-items: stretch;
            }

            .encabezado > a {
                width: 100%;
            }

            .busqueda {
                padding: 15px;
            }

            .busqueda form {
                flex-direction: column;
            }

            .busqueda input {
                width: 100%;
                min-width: 0;
            }

            .busqueda .boton {
                width: 100%;
            }

            .tabla-cabecera {
                padding: 16px;
            }
        }
    </style>
</head>

<body>

<header class="barra">
    <div class="marca">
        <div class="marca-icono">📱</div>
        <div>Rescate <span>Móvil</span></div>
    </div>

    <a class="volver"
       href="<%= request.getContextPath() %>/admin/index.jsp">
        ← Volver al panel
    </a>
</header>

<main class="contenedor">

    <div class="encabezado">
        <div>
            <div class="etiqueta">
                <span class="punto"></span>
                Administración
            </div>

            <h1>Gestión de reparaciones</h1>

            <p class="subtitulo">
                Consulta y administra las reparaciones de los clientes.
            </p>
        </div>

        <a class="boton boton-principal"
           href="<%= request.getContextPath() %>/admin/reparaciones?accion=nuevo">
            + Nueva reparación
        </a>
    </div>

    <% if (textoMensaje != null) { %>
        <div class="mensaje">
            ✓ <%= textoMensaje %>
        </div>
    <% } %>

    <% if (textoError != null) { %>
        <div class="mensaje error">
            ⚠ <%= textoError %>
        </div>
    <% } %>

    <section class="busqueda">
        <h2 class="busqueda-titulo">Buscar reparaciones</h2>

        <form method="get"
              action="<%= request.getContextPath() %>/admin/reparaciones">

            <input type="text"
                   name="buscar"
                   value="<%= buscarSeguro %>"
                   placeholder="Buscar por código, cliente, equipo o falla"
                   aria-label="Buscar reparaciones">

            <button class="boton boton-principal" type="submit">
                Buscar
            </button>

            <a class="boton boton-secundario"
               href="<%= request.getContextPath() %>/admin/reparaciones">
                Limpiar
            </a>
        </form>
    </section>

    <section class="tabla-contenedor">

        <div class="tabla-cabecera">
            <div>
                <h2>Historial de reparaciones</h2>
                <p>Consulta los equipos y actualiza su estado de servicio.</p>
            </div>

            <span class="contador">
                <%= reparaciones == null ? 0 : reparaciones.size() %>
                registros
            </span>
        </div>

        <table>
            <thead>
                <tr>
                    <th>Código</th>
                    <th>Cliente</th>
                    <th>Técnico</th>
                    <th>Equipo</th>
                    <th>Fecha de ingreso</th>
                    <th>Costo</th>
                    <th>Estado</th>
                    <th>Actualizar estado</th>
                    <th>Acciones</th>
                </tr>
            </thead>

            <tbody>
            <%
                if (reparaciones == null || reparaciones.isEmpty()) {
            %>
                <tr>
                    <td colspan="9" class="vacio">
                        <span class="vacio-icono">📱</span>
                        No hay reparaciones para mostrar.
                        Puedes registrar una nueva reparación.
                    </td>
                </tr>
            <%
                } else {
                    for (Reparacion r : reparaciones) {
            %>
                <tr>
                    <td>
                        <span class="codigo">
                            <%= r.getCodigo() == null
                                ? "Sin código"
                                : r.getCodigo() %>
                        </span>
                    </td>

                    <td>
                        <span class="nombre">
                            <%= r.getNombreCliente() == null
                                ? "Sin cliente"
                                : r.getNombreCliente() %>
                            <%= r.getApellidoCliente() == null
                                ? ""
                                : r.getApellidoCliente() %>
                        </span>
                    </td>

                    <td>
                        <%= r.getNombreTecnico() == null
                            ? "Sin técnico"
                            : r.getNombreTecnico() %>
                    </td>

                    <td>
                        <%= r.getEquipo() == null
                            ? "Sin equipo"
                            : r.getEquipo() %>
                    </td>

                    <td>
                        <%= r.getFechaIngreso() == null
                            ? "—"
                            : formatoFecha.format(r.getFechaIngreso()) %>
                    </td>

                    <td>
                        <span class="dinero">
                            <%= r.getCosto() == null
                                ? formatoDinero.format(0)
                                : formatoDinero.format(r.getCosto()) %>
                        </span>
                    </td>

                    <td>
                        <span class="estado">
                            <%= r.getEstado() == null
                                ? "Sin estado"
                                : r.getEstado() %>
                        </span>
                    </td>

                    <td>
                        <form class="form-estado"
                              method="post"
                              action="<%= request.getContextPath() %>/admin/reparaciones">

                            <input type="hidden"
                                   name="accion"
                                   value="cambiarEstado">

                            <input type="hidden"
                                   name="id"
                                   value="<%= r.getId() %>">

                            <select name="estado" required
                                    aria-label="Seleccionar nuevo estado">
                                <% for (String e : new String[]{
                                    "Recibido",
                                    "En proceso",
                                    "Listo para recoger",
                                    "Finalizado",
                                    "Entregado"
                                }) { %>
                                    <option value="<%= e %>"
                                        <%= e.equals(r.getEstado())
                                            ? "selected" : "" %>>
                                        <%= e %>
                                    </option>
                                <% } %>
                            </select>

                            <button class="boton boton-estado"
                                    type="submit">
                                Guardar estado
                            </button>
                        </form>
                    </td>

                    <td>
                        <div class="acciones">
                            <a class="boton boton-editar"
                               href="<%= request.getContextPath() %>/admin/reparaciones?accion=editar&amp;id=<%= r.getId() %>">
                                Editar
                            </a>

                            <form method="post"
                                  action="<%= request.getContextPath() %>/admin/reparaciones"
                                  onsubmit="return confirm('¿Estás seguro de eliminar esta reparación? Esta acción no se puede deshacer.');">

                                <input type="hidden"
                                       name="accion"
                                       value="eliminar">

                                <input type="hidden"
                                       name="id"
                                       value="<%= r.getId() %>">

                                <button class="boton boton-eliminar"
                                        type="submit">
                                    Eliminar
                                </button>
                            </form>
                        </div>
                    </td>
                </tr>
            <%
                    }
                }
            %>
            </tbody>
        </table>
    </section>

</main>

<footer>
    © 2026 Rescate Móvil | Sistema de gestión de servicios técnicos
</footer>

</body>
</html>