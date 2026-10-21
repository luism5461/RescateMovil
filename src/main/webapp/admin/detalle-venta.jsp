<%-- 
    Document   : detalle-venta
    Created on : 12/10/2026, 10:37:57 a. m.
    Author     : aleja
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.rescatemovil.modelo.Venta"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>

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
            "No tienes permisos para consultar esta venta."
        );
        return;
    }

    Venta venta = (Venta) request.getAttribute("venta");

    if (venta == null) {
        response.sendRedirect(request.getContextPath() + "/admin/ventas");
        return;
    }

    NumberFormat moneda = NumberFormat.getCurrencyInstance(
        new Locale("es", "CO")
    );
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Detalle de venta | Rescate Móvil</title>

    <style>
        :root {
            --fondo: #07111f;
            --panel: #101d30;
            --panel-secundario: #14243a;
            --borde: #263b54;
            --texto: #edf5ff;
            --texto-secundario: #9db0c8;
            --cian: #00b4d8;
            --azul: #4361ee;
            --verde: #22c55e;
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
            width: 100%;
            max-width: 900px;
            margin: 0 auto;
        }

        .encabezado {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 28px;
        }

        .logo {
            width: 58px;
            height: 58px;
            object-fit: contain;
            background: white;
            border-radius: 12px;
        }

        h1 {
            margin: 0 0 7px;
            font-size: 28px;
        }

        .subtitulo {
            margin: 0;
            color: var(--texto-secundario);
            font-size: 14px;
        }

        .panel {
            padding: 26px;
            border: 1px solid var(--borde);
            border-radius: 16px;
            background: rgba(16, 29, 48, 0.96);
        }

        .cabecera-venta {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 12px;
            padding-bottom: 22px;
            margin-bottom: 22px;
            border-bottom: 1px solid var(--borde);
        }

        .numero {
            margin: 0;
            font-size: 20px;
        }

        .etiqueta {
            display: inline-block;
            padding: 8px 12px;
            color: #bbf7d0;
            background: #123b2b;
            border: 1px solid #23764b;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }

        .datos {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 16px;
        }

        .dato {
            padding: 18px;
            background: var(--panel-secundario);
            border: 1px solid var(--borde);
            border-radius: 11px;
            overflow-wrap: anywhere;
        }

        .dato span {
            display: block;
            margin-bottom: 10px;
            color: var(--texto-secundario);
            font-size: 13px;
        }

        .dato strong {
            font-size: 16px;
        }

        .dato-total {
            grid-column: 1 / -1;
            background: linear-gradient(
                120deg,
                rgba(0, 180, 216, 0.12),
                rgba(67, 97, 238, 0.16)
            );
            border-color: #27627e;
        }

        .dato-total strong {
            color: #67e8f9;
            font-size: 29px;
        }

        .acciones {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 24px;
        }

        .boton {
            display: inline-block;
            padding: 12px 17px;
            color: white;
            background: var(--panel-secundario);
            border-radius: 9px;
            text-decoration: none;
            font-size: 14px;
            font-weight: bold;
        }

        .boton-principal {
            background: linear-gradient(120deg, var(--cian), var(--azul));
        }

        .nota {
            margin-top: 22px;
            color: var(--texto-secundario);
            font-size: 13px;
            line-height: 1.6;
        }

        @media (max-width: 560px) {
            body {
                padding: 20px 12px;
            }

            .panel {
                padding: 18px;
            }

            .datos {
                grid-template-columns: 1fr;
            }

            .dato-total {
                grid-column: auto;
            }

            h1 {
                font-size: 22px;
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
            alt="Logo Rescate Móvil"
            onerror="this.style.display='none'">

        <div>
            <h1>Detalle de venta</h1>
            <p class="subtitulo">
                Información de la operación registrada en Rescate Móvil.
            </p>
        </div>
    </header>

    <main class="panel">

        <div class="cabecera-venta">
            <h2 class="numero">
                Venta n.º <%= venta.getId() %>
            </h2>

            <span class="etiqueta">Venta registrada</span>
        </div>

        <section class="datos">

            <div class="dato">
                <span>Fecha de la venta</span>
                <strong><%= venta.getFecha() %></strong>
            </div>

            <div class="dato">
                <span>Número de operación</span>
                <strong>#<%= venta.getId() %></strong>
            </div>

            <div class="dato">
                <span>Cliente</span>
                <strong>
                    <%= venta.getClienteNombre() == null
                        ? "Cliente no disponible"
                        : venta.getClienteNombre() %>
                </strong>
            </div>

            <div class="dato">
                <span>Producto</span>
                <strong>
                    <%= venta.getProductoNombre() == null
                        ? "Producto no disponible"
                        : venta.getProductoNombre() %>
                </strong>
            </div>

            <div class="dato">
                <span>Cantidad vendida</span>
                <strong><%= venta.getCantidad() %> unidad(es)</strong>
            </div>

            <div class="dato">
                <span>Precio por unidad</span>
                <strong>
                    <%= moneda.format(venta.getPrecioUnitario()) %>
                </strong>
            </div>

            <div class="dato dato-total">
                <span>Valor total de la venta</span>
                <strong><%= moneda.format(venta.getTotal()) %></strong>
            </div>

        </section>

        <div class="acciones">
            <a class="boton boton-principal"
               href="<%= request.getContextPath() %>/admin/ventas">
                ← Volver al historial
            </a>

            <a class="boton"
               href="<%= request.getContextPath() %>/admin/index.jsp">
                Panel administrativo
            </a>
        </div>

        <p class="nota">
            Esta pantalla permite consultar la información de la venta.
            No modifica el registro ni las existencias del inventario.
        </p>

    </main>
</div>
</body>
</html>
