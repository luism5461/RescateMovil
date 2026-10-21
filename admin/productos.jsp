<%-- 
    Document   : productos
    Created on : 11/10/2026, 10:07:09 p. m.
    Author     : aleja
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.rescatemovil.modelo.Producto"%>
<%@page import="java.math.BigDecimal"%>

<%!
    private String escaparHTML(String valor) {
        if (valor == null) {
            return "";
        }

        return valor.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<%
    String contextPath = request.getContextPath();

    Object usuarioSesion = session.getAttribute("usuario");
    Object rolSesion = session.getAttribute("rol");

    if (usuarioSesion == null || rolSesion == null
            || !"admin".equalsIgnoreCase(String.valueOf(rolSesion))) {
        response.sendRedirect(contextPath + "/login.jsp");
        return;
    }

    List<Producto> productos =
            (List<Producto>) request.getAttribute("productos");

    if (productos == null) {
        productos = new java.util.ArrayList<Producto>();
    }

    String termino = request.getParameter("buscar");
    String mensaje = request.getParameter("mensaje");
    String error = request.getParameter("error");

    int totalProductos = productos.size();
    int totalStock = 0;
    int productosActivos = 0;

    BigDecimal valorInventario = BigDecimal.ZERO;

    for (Producto p : productos) {
        totalStock += p.getStock();

        if (p.isActivo()) {
            productosActivos++;
        }

        if (p.getPrecio() != null) {
            valorInventario = valorInventario.add(
                    p.getPrecio().multiply(
                            BigDecimal.valueOf(p.getStock())));
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Gestión de productos | Rescate Móvil</title>

    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            min-height: 100vh;
            padding: 28px 18px;
            font-family: Arial, Helvetica, sans-serif;
            color: #eaf2ff;
            background:
                radial-gradient(circle at top left, #142d4d 0, transparent 35%),
                linear-gradient(135deg, #07111f, #0b1729 60%, #101d35);
        }

        .contenedor {
            max-width: 1250px;
            margin: 0 auto;
        }

        .barra-superior {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            flex-wrap: wrap;
            margin-bottom: 28px;
        }

        .marca {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .icono {
            width: 50px;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 14px;
            background: linear-gradient(135deg, #00b4d8, #4361ee);
            font-size: 25px;
        }

        .marca h1 {
            font-size: 22px;
        }

        .marca p {
            margin-top: 5px;
            color: #91a6c5;
            font-size: 13px;
        }

        .volver {
            color: #8bdcf6;
            text-decoration: none;
            padding: 11px 15px;
            border: 1px solid #294361;
            border-radius: 10px;
        }

        .volver:hover {
            background: #142b47;
        }

        .encabezado {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 25px;
        }

        .encabezado h2 {
            font-size: 30px;
            margin-bottom: 9px;
        }

        .encabezado p {
            color: #9fb1cb;
            line-height: 1.6;
        }

        .boton {
            display: inline-block;
            padding: 13px 17px;
            border: none;
            border-radius: 10px;
            text-decoration: none;
            text-align: center;
            font-weight: bold;
            cursor: pointer;
            font-size: 14px;
        }

        .boton-principal {
            color: #fff;
            background: linear-gradient(135deg, #087ea4, #4361ee);
        }

        .boton-principal:hover {
            filter: brightness(1.12);
        }

        .estadisticas {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 16px;
            margin-bottom: 24px;
        }

        .estadistica {
            padding: 21px;
            border: 1px solid #203955;
            border-radius: 16px;
            background: rgba(14, 29, 49, 0.92);
        }

        .estadistica p {
            color: #9fb1cb;
            font-size: 13px;
            margin-bottom: 12px;
        }

        .estadistica h3 {
            font-size: 25px;
            overflow-wrap: anywhere;
        }

        .panel {
            padding: 23px;
            border: 1px solid #203955;
            border-radius: 18px;
            background: rgba(14, 29, 49, 0.94);
        }

        .busqueda {
            display: flex;
            gap: 10px;
            margin-bottom: 22px;
        }

        .busqueda input {
            flex: 1;
            min-width: 0;
            padding: 13px 15px;
            border: 1px solid #2a4565;
            border-radius: 10px;
            outline: none;
            background: #091628;
            color: #f2f7ff;
            font-size: 14px;
        }

        .busqueda input:focus {
            border-color: #00b4d8;
        }

        .boton-buscar {
            color: #fff;
            background: #1c4770;
        }

        .boton-limpiar {
            color: #dbe8fb;
            background: #1a2c43;
            border: 1px solid #304966;
        }

        .alerta {
            padding: 13px 15px;
            border-radius: 10px;
            margin-bottom: 18px;
            line-height: 1.5;
        }

        .exito {
            color: #b8f8d0;
            background: rgba(25, 135, 84, 0.13);
            border: 1px solid #286b4d;
        }

        .error {
            color: #ffc5c5;
            background: rgba(220, 53, 69, 0.13);
            border: 1px solid #813742;
        }

        .tabla-contenedor {
            width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            min-width: 900px;
            border-collapse: collapse;
        }

        th {
            padding: 15px 12px;
            text-align: left;
            color: #8bdcf6;
            background: #10223a;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.4px;
        }

        td {
            padding: 15px 12px;
            border-bottom: 1px solid #20344d;
            color: #dbe8fb;
            font-size: 13px;
            vertical-align: middle;
        }

        tbody tr:hover {
            background: rgba(42, 69, 101, 0.17);
        }

        .nombre-producto {
            font-weight: bold;
            color: #fff;
        }

        .descripcion {
            display: block;
            max-width: 230px;
            margin-top: 5px;
            color: #91a6c5;
            overflow-wrap: anywhere;
            line-height: 1.4;
        }

        .precio {
            font-weight: bold;
            color: #8bdcf6;
            white-space: nowrap;
        }

        .estado {
            display: inline-block;
            padding: 6px 9px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: bold;
        }

        .activo {
            color: #b8f8d0;
            background: rgba(25, 135, 84, 0.18);
        }

        .inactivo {
            color: #ffc5c5;
            background: rgba(220, 53, 69, 0.18);
        }

        .acciones {
            display: flex;
            align-items: center;
            gap: 7px;
            flex-wrap: wrap;
        }

        .boton-editar {
            padding: 8px 10px;
            color: #cce7ff;
            background: #1b3a5a;
            font-size: 12px;
        }

        .boton-eliminar {
            padding: 8px 10px;
            color: #ffc5c5;
            background: #542b39;
            font-size: 12px;
        }

        .sin-resultados {
            padding: 35px 15px;
            text-align: center;
            color: #91a6c5;
            line-height: 1.8;
        }

        .pie {
            margin-top: 22px;
            text-align: center;
            color: #7187a6;
            font-size: 12px;
        }

        @media (max-width: 900px) {
            .estadisticas {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 520px) {
            body {
                padding: 20px 12px;
            }

            .estadisticas {
                grid-template-columns: 1fr 1fr;
                gap: 10px;
            }

            .estadistica {
                padding: 15px;
            }

            .estadistica h3 {
                font-size: 20px;
            }

            .encabezado h2 {
                font-size: 25px;
            }

            .panel {
                padding: 15px;
            }

            .busqueda {
                flex-wrap: wrap;
            }

            .busqueda input {
                flex-basis: 100%;
            }

            .busqueda .boton {
                flex: 1;
            }
        }
    </style>
</head>

<body>
<main class="contenedor">

    <header class="barra-superior">
        <div class="marca">
            <div class="icono">📱</div>
            <div>
                <h1>Rescate Móvil</h1>
                <p>Sistema de gestión técnica</p>
            </div>
        </div>

        <a class="volver"
           href="<%= contextPath %>/admin/index.jsp">
            ← Panel de administrador
        </a>
    </header>

    <section class="encabezado">
        <div>
            <h2>Gestión de productos</h2>
            <p>Administra el catálogo, los precios y las existencias.</p>
        </div>

        <a class="boton boton-principal"
           href="<%= contextPath %>/admin/nuevo-producto.jsp">
            + Nuevo producto
        </a>
    </section>

    <section class="estadisticas">
        <article class="estadistica">
            <p>Productos encontrados</p>
            <h3><%= totalProductos %></h3>
        </article>

        <article class="estadistica">
            <p>Unidades en stock</p>
            <h3><%= totalStock %></h3>
        </article>

        <article class="estadistica">
            <p>Productos activos</p>
            <h3><%= productosActivos %></h3>
        </article>

        <article class="estadistica">
            <p>Valor del inventario listado</p>
            <h3>$<%= valorInventario.toPlainString() %></h3>
        </article>
    </section>

    <section class="panel">

        <% if ("registrado".equals(mensaje)) { %>
            <div class="alerta exito">
                El producto se registró correctamente.
            </div>
        <% } else if ("actualizado".equals(mensaje)) { %>
            <div class="alerta exito">
                Los datos del producto se actualizaron correctamente.
            </div>
        <% } else if ("eliminado".equals(mensaje)) { %>
            <div class="alerta exito">
                El producto se eliminó correctamente.
            </div>
        <% } %>

        <% if (error != null) { %>
            <div class="alerta error">
                <% if ("id".equals(error)) { %>
                    El identificador del producto no es válido.
                <% } else if ("no_encontrado".equals(error)) { %>
                    No se encontró el producto solicitado.
                <% } else if ("eliminar".equals(error)) { %>
                    No fue posible eliminar el producto. Comprueba si está
                    relacionado con otros registros.
                <% } else if ("actualizar".equals(error)) { %>
                    No fue posible actualizar el producto.
                <% } else { %>
                    Ocurrió un problema al procesar la solicitud.
                    Revisa los datos e inténtalo nuevamente.
                <% } %>
            </div>
        <% } %>

        <form class="busqueda"
              action="<%= contextPath %>/admin/productos"
              method="get">

            <input
                type="search"
                name="buscar"
                placeholder="Buscar por nombre, descripción o categoría..."
                value="<%= escaparHTML(termino) %>">

            <button class="boton boton-buscar" type="submit">
                Buscar
            </button>

            <a class="boton boton-limpiar"
               href="<%= contextPath %>/admin/productos">
                Limpiar
            </a>
        </form>

        <div class="tabla-contenedor">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Producto</th>
                        <th>Categoría</th>
                        <th>Precio</th>
                        <th>Stock</th>
                        <th>Estado</th>
                        <th>Acciones</th>
                    </tr>
                </thead>

                <tbody>
                <% if (productos.isEmpty()) { %>
                    <tr>
                        <td colspan="7">
                            <div class="sin-resultados">
                                <h3>No hay productos para mostrar</h3>
                                <p>
                                    Registra un producto nuevo o cambia
                                    el término de búsqueda.
                                </p>
                            </div>
                        </td>
                    </tr>
                <% } else { %>
                    <% for (Producto p : productos) { %>
                    <tr>
                        <td><%= p.getId() %></td>

                        <td>
                            <span class="nombre-producto">
                                <%= escaparHTML(p.getNombre()) %>
                            </span>
                            <span class="descripcion">
                                <%= escaparHTML(p.getDescripcion()) %>
                            </span>
                        </td>

                        <td>
                            <%= escaparHTML(p.getCategoria() == null
                                    || p.getCategoria().trim().isEmpty()
                                    ? "Sin categoría" : p.getCategoria()) %>
                        </td>

                        <td class="precio">
                            $<%= p.getPrecio() == null
                                    ? "0.00" : p.getPrecio().toPlainString() %>
                        </td>

                        <td><%= p.getStock() %></td>

                        <td>
                            <% if (p.isActivo()) { %>
                                <span class="estado activo">Activo</span>
                            <% } else { %>
                                <span class="estado inactivo">Inactivo</span>
                            <% } %>
                        </td>

                        <td>
                            <div class="acciones">
                                <a class="boton boton-editar"
                                   href="<%= contextPath %>/admin/productos?accion=editar&id=<%= p.getId() %>">
                                    Editar
                                </a>

                                <form
                                    action="<%= contextPath %>/admin/productos"
                                    method="post"
                                    onsubmit="return confirm('¿Estás seguro de eliminar este producto? Esta acción no se puede deshacer.');">

                                    <input type="hidden"
                                           name="accion"
                                           value="eliminar">

                                    <input type="hidden"
                                           name="id"
                                           value="<%= p.getId() %>">

                                    <button class="boton boton-eliminar"
                                            type="submit">
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
        © 2026 Rescate Móvil | Gestión de inventario
    </footer>

</main>
</body>
</html>
