<%-- 
    Document   : editar-tecnico
    Created on : 11/10/2026, 9:56:01 p. m.
    Author     : aleja
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.rescatemovil.modelo.Tecnico"%>
<%@page import="java.net.URLEncoder"%>

<%
    String contextPath = request.getContextPath();

    Object usuarioSesion = session.getAttribute("usuario");
    Object rolSesion = session.getAttribute("rol");

    if (usuarioSesion == null || rolSesion == null
            || !"admin".equalsIgnoreCase(String.valueOf(rolSesion))) {
        response.sendRedirect(contextPath + "/login.jsp");
        return;
    }

    Tecnico tecnico = (Tecnico) request.getAttribute("tecnico");

    if (tecnico == null) {
        response.sendRedirect(contextPath + "/admin/tecnicos?error="
                + URLEncoder.encode("No se encontró el técnico.", "UTF-8"));
        return;
    }

    String mensaje = request.getParameter("mensaje");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar técnico | Rescate Móvil</title>

    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            min-height: 100vh;
            font-family: Arial, Helvetica, sans-serif;
            color: #eaf2ff;
            background:
                radial-gradient(circle at top left, #142d4d 0, transparent 35%),
                linear-gradient(135deg, #07111f, #0b1729 60%, #101d35);
            padding: 30px 16px;
        }

        .contenedor {
            width: 100%;
            max-width: 760px;
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

        .enlace-volver {
            color: #8bdcf6;
            text-decoration: none;
            padding: 11px 15px;
            border: 1px solid #294361;
            border-radius: 10px;
        }

        .enlace-volver:hover {
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
            margin-bottom: 18px;
            line-height: 1.5;
        }

        .alerta-error {
            color: #ffc5c5;
            background: rgba(220, 53, 69, 0.13);
            border: 1px solid #813742;
        }

        .alerta-exito {
            color: #b8f8d0;
            background: rgba(25, 135, 84, 0.13);
            border: 1px solid #286b4d;
        }

        .grupo {
            margin-bottom: 21px;
        }

        label {
            display: block;
            margin-bottom: 9px;
            color: #dbe8fb;
            font-size: 14px;
            font-weight: bold;
        }

        input {
            width: 100%;
            padding: 14px;
            border: 1px solid #2a4565;
            border-radius: 10px;
            outline: none;
            background: #091628;
            color: #f2f7ff;
            font-size: 15px;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        input:focus {
            border-color: #00b4d8;
            box-shadow: 0 0 0 3px rgba(0, 180, 216, 0.12);
        }

        .ayuda {
            display: block;
            margin-top: 7px;
            color: #8297b5;
            font-size: 12px;
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

        .boton-guardar {
            color: #fff;
            background: linear-gradient(135deg, #087ea4, #4361ee);
        }

        .boton-guardar:hover {
            filter: brightness(1.12);
        }

        .boton-cancelar {
            color: #dbe8fb;
            background: #1a2c43;
            border: 1px solid #304966;
        }

        .boton-cancelar:hover {
            background: #253d59;
        }

        .nota {
            margin-top: 20px;
            color: #91a6c5;
            font-size: 13px;
            line-height: 1.6;
        }

        @media (max-width: 520px) {
            .tarjeta {
                padding: 22px 17px;
            }

            .encabezado h2 {
                font-size: 23px;
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
                    <p>Administración de técnicos</p>
                </div>
            </div>

            <a class="enlace-volver"
               href="<%= contextPath %>/admin/tecnicos">
                ← Volver a técnicos
            </a>
        </header>

        <section class="tarjeta">

            <div class="encabezado">
                <h2>Editar técnico</h2>
                <p>Actualiza la información del técnico y guarda los cambios.</p>

                <span class="identificador">
                    Técnico ID: <%= tecnico.getId() %>
                </span>
            </div>

            <% if ("actualizado".equals(mensaje)) { %>
                <div class="alerta alerta-exito">
                    Los datos del técnico se actualizaron correctamente.
                </div>
            <% } %>

            <% if (error != null && !error.trim().isEmpty()) { %>
                <div class="alerta alerta-error">
                    No fue posible completar la operación.
                    Verifica los datos e inténtalo nuevamente.
                </div>
            <% } %>

            <form action="<%= contextPath %>/admin/tecnicos"
                  method="post">

                <input type="hidden" name="accion" value="actualizar">
                <input type="hidden" name="id" value="<%= tecnico.getId() %>">

                <div class="grupo">
                    <label for="nombre">Nombre completo</label>
                    <input
                        type="text"
                        id="nombre"
                        name="nombre"
                        maxlength="120"
                        value="<%= tecnico.getNombre() == null ? "" :
                                tecnico.getNombre().replace("&", "&amp;")
                                    .replace("<", "&lt;")
                                    .replace(">", "&gt;")
                                    .replace("\"", "&quot;")
                                    .replace("'", "&#39;") %>"
                        required>
                </div>

                <div class="grupo">
                    <label for="especialidad">Especialidad</label>
                    <input
                        type="text"
                        id="especialidad"
                        name="especialidad"
                        maxlength="180"
                        value="<%= tecnico.getEspecialidad() == null ? "" :
                                tecnico.getEspecialidad().replace("&", "&amp;")
                                    .replace("<", "&lt;")
                                    .replace(">", "&gt;")
                                    .replace("\"", "&quot;")
                                    .replace("'", "&#39;") %>"
                        required>
                </div>

                <div class="grupo">
                    <label for="telefono">Teléfono</label>
                    <input
                        type="tel"
                        id="telefono"
                        name="telefono"
                        maxlength="30"
                        value="<%= tecnico.getTelefono() == null ? "" :
                                tecnico.getTelefono().replace("&", "&amp;")
                                    .replace("<", "&lt;")
                                    .replace(">", "&gt;")
                                    .replace("\"", "&quot;")
                                    .replace("'", "&#39;") %>"
                        required>
                </div>

                <div class="grupo">
                    <label for="correo">Correo electrónico</label>
                    <input
                        type="email"
                        id="correo"
                        name="correo"
                        maxlength="150"
                        value="<%= tecnico.getCorreo() == null ? "" :
                                tecnico.getCorreo().replace("&", "&amp;")
                                    .replace("<", "&lt;")
                                    .replace(">", "&gt;")
                                    .replace("\"", "&quot;")
                                    .replace("'", "&#39;") %>"
                        required>
                    <span class="ayuda">
                        Escribe un correo electrónico válido.
                    </span>
                </div>

                <div class="acciones">
                    <button type="submit" class="boton boton-guardar">
                        Guardar cambios
                    </button>

                    <a class="boton boton-cancelar"
                       href="<%= contextPath %>/admin/tecnicos">
                        Cancelar
                    </a>
                </div>
            </form>

            <p class="nota">
                Nota: este formulario modifica los datos de contacto y
                especialidad. El número de reparaciones activas y el estado
                del técnico se conservan.
            </p>

        </section>
    </main>
</body>
</html>