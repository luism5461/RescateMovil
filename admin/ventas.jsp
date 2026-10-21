
<%--
    Document   : ventas
    Created on : 12/10/2026
    Author     : aleja
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.rescatemovil.modelo.Venta"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="javax.servlet.http.HttpSession"%>
<%@page import="javax.servlet.http.HttpServletResponse"%>

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
    HttpSession sesion = request.getSession(false);

    if (sesion == null || sesion.getAttribute("rol") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String rol = String.valueOf(sesion.getAttribute("rol"));

    if (!rol.equalsIgnoreCase("admin")
            && !rol.equalsIgnoreCase("administrador")) {
        response.sendError(
            HttpServletResponse.SC_FORBIDDEN,
            "No tienes permisos para acceder a las ventas."
        );
        return;
    }

    List<Venta> ventas = (List<Venta>) request.getAttribute("ventas");

    if (ventas == null) {
        ventas = new ArrayList<>();
    }

    String busqueda = (String) request.getAttribute("busqueda");
    String fechaDesde = (String) request.getAttribute("fechaDesdeFiltro");
    String fechaHasta = (String) request.getAttribute("fechaHastaFiltro");

    if (busqueda == null) {
        busqueda = request.getParameter("buscar") == null
                ? "" : request.getParameter("buscar");
    }

    if (fechaDesde == null) {
        fechaDesde = request.getParameter("fechaDesde") == null
                ? "" : request.getParameter("fechaDesde");
    }

    if (fechaHasta == null) {
        fechaHasta = request.getParameter("fechaHasta") == null
                ? "" : request.getParameter("fechaHasta");
    }

    NumberFormat moneda = NumberFormat.getCurrencyInstance(
        new Locale("es", "CO")
    );

    BigDecimal totalVentas = BigDecimal.ZERO;

    for (Venta venta : ventas) {
        if (venta.getTotal() != null) {
            totalVentas = totalVentas.add(venta.getTotal());
        }
    }

    String resultado = request.getParameter("resultado");
    String contexto = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Gestión de ventas | Rescate Móvil</title>

    <style>
        :root {
            --fondo: #07111f;
            --panel: #101d30;
            --panel-claro: #162740;
            --borde: rgba(255, 255, 255, 0.10);
            --texto: #edf5ff;
            --texto-secundario: #9db0c9;
            --cian: #00b4d8;
            --azul: #4361ee;
            --verde: #20c997;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            font-family: "Segoe UI", Arial, sans-serif;
            color: var(--texto);
            background:
                radial-gradient(
                    circle at 10% 0%,
                    rgba(0, 180, 216, 0.12),
                    transparent 30%
                ),
                radial-gradient(
                    circle at 90% 10%,
                    rgba(67, 97, 238, 0.14),
                    transparent 30%
                ),
                var(--fondo);
        }

        a {
            text-decoration: none;
        }

        .barra-superior {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            padding: 18px 5%;
            border-bottom: 1px solid var(--borde);
            background: rgba(7, 17, 31, 0.88);
        }

        .marca {
            display: flex;
            align-items: center;
            gap: 13px;
        }

        .marca img {
            width: 52px;
            height: 52px;
            object-fit: contain;
            border-radius: 12px;
            background: white;
        }

        .marca h1 {
            margin: 0;
            font-size: 19px;
        }

        .marca p {
            margin: 4px 0 0;
            color: var(--texto-secundario);
            font-size: 12px;
        }

        .contenedor {
            width: min(1500px, 94%);
            margin: 35px auto;
        }

        .encabezado {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            flex-wrap: wrap;
            margin-bottom: 25px;
        }

        .encabezado h2 {
            margin: 0 0 8px;
            font-size: clamp(25px, 3vw, 34px);
        }

        .encabezado p {
            margin: 0;
            color: var(--texto-secundario);
        }

        .acciones-superiores {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .boton {
            display: inline-flex;
            justify-content: center;
            align-items: center;
            gap: 7px;
            padding: 11px 15px;
            border: 1px solid var(--borde);
            border-radius: 10px;
            color: var(--texto);
            font-family: inherit;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.2s;
        }

        .boton:hover {
            transform: translateY(-2px);
            filter: brightness(1.12);
        }

        .boton-principal {
            border: none;
            background: linear-gradient(135deg, var(--cian), var(--azul));
        }

        .boton-secundario {
            background: var(--panel-claro);
        }

        .estadisticas {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 18px;
            margin-bottom: 25px;
        }

        .tarjeta-estadistica {
            padding: 23px;
            border: 1px solid var(--borde);
            border-radius: 16px;
            background: linear-gradient(
                145deg,
                rgba(22, 39, 64, 0.96),
                rgba(16, 29, 48, 0.96)
            );
        }

        .etiqueta-estadistica {
            color: var(--texto-secundario);
            font-size: 13px;
        }

        .valor-estadistica {
            display: block;
            margin-top: 12px;
            font-size: clamp(23px, 3vw, 32px);
            font-weight: 750;
            overflow-wrap: anywhere;
        }

        .filtros {
            margin-bottom: 25px;
            padding: 23px;
            border: 1px solid var(--borde);
            border-radius: 16px;
            background: rgba(16, 29, 48, 0.94);
        }

        .titulo-seccion {
            margin: 0 0 7px;
            font-size: 19px;
        }

        .descripcion-seccion {
            margin: 0 0 20px;
            color: var(--texto-secundario);
            font-size: 13px;
            line-height: 1.5;
        }

        .formulario-filtros {
            display: grid;
            grid-template-columns: minmax(220px, 2fr)
                                   repeat(2, minmax(150px, 1fr));
            gap: 15px;
            align-items: end;
        }

        .campo {
            display: flex;
            flex-direction: column;
            gap: 8px;
            min-width: 0;
        }

        .campo label {
            color: #c5d4e8;
            font-size: 12px;
            font-weight: 600;
        }

        .campo input {
            width: 100%;
            min-width: 0;
            padding: 12px;
            border: 1px solid #2a3d58;
            border-radius: 9px;
            outline: none;
            color: var(--texto);
            background: #091525;
            font-family: inherit;
            font-size: 13px;
        }

        .campo input:focus {
            border-color: var(--cian);
            box-shadow: 0 0 0 3px rgba(0, 180, 216, 0.12);
        }

        .acciones-filtros {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin-top: 17px;
        }

        .mensaje {
            margin-bottom: 20px;
            padding: 14px 17px;
            border-radius: 10px;
            font-size: 14px;
        }

        .mensaje-exito {
            color: #a8f5dc;
            border: 1px solid rgba(32, 201, 151, 0.30);
            background: rgba(32, 201, 151, 0.10);
        }

        .historial {
            overflow: hidden;
            border: 1px solid var(--borde);
            border-radius: 16px;
            background: rgba(16, 29, 48, 0.95);
        }

        .historial-encabezado {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            padding: 22px;
            border-bottom: 1px solid var(--borde);
            flex-wrap: wrap;
        }

        .historial-encabezado h3 {
            margin: 0 0 6px;
            font-size: 18px;
        }

        .historial-encabezado p {
            margin: 0;
            color: var(--texto-secundario);
            font-size: 12px;
        }

        .contador {
            padding: 7px 11px;
            border: 1px solid rgba(0, 180, 216, 0.25);
            border-radius: 20px;
            color: #8deaff;
            background: rgba(0, 180, 216, 0.10);
            font-size: 12px;
            white-space: nowrap;
        }

        .tabla-contenedor {
            overflow-x: auto;
        }

        table {
            width: 100%;
            min-width: 1050px;
            border-collapse: collapse;
        }

        thead {
            background: rgba(255, 255, 255, 0.025);
        }

        th {
            padding: 15px 13px;
            color: var(--texto-secundario);
            text-align: left;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            white-space: nowrap;
        }

        td {
            padding: 16px 13px;
            border-top: 1px solid var(--borde);
            font-size: 13px;
            vertical-align: middle;
        }

        tbody tr:hover {
            background: rgba(67, 97, 238, 0.06);
        }

        .numero-venta {
            color: #8deaff;
            font-weight: 700;
        }

        .nombre-principal {
            font-weight: 600;
        }

        .total-venta {
            color: #75e5c2;
            font-weight: 700;
            white-space: nowrap;
        }

        .cantidad {
            display: inline-block;
            padding: 5px 9px;
            border-radius: 7px;
            background: var(--panel-claro);
            text-align: center;
        }

        .boton-detalle {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 8px 11px;
            border: 1px solid rgba(0, 180, 216, 0.30);
            border-radius: 8px;
            color: #8deaff;
            background: rgba(0, 180, 216, 0.08);
            font-size: 12px;
            white-space: nowrap;
        }

        .boton-detalle:hover {
            background: rgba(0, 180, 216, 0.18);
        }

        .sin-resultados {
            padding: 45px 20px;
            color: var(--texto-secundario);
            text-align: center;
        }

        .sin-resultados strong {
            display: block;
            margin-bottom: 8px;
            color: var(--texto);
            font-size: 17px;
        }

        .pie {
            padding: 25px 15px;
            color: var(--texto-secundario);
            text-align: center;
            font-size: 12px;
        }

        @media (max-width: 900px) {
            .formulario-filtros {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .campo-busqueda {
                grid-column: 1 / -1;
            }
        }

        @media (max-width: 600px) {
            .barra-superior {
                padding: 14px 4%;
            }

            .marca img {
                width: 43px;
                height: 43px;
            }

            .marca h1 {
                font-size: 16px;
            }

            .contenedor {
                margin: 24px auto;
            }

            .estadisticas {
                grid-template-columns: 1fr;
            }

            .formulario-filtros {
                grid-template-columns: 1fr;
            }

            .campo-busqueda {
                grid-column: auto;
            }

            .acciones-filtros,
            .acciones-superiores {
                width: 100%;
            }

            .acciones-filtros .boton,
            .acciones-superiores .boton {
                flex: 1;
            }

            .filtros {
                padding: 17px;
            }
        }
    </style>
</head>

<body>

<header class="barra-superior">
    <div class="marca">
        <img
            src="<%= contexto %>/logo.jpg"
            alt="Logo de Rescate Móvil"
            onerror="this.style.display='none';"
        >

        <div>
            <h1>Rescate Móvil</h1>
            <p>Sistema de gestión de servicios técnicos</p>
        </div>
    </div>

    <a class="boton boton-secundario"
       href="<%= contexto %>/admin/index.jsp">
        ← Panel administrador
    </a>
</header>

<main class="contenedor">

    <section class="encabezado">
        <div>
            <h2>Gestión de ventas</h2>
            <p>Consulta, filtra y revisa el historial de ventas registradas.</p>
        </div>

        <div class="acciones-superiores">
            <a class="boton boton-secundario"
               href="<%= contexto %>/admin/index.jsp">
                Inicio
            </a>

            <a class="boton boton-principal"
               href="<%= contexto %>/admin/nueva-venta.jsp">
                + Nueva venta
            </a>
        </div>
    </section>

    <% if ("ok".equals(resultado)) { %>
        <div class="mensaje mensaje-exito">
            ✓ La venta se registró correctamente y el inventario fue actualizado.
        </div>
    <% } %>

    <section class="estadisticas">
        <article class="tarjeta-estadistica">
            <span class="etiqueta-estadistica">
                Ventas encontradas
            </span>

            <strong class="valor-estadistica">
                <%= ventas.size() %>
            </strong>
        </article>

        <article class="tarjeta-estadistica">
            <span class="etiqueta-estadistica">
                Total de las ventas encontradas
            </span>

            <strong class="valor-estadistica">
                <%= moneda.format(totalVentas) %>
            </strong>
        </article>
    </section>

    <section class="filtros">
        <h3 class="titulo-seccion">Buscar y filtrar ventas</h3>

        <p class="descripcion-seccion">
            Busca por nombre del cliente, producto o número de venta.
            También puedes seleccionar una fecha inicial, final o ambas.
        </p>

        <form
            class="formulario-filtros"
            action="<%= contexto %>/admin/ventas"
            method="get">

            <div class="campo campo-busqueda">
                <label for="buscar">
                    Cliente, producto o número de venta
                </label>

                <input
                    type="text"
                    id="buscar"
                    name="buscar"
                    value="<%= escaparHTML(busqueda) %>"
                    placeholder="Ej.: Ana López, batería o 4"
                    maxlength="100">
            </div>

            <div class="campo">
                <label for="fechaDesde">Fecha desde</label>

                <input
                    type="date"
                    id="fechaDesde"
                    name="fechaDesde"
                    value="<%= escaparHTML(fechaDesde) %>">
            </div>

            <div class="campo">
                <label for="fechaHasta">Fecha hasta</label>

                <input
                    type="date"
                    id="fechaHasta"
                    name="fechaHasta"
                    value="<%= escaparHTML(fechaHasta) %>">
            </div>

            <div class="acciones-filtros">
                <button type="submit"
                        class="boton boton-principal">
                    Buscar ventas
                </button>

                <a class="boton boton-secundario"
                   href="<%= contexto %>/admin/ventas">
                    Limpiar filtros
                </a>
            </div>
        </form>
    </section>

    <section class="historial">
        <div class="historial-encabezado">
            <div>
                <h3>Historial de ventas</h3>
                <p>Registros que coinciden con tu búsqueda.</p>
            </div>

            <span class="contador">
                <%= ventas.size() %>
                <%= ventas.size() == 1 ? "registro" : "registros" %>
            </span>
        </div>

        <div class="tabla-contenedor">

            <% if (ventas.isEmpty()) { %>

                <div class="sin-resultados">
                    <strong>No se encontraron ventas</strong>
                    No hay registros que coincidan con los filtros ingresados.
                    Prueba con otro nombre, número o rango de fechas.
                </div>

            <% } else { %>

                <table>
                    <thead>
                        <tr>
                            <th>N.º venta</th>
                            <th>Fecha</th>
                            <th>Cliente</th>
                            <th>Producto</th>
                            <th>Cantidad</th>
                            <th>Precio unitario</th>
                            <th>Total</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>

                    <tbody>
                    <% for (Venta venta : ventas) { %>
                        <tr>
                            <td>
                                <span class="numero-venta">
                                    #<%= venta.getId() %>
                                </span>
                            </td>

                            <td>
                                <%= venta.getFecha() %>
                            </td>

                            <td>
                                <span class="nombre-principal">
                                    <%= escaparHTML(
                                        venta.getClienteNombre() == null
                                            ? "Sin nombre"
                                            : venta.getClienteNombre()
                                    ) %>
                                </span>
                            </td>

                            <td>
                                <span class="nombre-principal">
                                    <%= escaparHTML(
                                        venta.getProductoNombre() == null
                                            ? "Sin nombre"
                                            : venta.getProductoNombre()
                                    ) %>
                                </span>
                            </td>

                            <td>
                                <span class="cantidad">
                                    <%= venta.getCantidad() %>
                                </span>
                            </td>

                            <td>
                                <%= moneda.format(venta.getPrecioUnitario()) %>
                            </td>

                            <td>
                                <span class="total-venta">
                                    <%= moneda.format(venta.getTotal()) %>
                                </span>
                            </td>

                            <td>
                                <a
                                    class="boton-detalle"
                                    href="<%= contexto %>/admin/ventas?accion=detalle&id=<%= venta.getId() %>">
                                    Ver detalle
                                </a>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>

            <% } %>
        </div>
    </section>

</main>

<footer class="pie">
    © 2026 Rescate Móvil · Sistema de gestión de ventas
</footer>

</body>
</html>