<%-- 
    Document   : ditar-producto
    Created on : 11/10/2026, 10:08:41 p. m.
    Author     : aleja
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.rescatemovil.modelo.Producto"%>

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

    Producto producto = (Producto) request.getAttribute("producto");

    if (producto == null) {
        response.sendRedirect(contextPath + "/admin/productos?error=no_encontrado");
        return;
    }

    String error = request.getParameter("error");
    String categoriaActual = producto.getCategoria() == null
            ? "" : producto.getCategoria();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Editar producto | Rescate Móvil</title>

    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            min-height: 100vh;
            padding: 30px 16px;
            font-family: Arial, Helvetica, sans-serif;
            color: #eaf2ff;
            background:
                radial-gradient(circle at top left, #142d4d 0, transparent 35%),
                linear-gradient(135deg, #07111f, #0b1729 60%, #101d35);
        }

        .contenedor {
            max-width: 800px;
            margin: 0 auto;
        }

        .barra-superior {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            margin-bottom: 25px;
            flex-wrap: wrap;
        }

        .marca {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .icono {
            width: 48px;
            height: 48px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 14px;
            background: linear-gradient(135deg, #00b4d8, #4361ee);
            font-size: 25px;
        }

        .marca h1 {
            font-size: 21px;
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

        .tarjeta {
            padding: 30px;
            border: 1px solid #203955;
            border-radius: 20px;
            background: rgba(14, 29, 49, 0.94);
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.25);
        }

        .encabezado {
            margin-bottom: 25px;
        }

        .encabezado h2 {
            font-size: 27px;
            margin-bottom: 10px;
        }

        .encabezado p {
            color: #9fb1cb;
            line-height: 1.6;
        }

        .identificador {
            display: inline-block;
            margin-top: 13px;
            padding: 7px 11px;
            border-radius: 8px;
            background: #142d49;
            color: #75ddfa;
            font-size: 13px;
        }

        .alerta {
            padding: 13px 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            color: #ffc5c5;
            background: rgba(220, 53, 69, 0.13);
            border: 1px solid #813742;
            line-height: 1.5;
        }

        .grupo {
            margin-bottom: 21px;
        }

        .fila {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
        }

        label {
            display: block;
            margin-bottom: 9px;
            color: #dbe8fb;
            font-size: 14px;
            font-weight: bold;
        }

        input,
        textarea,
        select {
            width: 100%;
            padding: 14px;
            border: 1px solid #2a4565;
            border-radius: 10px;
            outline: none;
            background: #091628;
            color: #f2f7ff;
            font-family: inherit;
            font-size: 15px;
        }

        textarea {
            min-height: 120px;
            resize: vertical;
        }

        input:focus,
        textarea:focus,
        select:focus {
            border-color: #00b4d8;
            box-shadow: 0 0 0 3px rgba(0, 180, 216, 0.12);
        }

        .ayuda {
            display: block;
            margin-top: 7px;
            color: #8297b5;
            font-size: 12px;
        }

        .estado-contenedor {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 15px;
            border: 1px solid #2a4565;
            border-radius: 10px;
            background: #091628;
        }

        .estado-contenedor input {
            width: 18px;
            height: 18px;
            accent-color: #00b4d8;
            cursor: pointer;
        }

        .estado-contenedor label {
            margin: 0;
            cursor: pointer;
        }

        .acciones {
            display: flex;
            gap: 12px;
            margin-top: 28px;
            flex-wrap: wrap;
        }

        .boton {
            display: inline-block;
            flex: 1;
            min-width: 160px;
            padding: 14px 18px;
            border: none;
            border-radius: 10px;
            text-align: center;
            text-decoration: none;
            font-size: 15px;
            font-weight: bold;
            cursor: pointer;
        }

        .guardar {
            color: #fff;
            background: linear-gradient(135deg, #087ea4, #4361ee);
        }

        .guardar:hover {
            filter: brightness(1.12);
        }

        .cancelar {
            color: #dbe8fb;
            background: #1a2c43;
            border: 1px solid #304966;
        }

        .cancelar:hover {
            background: #253d59;
        }

        @media (max-width: 560px) {
            .tarjeta {
                padding: 22px 17px;
            }

            .fila {
                grid-template-columns: 1fr;
                gap: 0;
            }

            .boton {
                width: 100%;
                flex-basis: 100%;
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
                <p>Administración de inventario</p>
            </div>
        </div>

        <a class="volver"
           href="<%= contextPath %>/admin/productos">
            ← Volver a productos
        </a>
    </header>

    <section class="tarjeta">

        <div class="encabezado">
            <h2>Editar producto</h2>
            <p>Modifica los datos del producto seleccionado.</p>

            <span class="identificador">
                Producto ID: <%= producto.getId() %>
            </span>
        </div>

        <% if ("datos".equals(error)) { %>
            <div class="alerta">
                Verifica los datos. El precio y el stock deben ser válidos
                y no negativos.
            </div>
        <% } else if (error != null) { %>
            <div class="alerta">
                No fue posible actualizar el producto.
                Comprueba los datos e inténtalo nuevamente.
            </div>
        <% } %>

        <form action="<%= contextPath %>/admin/productos"
              method="post">

            <input type="hidden" name="accion" value="actualizar">
            <input type="hidden" name="id" value="<%= producto.getId() %>">

            <div class="grupo">
                <label for="nombre">Nombre del producto *</label>
                <input
                    type="text"
                    id="nombre"
                    name="nombre"
                    maxlength="180"
                    value="<%= escaparHTML(producto.getNombre()) %>"
                    required>
            </div>

            <div class="grupo">
                <label for="descripcion">Descripción *</label>
                <textarea
                    id="descripcion"
                    name="descripcion"
                    required><%= escaparHTML(producto.getDescripcion()) %></textarea>
            </div>

            <div class="fila">
                <div class="grupo">
                    <label for="precio">Precio en pesos colombianos *</label>
                    <input
                        type="number"
                        id="precio"
                        name="precio"
                        min="0"
                        max="9999999999.99"
                        step="0.01"
                        value="<%= producto.getPrecio() == null
                                ? "0.00" : producto.getPrecio().toPlainString() %>"
                        required>
                </div>

                <div class="grupo">
                    <label for="stock">Cantidad en inventario *</label>
                    <input
                        type="number"
                        id="stock"
                        name="stock"
                        min="0"
                        max="4294967295"
                        step="1"
                        value="<%= producto.getStock() %>"
                        required>
                </div>
            </div>

            <div class="grupo">
                <label for="categoria">Categoría</label>
                <select id="categoria" name="categoria">
                    <option value=""
                        <%= categoriaActual.isEmpty() ? "selected" : "" %>>
                        Sin categoría
                    </option>

                    <option value="Pantallas"
                        <%= "Pantallas".equals(categoriaActual) ? "selected" : "" %>>
                        Pantallas
                    </option>

                    <option value="Baterías"
                        <%= "Baterías".equals(categoriaActual) ? "selected" : "" %>>
                        Baterías
                    </option>

                    <option value="Cargadores"
                        <%= "Cargadores".equals(categoriaActual) ? "selected" : "" %>>
                        Cargadores
                    </option>

                    <option value="Accesorios"
                        <%= "Accesorios".equals(categoriaActual) ? "selected" : "" %>>
                        Accesorios
                    </option>

                    <option value="Repuestos"
                        <%= "Repuestos".equals(categoriaActual) ? "selected" : "" %>>
                        Repuestos
                    </option>

                    <option value="Herramientas"
                        <%= "Herramientas".equals(categoriaActual) ? "selected" : "" %>>
                        Herramientas
                    </option>

                    <option value="Otros"
                        <%= "Otros".equals(categoriaActual) ? "selected" : "" %>>
                        Otros
                    </option>
                </select>
            </div>

            <div class="grupo">
                <label>Estado del producto</label>

                <div class="estado-contenedor">
                    <input
                        type="checkbox"
                        id="activo"
                        name="activo"
                        value="true"
                        <%= producto.isActivo() ? "checked" : "" %>>

                    <label for="activo">
                        Producto activo y disponible en el sistema
                    </label>
                </div>

                <span class="ayuda">
                    Desmarca esta opción para guardar el producto como inactivo.
                </span>
            </div>

            <div class="acciones">
                <button type="submit" class="boton guardar">
                    Guardar cambios
                </button>

                <a href="<%= contextPath %>/admin/productos"
                   class="boton cancelar">
                    Cancelar
                </a>
            </div>

        </form>

    </section>
</main>
</body>
</html>
