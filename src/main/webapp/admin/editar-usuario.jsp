<%-- 
    Document   : editar-usuario
    Created on : 30/09/2026, 10:04:14?p.?m.
    Author     : Luid alejandro Murillo Diaz
--%>


<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.rescatemovil.modelo.cliente" %>

<%
    // Verificar sesión
    if (session == null || session.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Verificar rol
    String rolSesion = (String) session.getAttribute("rol");

    if (rolSesion == null || !"admin".equalsIgnoreCase(rolSesion)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Obtener cliente enviado por ClienteServlet
    cliente clienteActual =
            (cliente) request.getAttribute("cliente");

    if (clienteActual == null) {
        response.sendRedirect(
                request.getContextPath() + "/admin/clientes"
        );
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Editar cliente | Rescate Móvil</title>

    <style>

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: Arial, Helvetica, sans-serif;
            background:
                radial-gradient(
                    circle at top right,
                    #173b55 0%,
                    #0b1724 45%,
                    #060d14 100%
                );
            color: #ffffff;
            min-height: 100vh;
        }

        .pagina {
            min-height: 100vh;
            padding: 35px 20px;
        }

        .contenedor {
            width: 100%;
            max-width: 1050px;
            margin: 0 auto;
        }

        .encabezado {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            margin-bottom: 30px;
        }

        .marca {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .marca img {
            width: 58px;
            height: 58px;
            object-fit: cover;
            border-radius: 14px;
            border: 1px solid rgba(255,255,255,0.15);
        }

        .marca h1 {
            font-size: 25px;
            margin-bottom: 4px;
        }

        .marca p {
            color: #9db0bf;
            font-size: 14px;
        }

        .boton-volver {
            text-decoration: none;
            color: #ffffff;
            border: 1px solid rgba(255,255,255,0.15);
            background: rgba(255,255,255,0.06);
            padding: 11px 17px;
            border-radius: 10px;
            transition: 0.2s;
        }

        .boton-volver:hover {
            background: rgba(255,255,255,0.12);
        }

        .tarjeta {
            background: rgba(10, 23, 35, 0.92);
            border: 1px solid rgba(255,255,255,0.09);
            border-radius: 20px;
            padding: 32px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.35);
        }

        .titulo-seccion {
            margin-bottom: 28px;
        }

        .titulo-seccion h2 {
            font-size: 25px;
            margin-bottom: 8px;
        }

        .titulo-seccion p {
            color: #9db0bf;
            font-size: 14px;
        }

        .id-cliente {
            display: inline-block;
            margin-top: 12px;
            padding: 7px 12px;
            border-radius: 20px;
            background: rgba(30, 144, 255, 0.12);
            border: 1px solid rgba(30, 144, 255, 0.25);
            color: #7ec8ff;
            font-size: 13px;
        }

        .formulario {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }

        .campo {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .campo-completo {
            grid-column: 1 / -1;
        }

        label {
            color: #dce7ef;
            font-size: 14px;
            font-weight: bold;
        }

        input,
        textarea {
            width: 100%;
            border: 1px solid rgba(255,255,255,0.12);
            background: #0b1825;
            color: #ffffff;
            border-radius: 10px;
            padding: 13px 14px;
            font-size: 14px;
            outline: none;
            transition: 0.2s;
        }

        input:focus,
        textarea:focus {
            border-color: #1e90ff;
            box-shadow: 0 0 0 3px rgba(30,144,255,0.10);
        }

        input[readonly] {
            background: #101d29;
            color: #7f94a4;
            cursor: not-allowed;
        }

        textarea {
            min-height: 120px;
            resize: vertical;
        }

        .acciones {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 30px;
            padding-top: 25px;
            border-top: 1px solid rgba(255,255,255,0.08);
        }

        .boton {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 12px 20px;
            border-radius: 10px;
            text-decoration: none;
            border: none;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
        }

        .cancelar {
            background: rgba(255,255,255,0.07);
            color: #ffffff;
            border: 1px solid rgba(255,255,255,0.12);
        }

        .guardar {
            background: #1e90ff;
            color: #ffffff;
        }

        .guardar:hover {
            background: #0879df;
        }

        .obligatorio {
            color: #ff6b6b;
        }

        @media (max-width: 700px) {

            .pagina {
                padding: 20px 12px;
            }

            .encabezado {
                flex-direction: column;
                align-items: flex-start;
            }

            .tarjeta {
                padding: 22px;
            }

            .formulario {
                grid-template-columns: 1fr;
            }

            .campo-completo {
                grid-column: auto;
            }

            .acciones {
                flex-direction: column;
            }

            .boton {
                width: 100%;
            }
        }

    </style>

</head>

<body>

<div class="pagina">

    <div class="contenedor">

        <!-- ENCABEZADO -->

        <header class="encabezado">

            <div class="marca">

                <img
                    src="<%= request.getContextPath() %>/img/logo.jpg"
                    alt="Rescate Móvil"
                >

                <div>

                    <h1>Editar cliente</h1>

                    <p>
                        Gestión de clientes de Rescate Móvil
                    </p>

                </div>

            </div>

            <a
                href="<%= request.getContextPath() %>/admin/clientes"
                class="boton-volver"
            >
                ← Volver
            </a>

        </header>


        <!-- FORMULARIO -->

        <section class="tarjeta">

            <div class="titulo-seccion">

                <h2>Información del cliente</h2>

                <p>
                    Modifica los datos del cliente y guarda los cambios.
                </p>

                <span class="id-cliente">
                    ID del cliente:
                    <strong>
                        <%= clienteActual.getId() %>
                    </strong>
                </span>

            </div>


            <form
                action="<%= request.getContextPath() %>/admin/clientes"
                method="post"
                class="formulario"
            >

                <input
                    type="hidden"
                    name="action"
                    value="actualizar"
                >

                <input
                    type="hidden"
                    name="id"
                    value="<%= clienteActual.getId() %>"
                >


                <!-- NOMBRE -->

                <div class="campo">

                    <label for="nombre">
                        Nombre <span class="obligatorio">*</span>
                    </label>

                    <input
                        type="text"
                        id="nombre"
                        name="nombre"
                        maxlength="80"
                        value="<%= clienteActual.getNombre() != null
                                ? clienteActual.getNombre()
                                : "" %>"
                        required
                    >

                </div>


                <!-- APELLIDO -->

                <div class="campo">

                    <label for="apellido">
                        Apellido <span class="obligatorio">*</span>
                    </label>

                    <input
                        type="text"
                        id="apellido"
                        name="apellido"
                        maxlength="100"
                        value="<%= clienteActual.getApellido() != null
                                ? clienteActual.getApellido()
                                : "" %>"
                        required
                    >

                </div>


                <!-- DOCUMENTO -->

                <div class="campo">

                    <label for="documento">
                        Documento
                    </label>

                    <input
                        type="text"
                        id="documento"
                        name="documento"
                        maxlength="30"
                        value="<%= clienteActual.getDocumento() != null
                                ? clienteActual.getDocumento()
                                : "" %>"
                    >

                </div>


                <!-- TELEFONO -->

                <div class="campo">

                    <label for="telefono">
                        Teléfono <span class="obligatorio">*</span>
                    </label>

                    <input
                        type="text"
                        id="telefono"
                        name="telefono"
                        maxlength="30"
                        value="<%= clienteActual.getTelefono() != null
                                ? clienteActual.getTelefono()
                                : "" %>"
                        required
                    >

                </div>


                <!-- TELEFONO SECUNDARIO -->

                <div class="campo">

                    <label for="telefonoSecundario">
                        Teléfono secundario
                    </label>

                    <input
                        type="text"
                        id="telefonoSecundario"
                        name="telefonoSecundario"
                        maxlength="30"
                        value="<%= clienteActual.getTelefonoSecundario() != null
                                ? clienteActual.getTelefonoSecundario()
                                : "" %>"
                    >

                </div>


                <!-- CORREO -->

                <div class="campo">

                    <label for="correo">
                        Correo electrónico
                        <span class="obligatorio">*</span>
                    </label>

                    <input
                        type="email"
                        id="correo"
                        name="correo"
                        maxlength="150"
                        value="<%= clienteActual.getCorreo() != null
                                ? clienteActual.getCorreo()
                                : "" %>"
                        required
                    >

                </div>


                <!-- DIRECCION -->

                <div class="campo campo-completo">

                    <label for="direccion">
                        Dirección <span class="obligatorio">*</span>
                    </label>

                    <input
                        type="text"
                        id="direccion"
                        name="direccion"
                        maxlength="200"
                        value="<%= clienteActual.getDireccion() != null
                                ? clienteActual.getDireccion()
                                : "" %>"
                        required
                    >

                </div>


                <!-- CIUDAD -->

                <div class="campo">

                    <label for="ciudad">
                        Ciudad
                    </label>

                    <input
                        type="text"
                        id="ciudad"
                        name="ciudad"
                        maxlength="100"
                        value="<%= clienteActual.getCiudad() != null
                                ? clienteActual.getCiudad()
                                : "" %>"
                    >

                </div>


                <!-- USUARIO -->

                <div class="campo">

                    <label for="usuarioId">
                        ID usuario asociado
                    </label>

                    <input
                        type="text"
                        id="usuarioId"
                        value="<%= clienteActual.getUsuarioId() != null
                                ? clienteActual.getUsuarioId()
                                : "Sin usuario asociado" %>"
                        readonly
                    >

                </div>


                <!-- NOTAS -->

                <div class="campo campo-completo">

                    <label for="notas">
                        Notas
                    </label>

                    <textarea
                        id="notas"
                        name="notas"
                        maxlength="5000"
                    ><%= clienteActual.getNotas() != null
                            ? clienteActual.getNotas()
                            : "" %></textarea>

                </div>


                <!-- ACCIONES -->

                <div class="campo-completo acciones">

                    <a
                        href="<%= request.getContextPath() %>/admin/clientes"
                        class="boton cancelar"
                    >
                        Cancelar
                    </a>

                    <button
                        type="submit"
                        class="boton guardar"
                    >
                        Guardar cambios
                    </button>

                </div>

            </form>

        </section>

    </div>

</div>

</body>

</html>