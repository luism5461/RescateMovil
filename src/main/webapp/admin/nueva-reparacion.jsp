<%-- 
    Document   : nueva-reparacion
    Created on : 11/10/2026, 10:24:57 p. m.
    Author     : aleja
--%>

<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.time.LocalDate"%>
<%@page import="com.rescatemovil.dao.ClienteDAO"%>
<%@page import="com.rescatemovil.dao.TecnicoDAO"%>
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

    List<cliente> clientes =
        new ClienteDAO().listarClientes();

    List<Tecnico> tecnicos =
        new TecnicoDAO().listarTecnicos();

    String fechaHoy = LocalDate.now().toString();
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Nueva reparación | Rescate Móvil</title>

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
            margin: 0;
            color: #64748b;
            line-height: 1.5;
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

        input,
        select,
        textarea {
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
            min-height: 105px;
            resize: vertical;
        }

        input:focus,
        select:focus,
        textarea:focus {
            outline: none;
            border-color: #087ea4;
            box-shadow: 0 0 0 3px #087ea41c;
        }

        .ayuda {
            color: #64748b;
            font-size: 12px;
            line-height: 1.4;
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

        .mensaje {
            padding: 14px;
            border-radius: 8px;
            margin-bottom: 20px;
            background: #fee2e2;
            color: #991b1b;
            line-height: 1.5;
        }

        .sin-opciones {
            padding: 12px;
            background: #fff7ed;
            border-radius: 8px;
            color: #9a3412;
            font-size: 13px;
            line-height: 1.5;
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
        <h1>Registrar reparación</h1>
        <p class="subtitulo">
            Completa los datos del cliente, del técnico y del dispositivo.
        </p>
    </div>

    <% if ("datos".equals(error)) { %>
        <div class="mensaje">
            No se pudo registrar la reparación. Verifica los campos
            obligatorios, las fechas, el costo y el método de pago.
        </div>
    <% } else if ("registrar".equals(error)) { %>
        <div class="mensaje">
            No fue posible guardar la reparación en la base de datos.
            Revisa la consola de NetBeans para consultar el error.
        </div>
    <% } else if ("metodo_pago".equals(error)) { %>
        <div class="mensaje">
            Si marcas la reparación como pagada, debes seleccionar
            el método de pago.
        </div>
    <% } %>

    <% if (clientes.isEmpty()) { %>
        <div class="mensaje">
            No hay clientes registrados. Registra primero un cliente
            desde el módulo Gestión de clientes.
        </div>
    <% } %>

    <% if (tecnicos.isEmpty()) { %>
        <div class="mensaje">
            No hay técnicos registrados. Registra primero un técnico
            desde el módulo Gestión de técnicos.
        </div>
    <% } %>

    <form class="formulario"
          method="post"
          action="<%= request.getContextPath() %>/admin/reparaciones"
          id="formReparacion">

        <input type="hidden" name="accion" value="registrar">

        <section class="seccion">
            <h2>1. Asignación de la reparación</h2>

            <div class="campos">

                <div class="campo">
                    <label for="clienteId">Cliente *</label>

                    <select id="clienteId"
                            name="clienteId"
                            required>
                        <option value="">Selecciona un cliente</option>

                        <% for (cliente c : clientes) { %>
                            <option value="<%= c.getId() %>">
                                <%= c.getNombre() %>
                                <%= c.getApellido() %>
                                — <%= c.getTelefono() %>
                            </option>
                        <% } %>
                    </select>
                </div>

                <div class="campo">
                    <label for="tecnicoId">Técnico responsable *</label>

                    <select id="tecnicoId"
                            name="tecnicoId"
                            required>
                        <option value="">Selecciona un técnico</option>

                        <% for (Tecnico t : tecnicos) {
                            if (t.isActivo()) { %>

                            <option value="<%= t.getId() %>">
                                <%= t.getNombre() %>
                                — <%= t.getEspecialidad() %>
                            </option>

                        <%  }
                           } %>
                    </select>

                    <span class="ayuda">
                        Solo se muestran técnicos activos.
                    </span>
                </div>

            </div>
        </section>

        <section class="seccion">
            <h2>2. Información del dispositivo</h2>

            <div class="campos">

                <div class="campo">
                    <label for="equipo">Equipo *</label>

                    <input type="text"
                           id="equipo"
                           name="equipo"
                           maxlength="150"
                           placeholder="Ej. Celular Samsung Galaxy A54"
                           required>
                </div>

                <div class="campo">
                    <label for="marca">Marca</label>

                    <input type="text"
                           id="marca"
                           name="marca"
                           maxlength="80"
                           placeholder="Ej. Samsung">
                </div>

                <div class="campo">
                    <label for="modelo">Modelo</label>

                    <input type="text"
                           id="modelo"
                           name="modelo"
                           maxlength="150"
                           placeholder="Ej. Galaxy A54">
                </div>

                <div class="campo">
                    <label for="imei">IMEI</label>

                    <input type="text"
                           id="imei"
                           name="imei"
                           maxlength="30"
                           placeholder="IMEI del dispositivo">
                </div>

                <div class="campo">
                    <label for="serialEquipo">Número de serie</label>

                    <input type="text"
                           id="serialEquipo"
                           name="serialEquipo"
                           maxlength="80">
                </div>

                <div class="campo">
                    <label for="color">Color</label>

                    <input type="text"
                           id="color"
                           name="color"
                           maxlength="60">
                </div>

                <div class="campo">
                    <label for="almacenamiento">Almacenamiento</label>

                    <input type="text"
                           id="almacenamiento"
                           name="almacenamiento"
                           maxlength="60"
                           placeholder="Ej. 128 GB">
                </div>

                <div class="campo">
                    <label for="estadoFisico">Estado físico</label>

                    <textarea id="estadoFisico"
                              name="estadoFisico"
                              placeholder="Describe golpes, rayones o daños visibles"></textarea>
                </div>

                <div class="campo completo">
                    <label for="falla">Falla reportada *</label>

                    <textarea id="falla"
                              name="falla"
                              maxlength="5000"
                              placeholder="Describe el problema informado por el cliente"
                              required></textarea>
                </div>

                <div class="campo">
                    <label for="accesorios">Accesorios recibidos</label>

                    <textarea id="accesorios"
                              name="accesorios"
                              placeholder="Ej. Cargador, funda, SIM"></textarea>
                </div>

                <div class="campo">
                    <label for="diagnostico">Diagnóstico</label>

                    <textarea id="diagnostico"
                              name="diagnostico"
                              placeholder="Diagnóstico técnico, si está disponible"></textarea>
                </div>

                <div class="campo completo">
                    <label for="observaciones">Observaciones</label>

                    <textarea id="observaciones"
                              name="observaciones"
                              placeholder="Información adicional sobre la recepción del equipo"></textarea>
                </div>

            </div>
        </section>

        <section class="seccion">
            <h2>3. Fechas y estado</h2>

            <div class="campos">

                <div class="campo">
                    <label for="fechaIngreso">Fecha de ingreso *</label>

                    <input type="date"
                           id="fechaIngreso"
                           name="fechaIngreso"
                           value="<%= fechaHoy %>"
                           required>
                </div>

                <div class="campo">
                    <label for="fechaEntrega">Fecha de entrega prevista</label>

                    <input type="date"
                           id="fechaEntrega"
                           name="fechaEntrega">
                </div>

                <div class="campo">
                    <label for="estado">Estado de la reparación *</label>

                    <select id="estado" name="estado" required>
                        <option value="Recibido" selected>Recibido</option>
                        <option value="En proceso">En proceso</option>
                        <option value="Listo para recoger">Listo para recoger</option>
                        <option value="Finalizado">Finalizado</option>
                        <option value="Entregado">Entregado</option>
                    </select>
                </div>

                <div class="campo">
                    <label for="costo">Costo total (COP) *</label>

                    <input type="number"
                           id="costo"
                           name="costo"
                           min="0"
                           step="0.01"
                           value="0.00"
                           required>
                </div>

            </div>
        </section>

        <section class="seccion">
            <h2>4. Información del pago</h2>

            <div class="campos">

                <div class="campo completo">
                    <div class="pago">
                        <input type="checkbox"
                               id="pagado"
                               name="pagado"
                               value="true">

                        <label for="pagado">
                            La reparación ya fue pagada
                        </label>
                    </div>
                </div>

                <div class="campo completo">
                    <label for="metodoPago">Método de pago</label>

                    <select id="metodoPago" name="metodoPago">
                        <option value="">Sin registrar pago</option>
                        <option value="Nequi">Nequi</option>
                        <option value="Daviplata">Daviplata</option>
                        <option value="PSE / Tarjeta">PSE / Tarjeta</option>
                        <option value="Efectivo">Efectivo</option>
                    </select>

                    <span class="ayuda">
                        Si marcas la reparación como pagada, selecciona
                        también el método de pago.
                    </span>
                </div>

            </div>
        </section>

        <% if (!clientes.isEmpty() && !tecnicos.isEmpty()) { %>
            <div class="acciones">
                <a class="boton cancelar"
                   href="<%= request.getContextPath() %>/admin/reparaciones">
                    Cancelar
                </a>

                <button class="boton guardar" type="submit">
                    Registrar reparación
                </button>
            </div>
        <% } else { %>
            <div class="sin-opciones">
                Para registrar una reparación, necesitas tener al menos
                un cliente y un técnico registrados y un técnico activo.
            </div>
        <% } %>

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

    actualizarPago();

    if (fechaIngreso.value) {
        fechaEntrega.min = fechaIngreso.value;
    }
</script>

</body>
</html>