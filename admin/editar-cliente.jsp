<%-- 
    Document   : editar-cliente
    Created on : 30/09/2026, 11:25:42 p. m.
    Author     : aleja
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.rescatemovil.modelo.cliente" %>

<%
    /*
     * ==========================================
     * VALIDACIÓN DE SESIÓN
     * ==========================================
     */

    String usuarioSesion =
            (String) session.getAttribute("usuario");

    String rolSesion =
            (String) session.getAttribute("rol");

    if (usuarioSesion == null || rolSesion == null) {

        response.sendRedirect(
                request.getContextPath()
                + "/login.jsp"
        );

        return;
    }


    /*
     * ==========================================
     * VALIDACIÓN DEL ROL
     * ==========================================
     */

    if (!"admin".equalsIgnoreCase(rolSesion)) {

        response.sendRedirect(
                request.getContextPath()
                + "/login.jsp?error=acceso"
        );

        return;
    }


    /*
     * ==========================================
     * OBTENER CLIENTE
     * ==========================================
     */

    cliente clienteActual =
            (cliente) request.getAttribute("cliente");


    /*
     * ==========================================
     * VALIDAR CLIENTE
     * ==========================================
     */

    if (clienteActual == null) {

        response.sendRedirect(
                request.getContextPath()
                + "/admin/clientes"
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

    <title>
        Editar cliente | Rescate Móvil
    </title>


    <style>

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }


        body {

            font-family:
                Arial,
                Helvetica,
                sans-serif;

            background: #07111f;

            color: #ffffff;

            min-height: 100vh;
        }


        .contenedor {

            width: 100%;

            max-width: 1100px;

            margin: 0 auto;

            padding: 30px;
        }


        /* ==========================================
           ENCABEZADO
        ========================================== */

        .encabezado {

            display: flex;

            justify-content: space-between;

            align-items: center;

            margin-bottom: 25px;

            gap: 20px;
        }


        .titulo h1 {

            font-size: 30px;

            margin-bottom: 8px;
        }


        .titulo p {

            color: #71869b;

            font-size: 14px;
        }


        .usuario {

            display: flex;

            align-items: center;

            gap: 12px;

            background: #0a1727;

            border:
                1px solid #1c354d;

            border-radius: 12px;

            padding: 10px 14px;
        }


        .avatar {

            width: 38px;

            height: 38px;

            border-radius: 50%;

            background: #00d4ff;

            color: #07111f;

            display: flex;

            align-items: center;

            justify-content: center;

            font-weight: bold;
        }


        .usuario strong {

            display: block;

            font-size: 13px;
        }


        .usuario span {

            display: block;

            color: #00d4ff;

            font-size: 11px;

            margin-top: 3px;
        }


        /* ==========================================
           BOTÓN REGRESAR
        ========================================== */

        .volver {

            display: inline-flex;

            align-items: center;

            gap: 8px;

            color: #91a4b9;

            text-decoration: none;

            font-size: 13px;

            margin-bottom: 20px;

            transition: 0.2s;
        }


        .volver:hover {

            color: #00d4ff;
        }


        /* ==========================================
           PANEL
        ========================================== */

        .panel {

            background: #0a1727;

            border:
                1px solid #1c354d;

            border-radius: 18px;

            overflow: hidden;

            box-shadow:
                0 20px 50px
                rgba(0, 0, 0, 0.25);
        }


        .panel-header {

            padding: 25px 30px;

            border-bottom:
                1px solid #1c354d;
        }


        .panel-header h2 {

            font-size: 20px;

            margin-bottom: 6px;
        }


        .panel-header p {

            color: #71869b;

            font-size: 13px;
        }


        /* ==========================================
           FORMULARIO
        ========================================== */

        .formulario {

            padding: 30px;
        }


        .grupo {

            margin-bottom: 22px;
        }


        .fila {

            display: grid;

            grid-template-columns:
                repeat(2, 1fr);

            gap: 20px;
        }


        .campo {

            display: flex;

            flex-direction: column;
        }


        label {

            color: #a9bacb;

            font-size: 12px;

            font-weight: bold;

            margin-bottom: 8px;
        }


        input,
        textarea {

            width: 100%;

            background: #07111f;

            color: #ffffff;

            border:
                1px solid #294158;

            border-radius: 10px;

            padding: 12px 14px;

            outline: none;

            font-family: Arial, Helvetica, sans-serif;

            font-size: 13px;

            transition: 0.2s;
        }


        input {

            height: 44px;
        }


        textarea {

            min-height: 120px;

            resize: vertical;
        }


        input:focus,
        textarea:focus {

            border-color: #00d4ff;

            box-shadow:
                0 0 0 3px
                rgba(0, 212, 255, 0.07);
        }


        input[readonly] {

            color: #62758a;

            background: #091521;

            cursor: not-allowed;
        }


        .obligatorio {

            color: #00d4ff;
        }


        .ayuda {

            color: #52677d;

            font-size: 11px;

            margin-top: 6px;
        }


        /* ==========================================
           SECCIÓN
        ========================================== */

        .seccion {

            margin-bottom: 30px;
        }


        .seccion-titulo {

            color: #00d4ff;

            font-size: 13px;

            font-weight: bold;

            text-transform: uppercase;

            letter-spacing: 0.8px;

            padding-bottom: 12px;

            margin-bottom: 20px;

            border-bottom:
                1px solid #142a3f;
        }


        /* ==========================================
           BOTONES
        ========================================== */

        .botones {

            display: flex;

            justify-content: flex-end;

            gap: 10px;

            padding-top: 10px;

            border-top:
                1px solid #142a3f;
        }


        .btn {

            display: inline-flex;

            align-items: center;

            justify-content: center;

            gap: 8px;

            min-width: 140px;

            padding: 12px 18px;

            border-radius: 10px;

            text-decoration: none;

            font-size: 13px;

            font-weight: bold;

            cursor: pointer;

            transition: 0.2s;
        }


        .btn-cancelar {

            background: #101f30;

            color: #91a4b9;

            border:
                1px solid #294158;
        }


        .btn-cancelar:hover {

            background: #15283d;

            color: #ffffff;
        }


        .btn-guardar {

            background: #00d4ff;

            color: #07111f;

            border:
                1px solid #00d4ff;
        }


        .btn-guardar:hover {

            transform:
                translateY(-1px);

            box-shadow:
                0 10px 25px
                rgba(0, 212, 255, 0.18);
        }


        /* ==========================================
           INFORMACIÓN
        ========================================== */

        .informacion {

            display: grid;

            grid-template-columns:
                repeat(3, 1fr);

            gap: 15px;

            margin-bottom: 25px;
        }


        .info-card {

            background: #081523;

            border:
                1px solid #142a3f;

            border-radius: 12px;

            padding: 15px;
        }


        .info-label {

            color: #52677d;

            font-size: 10px;

            text-transform: uppercase;

            margin-bottom: 5px;
        }


        .info-value {

            color: #c8d5e2;

            font-size: 13px;

            font-weight: bold;
        }


        /* ==========================================
           RESPONSIVE
        ========================================== */

        @media (max-width: 750px) {

            .contenedor {

                padding: 20px;
            }


            .encabezado {

                align-items: flex-start;

                flex-direction: column;
            }


            .fila {

                grid-template-columns: 1fr;
            }


            .informacion {

                grid-template-columns: 1fr;
            }


            .botones {

                flex-direction: column;
            }


            .btn {

                width: 100%;
            }

        }

    </style>

</head>


<body>


<div class="contenedor">


    <!-- ==========================================
         ENCABEZADO
    =========================================== -->

    <div class="encabezado">


        <div class="titulo">

            <h1>
                Editar cliente
            </h1>

            <p>
                Modifica la información del cliente
                registrado en Rescate Móvil.
            </p>

        </div>


        <div class="usuario">


            <div class="avatar">

                <%
                    String inicialUsuario = "";

                    if (usuarioSesion != null
                            && !usuarioSesion.trim().isEmpty()) {

                        inicialUsuario =
                                usuarioSesion
                                .substring(0, 1)
                                .toUpperCase();
                    }
                %>

                <%= inicialUsuario %>

            </div>


            <div>

                <strong>
                    <%= usuarioSesion %>
                </strong>

                <span>
                    ADMINISTRADOR
                </span>

            </div>


        </div>


    </div>


    <!-- ==========================================
         VOLVER
    =========================================== -->

    <a
        href="<%= request.getContextPath() %>/admin/clientes"
        class="volver">

        ← Volver a gestión de clientes

    </a>


    <!-- ==========================================
         INFORMACIÓN DEL CLIENTE
    =========================================== -->

    <div class="informacion">


        <div class="info-card">

            <div class="info-label">
                ID del cliente
            </div>

            <div class="info-value">

                #<%= clienteActual.getId() %>

            </div>

        </div>


        <div class="info-card">

            <div class="info-label">
                Fecha de registro
            </div>

            <div class="info-value">

                <%= clienteActual.getFechaRegistro() %>

            </div>

        </div>


        <div class="info-card">

            <div class="info-label">
                Usuario asociado
            </div>

            <div class="info-value">

                <%
                    if (clienteActual.getUsuarioId() != null) {
                %>

                    #<%= clienteActual.getUsuarioId() %>

                <%
                    } else {
                %>

                    Sin usuario

                <%
                    }
                %>

            </div>

        </div>


    </div>


    <!-- ==========================================
         PANEL FORMULARIO
    =========================================== -->

    <section class="panel">


        <div class="panel-header">

            <h2>
                Información del cliente
            </h2>

            <p>
                Actualiza los datos que necesites modificar.
            </p>

        </div>


        <form
            class="formulario"
            method="POST"
            action="<%= request.getContextPath() %>/admin/clientes">


            <!-- ==================================
                 DATOS PERSONALES
            =================================== -->

            <div class="seccion">


                <div class="seccion-titulo">
                    Datos personales
                </div>


                <div class="fila">


                    <div class="campo">

                        <label for="nombre">
                            Nombre
                            <span class="obligatorio">*</span>
                        </label>

                        <input
                            type="text"
                            id="nombre"
                            name="nombre"
                            value="<%= clienteActual.getNombre() != null
                                    ? clienteActual.getNombre()
                                    : "" %>"
                            required>

                    </div>


                    <div class="campo">

                        <label for="apellido">
                            Apellido
                            <span class="obligatorio">*</span>
                        </label>

                        <input
                            type="text"
                            id="apellido"
                            name="apellido"
                            value="<%= clienteActual.getApellido() != null
                                    ? clienteActual.getApellido()
                                    : "" %>"
                            required>

                    </div>


                </div>


                <br>


                <div class="fila">


                    <div class="campo">

                        <label for="documento">
                            Documento
                        </label>

                        <input
                            type="text"
                            id="documento"
                            name="documento"
                            value="<%= clienteActual.getDocumento() != null
                                    ? clienteActual.getDocumento()
                                    : "" %>">

                    </div>


                    <div class="campo">

                        <label for="usuarioId">
                            Usuario asociado
                        </label>

                        <input
                            type="text"
                            id="usuarioId"
                            value="<%= clienteActual.getUsuarioId() != null
                                    ? clienteActual.getUsuarioId()
                                    : "Sin usuario asociado" %>"
                            readonly>

                        <div class="ayuda">
                            El usuario asociado no se modifica desde aquí.
                        </div>

                    </div>


                </div>


            </div>


            <!-- ==================================
                 DATOS DE CONTACTO
            =================================== -->

            <div class="seccion">


                <div class="seccion-titulo">
                    Información de contacto
                </div>


                <div class="fila">


                    <div class="campo">

                        <label for="telefono">
                            Teléfono
                            <span class="obligatorio">*</span>
                        </label>

                        <input
                            type="text"
                            id="telefono"
                            name="telefono"
                            value="<%= clienteActual.getTelefono() != null
                                    ? clienteActual.getTelefono()
                                    : "" %>"
                            required>

                    </div>


                    <div class="campo">

                        <label for="telefonoSecundario">
                            Teléfono secundario
                        </label>

                        <input
                            type="text"
                            id="telefonoSecundario"
                            name="telefonoSecundario"
                            value="<%= clienteActual.getTelefonoSecundario() != null
                                    ? clienteActual.getTelefonoSecundario()
                                    : "" %>">

                    </div>


                </div>


                <br>


                <div class="fila">


                    <div class="campo">

                        <label for="correo">
                            Correo electrónico
                            <span class="obligatorio">*</span>
                        </label>

                        <input
                            type="email"
                            id="correo"
                            name="correo"
                            value="<%= clienteActual.getCorreo() != null
                                    ? clienteActual.getCorreo()
                                    : "" %>"
                            required>

                    </div>


                    <div class="campo">

                        <label for="ciudad">
                            Ciudad
                        </label>

                        <input
                            type="text"
                            id="ciudad"
                            name="ciudad"
                            value="<%= clienteActual.getCiudad() != null
                                    ? clienteActual.getCiudad()
                                    : "" %>">

                    </div>


                </div>


                <br>


                <div class="campo">

                    <label for="direccion">
                        Dirección
                        <span class="obligatorio">*</span>
                    </label>

                    <input
                        type="text"
                        id="direccion"
                        name="direccion"
                        value="<%= clienteActual.getDireccion() != null
                                ? clienteActual.getDireccion()
                                : "" %>"
                        required>

                </div>


            </div>


            <!-- ==================================
                 NOTAS
            =================================== -->

            <div class="seccion">


                <div class="seccion-titulo">
                    Información adicional
                </div>


                <div class="campo">

                    <label for="notas">
                        Notas
                    </label>

                    <textarea
                        id="notas"
                        name="notas"
                        placeholder="Agrega información adicional del cliente..."><%= clienteActual.getNotas() != null
                                ? clienteActual.getNotas()
                                : "" %></textarea>

                </div>


            </div>


            <!-- ==================================
                 CAMPOS OCULTOS
            =================================== -->

            <input
                type="hidden"
                name="accion"
                value="actualizar">


            <input
                type="hidden"
                name="id"
                value="<%= clienteActual.getId() %>">


            <!-- ==================================
                 BOTONES
            =================================== -->

            <div class="botones">


                <a
                    href="<%= request.getContextPath() %>/admin/clientes"
                    class="btn btn-cancelar">

                    ← Cancelar

                </a>


                <button
                    type="submit"
                    class="btn btn-guardar">

                    💾 Guardar cambios

                </button>


            </div>


        </form>


    </section>


</div>


</body>

</html>
