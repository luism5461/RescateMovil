<%-- 
    Document   : editar-reparacion
    Created on : 11/10/2026, 10:32:28 p. m.
    Author     : aleja
--%>

<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.rescatemovil.modelo.Reparacion"%>
<%@page import="com.rescatemovil.modelo.cliente"%>
<%@page import="com.rescatemovil.modelo.Tecnico"%>

<%
    request.setCharacterEncoding("UTF-8");

    if (session.getAttribute("usuario") == null
            || !"admin".equalsIgnoreCase(
                String.valueOf(session.getAttribute("rol")))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Reparacion reparacion =
        (Reparacion) request.getAttribute("reparacion");

    if (reparacion == null) {
        response.sendRedirect(
            request.getContextPath() + "/admin/reparaciones"
        );
        return;
    }

    List<cliente> clientes =
        (List<cliente>) request.getAttribute("clientes");

    List<Tecnico> tecnicos =
        (List<Tecnico>) request.getAttribute("tecnicos");

    List<String> estados =
        (List<String>) request.getAttribute("estados");

    List<String> metodosPago =
        (List<String>) request.getAttribute("metodosPago");

    if (clientes == null) {
        clientes = new java.util.ArrayList<cliente>();
    }

    if (tecnicos == null) {
        tecnicos = new java.util.ArrayList<Tecnico>();
    }

    if (estados == null) {
        estados = java.util.Arrays.asList(
            "Recibido", "En proceso", "Listo para recoger",
            "Finalizado", "Entregado"
        );
    }

    if (metodosPago == null) {
        metodosPago = java.util.Arrays.asList(
            "Nequi", "Daviplata", "PSE / Tarjeta", "Efectivo"
        );
    }

    String error = request.getParameter("error");

    String costo = reparacion.getCosto() == null
        ? "0.00"
        : reparacion.getCosto().toPlainString();

    String fechaIngreso = reparacion.getFechaIngreso() == null
        ? ""
        : reparacion.getFechaIngreso().toString();

    String fechaEntrega = reparacion.getFechaEntrega() == null
        ? ""
        : reparacion.getFechaEntrega().toString();

    String metodoActual = reparacion.getMetodoPago() == null
        ? ""
        : reparacion.getMetodoPago();

    String marca = reparacion.getMarca() == null
        ? ""
        : reparacion.getMarca();

    String modelo = reparacion.getModelo() == null
        ? ""
        : reparacion.getModelo();

    String imei = reparacion.getImei() == null
        ? ""
        : reparacion.getImei();

    String serialEquipo = reparacion.getSerialEquipo() == null
        ? ""
        : reparacion.getSerialEquipo();

    String color = reparacion.getColor() == null
        ? ""
        : reparacion.getColor();

    String almacenamiento = reparacion.getAlmacenamiento() == null
        ? ""
        : reparacion.getAlmacenamiento();

    String estadoFisico = reparacion.getEstadoFisico() == null
        ? ""
        : reparacion.getEstadoFisico();

    String accesorios = reparacion.getAccesorios() == null
        ? ""
        : reparacion.getAccesorios();

    String diagnostico = reparacion.getDiagnostico() == null
        ? ""
        : reparacion.getDiagnostico();

    String observaciones = reparacion.getObservaciones() == null
        ? ""
        : reparacion.getObservaciones();

    String equipo = reparacion.getEquipo() == null
        ? ""
        : reparacion.getEquipo();

    String falla = reparacion.getFalla() == null
        ? ""
        : reparacion.getFalla();

    String estadoActual = reparacion.getEstado() == null
        ? "Recibido"
        : reparacion.getEstado();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Editar reparación | Rescate Móvil</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, Helvetica, sans-serif;
            background: #f1f5f9;
            color: #172033;
        }

        .barra {
            background: #07111f;
            color: white;
            padding: 20px 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }

        .marca {
            font-size: 23px;
            font-weight: bold;
        }

        .marca span {
            color: #00b4d8;
        }

        .volver {
            color: white;
            text-decoration: none;
            border: 1px solid #526176;
            border-radius: 8px;
            padding: 10px 14px;
        }

        .contenedor {
            max-width: 1050px;
            margin: 35px auto;
            padding: 0 18px;
        }

        .encabezado {
            margin-bottom: 24px;
        }

        h1 {
            margin: 0 0 8px;
            font-size: 30px;
        }

        .subtitulo {
            color: #64748b;
            line-height: 1.5;
        }

        .identificador {
            display: inline-block;
            margin-top: 8px;
            padding: 7px 12px;
            border-radius: 8px;
            background: #dbeafe;
            color: #1d4ed8;
            font-weight: bold;
            font-size: 13px;
        }

        .formulario {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 22px #0000000b;
        }

        .seccion {
            margin-bottom: 28px;
        }

        .seccion h2 {
            font-size: 18px;
            margin: 0 0 18px;
            padding-bottom: 12px;
            border-bottom: 1px solid #e2e8f0;
            color: #075985;
        }

        .campos {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 18px;
        }

        .campo {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .campo.completo {
            grid-column: 1 / -1;
        }

        label {
            font-size: 13px;
            font-weight: bold;
            color: #334155;
        }

        input, select, textarea {
            width: 100%;
            padding: 12px;
            font-family: inherit;
            font-size: 14px;
            color: #172033;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            background: white;
        }

        textarea {
            min-height: 100px;
            resize: vertical;
        }

        input:focus, select:focus, textarea:focus {
            outline: none;
            border-color: #087ea4;
            box-shadow: 0 0 0 3px #087ea41c;
        }

        .pago {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 14px;
            background: #f8fafc;
            border-radius: 8px;
        }

        .pago input {
            width: 18px;
            height: 18px;
        }

        .pago label {
            cursor: pointer;
        }

        .ayuda {
            color: #64748b;
            font-size: 12px;
            line-height: 1.5;
        }

        .mensaje {
            padding: 14px;
            border-radius: 8px;
            margin-bottom: 20px;
            background: #fee2e2;
            color: #991b1b;
            line-height: 1.5;
        }

        .acciones {
            display: flex;
            justify-content: flex-end;
            flex-wrap: wrap;
            gap: 12px;
            border-top: 1px solid #e2e8f0;
            padding-top: 22px;
        }

        .boton {
            display: inline-block;
            padding: 12px 18px;
            border: none;
            border-radius: 8px;
            text-decoration: none;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
        }

        .guardar {
            background: #087ea4;
            color: white;
        }

        .guardar:hover {
            background: #066584;
        }

        .cancelar {
            background: #e2e8f0;
            color: #172033;
        }

        footer {
            text-align: center;
            color: #64748b;
            padding: 25px;
            font-size: 13px;
        }

        @media (max-width: 650px) {
            .campos {
                grid-template-columns: 1fr;
            }

            .campo.completo {
                grid-column: auto;
            }

            .formulario {
                padding: 20px;
            }

            h1 {
                font-size: 25px;
            }

            .acciones .boton {
                width: 100%;
                text-align: center;
            }
        }
    </style>
</head>

<body>

<header class="barra">
    <div class="marca">Rescate <span>Móvil</span></div>

    <a class="volver"
       href="<%= request.getContextPath() %>/admin/reparaciones">
        ← Volver a reparaciones
    </a>
</header>

<main class="contenedor">

    <div class="encabezado">
        <h1>Editar reparación</h1>

        <p class="subtitulo">
            Revisa y actualiza la información del dispositivo y del servicio.
        </p>

        <div class="identificador">
            Código: <%= reparacion.getCodigo() == null
                ? "Sin código"
                : reparacion.getCodigo() %>
        </div>
    </div>

    <% if ("datos".equals(error)) { %>
        <div class="mensaje">
            No se pudieron guardar los cambios. Revisa los campos
            obligatorios, las fechas, el costo y el método de pago.
        </div>
    <% } else if ("actualizar".equals(error)) { %>
        <div class="mensaje">
            No fue posible actualizar la reparación en la base de datos.
        </div>
    <% } %>

    <form class="formulario"
          method="post"
          action="<%= request.getContextPath() %>/admin/reparaciones">

        <input type="hidden" name="accion" value="actualizar">
        <input type="hidden" name="id" value="<%= reparacion.getId() %>">

        <section class="seccion">
            <h2>1. Cliente y técnico</h2>

            <div class="campos">

                <div class="campo">
                    <label for="clienteId">Cliente *</label>

                    <select id="clienteId" name="clienteId" required>
                        <option value="">Selecciona un cliente</option>

                        <% for (cliente c : clientes) { %>
                            <option value="<%= c.getId() %>"
                                <%= c.getId() == reparacion.getClienteId()
                                    ? "selected" : "" %>>
                                <%= c.getNombre() %>
                                <%= c.getApellido() %>
                                — <%= c.getTelefono() %>
                            </option>
                        <% } %>
                    </select>
                </div>

                <div class="campo">
                    <label for="tecnicoId">Técnico responsable *</label>

                    <select id="tecnicoId" name="tecnicoId" required>
                        <option value="">Selecciona un técnico</option>

                        <% for (Tecnico t : tecnicos) { %>
                            <option value="<%= t.getId() %>"
                                <%= t.getId() == reparacion.getTecnicoId()
                                    ? "selected" : "" %>>
                                <%= t.getNombre() %>
                                — <%= t.getEspecialidad() %>
                                <%= !t.isActivo() ? " (Inactivo)" : "" %>
                            </option>
                        <% } %>
                    </select>
                </div>

            </div>
        </section>

        <section class="seccion">
            <h2>2. Información del dispositivo</h2>

            <div class="campos">

                <div class="campo">
                    <label for="equipo">Equipo *</label>
                    <input type="text" id="equipo" name="equipo"
                           maxlength="150" required
                           value="<%= equipo %>">
                </div>

                <div class="campo">
                    <label for="marca">Marca</label>
                    <input type="text" id="marca" name="marca"
                           maxlength="80" value="<%= marca %>">
                </div>

                <div class="campo">
                    <label for="modelo">Modelo</label>
                    <input type="text" id="modelo" name="modelo"
                           maxlength="150" value="<%= modelo %>">
                </div>

                <div class="campo">
                    <label for="imei">IMEI</label>
                    <input type="text" id="imei" name="imei"
                           maxlength="30" value="<%= imei %>">
                </div>

                <div class="campo">
                    <label for="serialEquipo">Número de serie</label>
                    <input type="text" id="serialEquipo"
                           name="serialEquipo" maxlength="80"
                           value="<%= serialEquipo %>">
                </div>

                <div class="campo">
                    <label for="color">Color</label>
                    <input type="text" id="color" name="color"
                           maxlength="60" value="<%= color %>">
                </div>

                <div class="campo">
                    <label for="almacenamiento">Almacenamiento</label>
                    <input type="text" id="almacenamiento"
                           name="almacenamiento" maxlength="60"
                           value="<%= almacenamiento %>">
                </div>

                <div class="campo">
                    <label for="estadoFisico">Estado físico</label>
                    <textarea id="estadoFisico" name="estadoFisico"><%= estadoFisico %></textarea>
                </div>

                <div class="campo completo">
                    <label for="falla">Falla reportada *</label>
                    <textarea id="falla" name="falla"
                              maxlength="5000" required><%= falla %></textarea>
                </div>

                <div class="campo">
                    <label for="accesorios">Accesorios recibidos</label>
                    <textarea id="accesorios" name="accesorios"><%= accesorios %></textarea>
                </div>

                <div class="campo">
                    <label for="diagnostico">Diagnóstico</label>
                    <textarea id="diagnostico" name="diagnostico"><%= diagnostico %></textarea>
                </div>

                <div class="campo completo">
                    <label for="observaciones">Observaciones</label>
                    <textarea id="observaciones" name="observaciones"><%= observaciones %></textarea>
                </div>

            </div>
        </section>

        <section class="seccion">
            <h2>3. Fechas, estado y costo</h2>

            <div class="campos">

                <div class="campo">
                    <label for="fechaIngreso">Fecha de ingreso *</label>
                    <input type="date" id="fechaIngreso"
                           name="fechaIngreso" required
                           value="<%= fechaIngreso %>">
                </div>

                <div class="campo">
                    <label for="fechaEntrega">Fecha de entrega prevista</label>
                    <input type="date" id="fechaEntrega"
                           name="fechaEntrega"
                           value="<%= fechaEntrega %>">
                </div>

                <div class="campo">
                    <label for="estado">Estado *</label>

                    <select id="estado" name="estado" required>
                        <% for (String e : estados) { %>
                            <option value="<%= e %>"
                                <%= e.equals(estadoActual)
                                    ? "selected" : "" %>>
                                <%= e %>
                            </option>
                        <% } %>
                    </select>
                </div>

                <div class="campo">
                    <label for="costo">Costo total (COP) *</label>
                    <input type="number" id="costo" name="costo"
                           min="0" step="0.01" required
                           value="<%= costo %>">
                </div>

            </div>
        </section>

        <section class="seccion">
            <h2>4. Información del pago</h2>

            <div class="campos">

                <div class="campo completo">
                    <div class="pago">
                        <input type="checkbox" id="pagado" name="pagado"
                               value="true"
                               <%= reparacion.isPagado() ? "checked" : "" %>>

                        <label for="pagado">
                            La reparación ya fue pagada
                        </label>
                    </div>
                </div>

                <div class="campo completo">
                    <label for="metodoPago">Método de pago</label>

                    <select id="metodoPago" name="metodoPago">
                        <option value="">Sin registrar pago</option>

                        <% for (String metodo : metodosPago) { %>
                            <option value="<%= metodo %>"
                                <%= metodo.equals(metodoActual)
                                    ? "selected" : "" %>>
                                <%= metodo %>
                            </option>
                        <% } %>
                    </select>

                    <span class="ayuda">
                        Si marcas la reparación como pagada, debes elegir
                        un método de pago.
                    </span>
                </div>

            </div>
        </section>

        <div class="acciones">
            <a class="boton cancelar"
               href="<%= request.getContextPath() %>/admin/reparaciones">
                Cancelar
            </a>

            <button class="boton guardar" type="submit">
                Guardar cambios
            </button>
        </div>

    </form>
</main>

<footer>
    © 2026 Rescate Móvil | Sistema de gestión de servicios técnicos
</footer>

<script>
    const pagado = document.getElementById("pagado");
    const metodoPago = document.getElementById("metodoPago");
    const fechaIngreso = document.getElementById("fechaIngreso");
    const fechaEntrega = document.getElementById("fechaEntrega");

    function actualizarPago() {
        metodoPago.required = pagado.checked;

        if (!pagado.checked) {
            metodoPago.value = "";
        }
    }

    pagado.addEventListener("change", actualizarPago);

    fechaIngreso.addEventListener("change", function () {
        fechaEntrega.min = fechaIngreso.value;

        if (fechaEntrega.value &&
            fechaEntrega.value < fechaIngreso.value) {
            fechaEntrega.value = "";
        }
    });

    fechaEntrega.addEventListener("change", function () {
        if (fechaIngreso.value) {
            fechaEntrega.min = fechaIngreso.value;
        }
    });

    if (fechaIngreso.value) {
        fechaEntrega.min = fechaIngreso.value;
    }

    actualizarPago();
</script>

</body>
</html>