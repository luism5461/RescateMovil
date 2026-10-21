<%-- 
    Document   : nueva-venta
    Created on : 12/10/2026, 10:26:10 a. m.
    Author     : aleja
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="com.rescatemovil.config.Conexion"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>

<%!
    public static class OpcionCliente {
        public int id;
        public String nombre;

        public OpcionCliente(int id, String nombre) {
            this.id = id;
            this.nombre = nombre;
        }
    }

    public static class OpcionProducto {
        public int id;
        public String nombre;
        public java.math.BigDecimal precio;
        public int stock;

        public OpcionProducto(int id, String nombre,
                java.math.BigDecimal precio, int stock) {
            this.id = id;
            this.nombre = nombre;
            this.precio = precio;
            this.stock = stock;
        }
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
        response.sendError(HttpServletResponse.SC_FORBIDDEN,
                "No tienes permisos para registrar ventas.");
        return;
    }

    List<OpcionCliente> clientes = new ArrayList<>();
    List<OpcionProducto> productos = new ArrayList<>();
    String errorCarga = null;

    String sqlClientes =
            "SELECT id, nombre, apellido FROM clientes ORDER BY nombre, apellido";

    String sqlProductos =
            "SELECT id, nombre, precio, stock FROM productos "
            + "WHERE activo = 1 AND stock > 0 ORDER BY nombre";

    try (Connection con = Conexion.getConexion()) {

        try (PreparedStatement ps = con.prepareStatement(sqlClientes);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                clientes.add(new OpcionCliente(
                        rs.getInt("id"),
                        rs.getString("nombre") + " " + rs.getString("apellido")
                ));
            }
        }

        try (PreparedStatement ps = con.prepareStatement(sqlProductos);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                productos.add(new OpcionProducto(
                        rs.getInt("id"),
                        rs.getString("nombre"),
                        rs.getBigDecimal("precio"),
                        rs.getInt("stock")
                ));
            }
        }

    } catch (SQLException e) {
        errorCarga = "No fue posible cargar clientes y productos desde la base de datos.";
        application.log("Error cargando el formulario de ventas.", e);
    }

    NumberFormat moneda = NumberFormat.getCurrencyInstance(
            new Locale("es", "CO"));
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Nueva venta | Rescate Móvil</title>

    <style>
        :root {
            --fondo: #07111f;
            --panel: #101d30;
            --panel-secundario: #14243a;
            --borde: #263b54;
            --texto: #edf5ff;
            --secundario: #9db0c8;
            --cian: #00b4d8;
            --azul: #4361ee;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            padding: 30px 18px;
            background:
                radial-gradient(circle at top right, #142b49 0, transparent 38%),
                var(--fondo);
            color: var(--texto);
            font-family: Arial, Helvetica, sans-serif;
        }

        .contenedor {
            max-width: 900px;
            margin: 0 auto;
        }

        .encabezado {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 25px;
        }

        .logo {
            width: 58px;
            height: 58px;
            object-fit: contain;
            background: white;
            border-radius: 12px;
        }

        h1 {
            margin: 0 0 8px;
            font-size: 28px;
        }

        .subtitulo {
            margin: 0;
            color: var(--secundario);
            font-size: 14px;
        }

        .panel {
            padding: 28px;
            background: rgba(16, 29, 48, 0.96);
            border: 1px solid var(--borde);
            border-radius: 17px;
        }

        .panel h2 {
            margin: 0 0 8px;
            font-size: 21px;
        }

        .ayuda {
            margin: 0 0 25px;
            color: var(--secundario);
            font-size: 14px;
            line-height: 1.6;
        }

        .grupo {
            margin-bottom: 21px;
        }

        label {
            display: block;
            margin-bottom: 9px;
            font-size: 14px;
            font-weight: bold;
        }

        input, select {
            width: 100%;
            min-height: 46px;
            padding: 12px 14px;
            color: var(--texto);
            background: #0a1728;
            border: 1px solid var(--borde);
            border-radius: 9px;
            font-size: 15px;
        }

        select option {
            color: #111827;
            background: white;
        }

        input:focus, select:focus {
            outline: none;
            border-color: var(--cian);
            box-shadow: 0 0 0 3px rgba(0, 180, 216, 0.12);
        }

        .rejilla {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 0 20px;
        }

        .ancho-completo {
            grid-column: 1 / -1;
        }

        .resumen {
            margin: 8px 0 24px;
            padding: 20px;
            background: #0a1728;
            border: 1px solid var(--borde);
            border-radius: 12px;
        }

        .resumen-linea {
            display: flex;
            justify-content: space-between;
            gap: 15px;
            margin-bottom: 13px;
            color: var(--secundario);
            font-size: 14px;
        }

        .resumen-linea:last-child {
            margin-bottom: 0;
        }

        .total {
            padding-top: 14px;
            border-top: 1px solid var(--borde);
            color: var(--texto);
            font-size: 18px;
            font-weight: bold;
        }

        .total strong {
            color: #67e8f9;
            font-size: 24px;
        }

        .botones {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 25px;
        }

        .boton {
            display: inline-block;
            padding: 13px 19px;
            border: 0;
            border-radius: 9px;
            color: white;
            background: var(--panel-secundario);
            text-decoration: none;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
        }

        .principal {
            background: linear-gradient(120deg, var(--cian), var(--azul));
        }

        .boton:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .alerta {
            margin-bottom: 20px;
            padding: 15px;
            border-radius: 9px;
            background: #47251d;
            border: 1px solid #9a4534;
            color: #ffd6cb;
            line-height: 1.5;
        }

        .nota {
            margin-top: 18px;
            color: var(--secundario);
            font-size: 12px;
            line-height: 1.6;
        }

        @media (max-width: 600px) {
            body {
                padding: 18px 12px;
            }

            .panel {
                padding: 20px 15px;
            }

            .rejilla {
                grid-template-columns: 1fr;
            }

            .ancho-completo {
                grid-column: auto;
            }

            h1 {
                font-size: 23px;
            }
        }
    </style>
</head>

<body>
<div class="contenedor">

    <header class="encabezado">
        <img
            class="logo"
            src="<%= request.getContextPath() %>/logo.jpg"
            alt="Rescate Móvil"
            onerror="this.style.display='none'">

        <div>
            <h1>Registrar nueva venta</h1>
            <p class="subtitulo">
                Rescate Móvil · Gestión comercial e inventario
            </p>
        </div>
    </header>

    <main class="panel">
        <h2>Información de la venta</h2>

        <p class="ayuda">
            Selecciona el cliente y el producto. El precio se obtiene
            directamente del inventario y el total se calcula automáticamente.
        </p>

        <% if (errorCarga != null) { %>
            <div class="alerta">
                <%= errorCarga %>
                Revisa la conexión con MySQL y los registros de la base de datos.
            </div>
        <% } %>

        <% if (clientes.isEmpty() && errorCarga == null) { %>
            <div class="alerta">
                No hay clientes registrados. Registra un cliente antes de crear una venta.
            </div>
        <% } %>

        <% if (productos.isEmpty() && errorCarga == null) { %>
            <div class="alerta">
                No hay productos activos con existencias disponibles.
                Revisa el módulo de productos y el inventario.
            </div>
        <% } %>

        <form
            id="formVenta"
            action="<%= request.getContextPath() %>/admin/ventas"
            method="post">

            <div class="rejilla">

                <div class="grupo ancho-completo">
                    <label for="clienteId">Cliente *</label>

                    <select id="clienteId" name="clienteId" required>
                        <option value="">Selecciona un cliente</option>

                        <% for (OpcionCliente cliente : clientes) { %>
                            <option value="<%= cliente.id %>">
                                <%= cliente.nombre %>
                            </option>
                        <% } %>
                    </select>
                </div>

                <div class="grupo ancho-completo">
                    <label for="productoId">Producto *</label>

                    <select id="productoId" name="productoId" required>
                        <option value="">Selecciona un producto</option>

                        <% for (OpcionProducto producto : productos) { %>
                            <option
                                value="<%= producto.id %>"
                                data-precio="<%= producto.precio %>"
                                data-stock="<%= producto.stock %>">

                                <%= producto.nombre %> —
                                <%= moneda.format(producto.precio) %> —
                                Stock: <%= producto.stock %>
                            </option>
                        <% } %>
                    </select>
                </div>

                <div class="grupo">
                    <label for="cantidad">Cantidad *</label>

                    <input
                        type="number"
                        id="cantidad"
                        name="cantidad"
                        min="1"
                        step="1"
                        value="1"
                        required>
                </div>

                <div class="grupo">
                    <label for="fecha">Fecha de venta *</label>

                    <input
                        type="date"
                        id="fecha"
                        name="fecha"
                        value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>"
                        required>
                </div>

            </div>

            <section class="resumen">
                <div class="resumen-linea">
                    <span>Precio unitario</span>
                    <strong id="precioUnitario">$ 0</strong>
                </div>

                <div class="resumen-linea">
                    <span>Existencias disponibles</span>
                    <strong id="stockDisponible">—</strong>
                </div>

                <div class="resumen-linea total">
                    <span>Total de la venta</span>
                    <strong id="totalVenta">$ 0</strong>
                </div>
            </section>

            <div class="botones">
                <button
                    type="submit"
                    id="btnRegistrar"
                    class="boton principal"
                    <%= (clientes.isEmpty() || productos.isEmpty() || errorCarga != null) ? "disabled" : "" %>>
                    Registrar venta
                </button>

                <a
                    class="boton"
                    href="<%= request.getContextPath() %>/admin/ventas">
                    Cancelar
                </a>
            </div>

            <p class="nota">
                * Campos obligatorios. Al registrar la venta, el sistema
                utilizará el precio almacenado en MySQL y descontará la
                cantidad correspondiente del inventario.
            </p>

        </form>
    </main>
</div>

<script>
    const selectorProducto = document.getElementById("productoId");
    const campoCantidad = document.getElementById("cantidad");
    const precioUnitario = document.getElementById("precioUnitario");
    const stockDisponible = document.getElementById("stockDisponible");
    const totalVenta = document.getElementById("totalVenta");
    const botonRegistrar = document.getElementById("btnRegistrar");
    const formulario = document.getElementById("formVenta");

    const formatoMoneda = new Intl.NumberFormat("es-CO", {
        style: "currency",
        currency: "COP",
        maximumFractionDigits: 2
    });

    function actualizarResumen() {
        const opcion = selectorProducto.options[
            selectorProducto.selectedIndex
        ];

        const precio = Number(opcion?.dataset?.precio || 0);
        const stock = Number(opcion?.dataset?.stock || 0);
        const cantidad = Number(campoCantidad.value || 0);

        precioUnitario.textContent = formatoMoneda.format(precio);
        stockDisponible.textContent =
            opcion && opcion.value ? stock : "—";

        totalVenta.textContent =
            formatoMoneda.format(precio * cantidad);

        campoCantidad.max = stock > 0 ? stock : "";

        const cantidadValida =
            Number.isInteger(cantidad)
            && cantidad > 0
            && cantidad <= stock;

        botonRegistrar.disabled =
            !opcion.value || !cantidadValida;
    }

    selectorProducto.addEventListener("change", actualizarResumen);
    campoCantidad.addEventListener("input", actualizarResumen);

    formulario.addEventListener("submit", function (evento) {
        const opcion = selectorProducto.options[
            selectorProducto.selectedIndex
        ];

        const stock = Number(opcion?.dataset?.stock || 0);
        const cantidad = Number(campoCantidad.value);

        if (!opcion.value || !Number.isInteger(cantidad)
                || cantidad <= 0 || cantidad > stock) {
            evento.preventDefault();
            alert("Selecciona un producto y una cantidad válida según el stock disponible.");
        }
    });

    actualizarResumen();
</script>

</body>
</html>