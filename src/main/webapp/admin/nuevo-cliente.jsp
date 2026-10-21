<%-- 
    Document   : nuevo-cliente
    Created on : 12/10/2026, 11:07:18 a. m.
    Author     : aleja
--%>


<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String usuarioSesion = (String) session.getAttribute("usuario");
    String rolSesion = (String) session.getAttribute("rol");

    if (usuarioSesion == null || rolSesion == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    if (!"admin".equalsIgnoreCase(rolSesion)) {
        response.sendError(
            HttpServletResponse.SC_FORBIDDEN,
            "No tienes permiso para acceder a esta página."
        );
        return;
    }

    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nuevo cliente | Rescate Móvil</title>

    <style>
        :root {
            --fondo: #07111f;
            --panel: #101e32;
            --borde: #263b55;
            --texto: #f1f5f9;
            --secundario: #9aadc4;
            --cian: #00b4d8;
            --azul: #4361ee;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            min-height: 100vh;
            padding: 30px 16px;
            font-family: "Segoe UI", Arial, sans-serif;
            color: var(--texto);
            background:
                radial-gradient(circle at 10% 0%,
                    rgba(0,180,216,.13), transparent 35%),
                radial-gradient(circle at 90% 10%,
                    rgba(67,97,238,.12), transparent 32%),
                var(--fondo);
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
            width: 55px;
            height: 55px;
            object-fit: cover;
            border-radius: 12px;
            border: 1px solid var(--borde);
        }

        .encabezado h1 {
            font-size: 27px;
            margin-bottom: 5px;
        }

        .encabezado p {
            color: var(--secundario);
            font-size: 13px;
        }

        .tarjeta {
            padding: 28px;
            border: 1px solid var(--borde);
            border-radius: 16px;
            background: rgba(16,30,50,.96);
            box-shadow: 0 18px 45px rgba(0,0,0,.18);
        }

        .tarjeta h2 {
            margin-bottom: 8px;
            font-size: 19px;
        }

        .descripcion {
            margin-bottom: 25px;
            color: var(--secundario);
            font-size: 12px;
            line-height: 1.6;
        }

        .formulario {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 20px;
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
            color: #dce8f6;
            font-size: 12px;
            font-weight: 600;
        }

        .obligatorio {
            color: #67e8f9;
        }

        input, textarea {
            width: 100%;
            padding: 12px 13px;
            border: 1px solid #30445e;
            border-radius: 8px;
            outline: none;
            background: #091526;
            color: #f1f5f9;
            font-family: inherit;
            font-size: 13px;
            transition: .2s;
        }

        input {
            min-height: 43px;
        }

        textarea {
            min-height: 100px;
            resize: vertical;
        }

        input::placeholder, textarea::placeholder {
            color: #7187a2;
        }

        input:focus, textarea:focus {
            border-color: var(--cian);
            box-shadow: 0 0 0 3px rgba(0,180,216,.10);
        }

        .ayuda {
            color: var(--secundario);
            font-size: 10px;
        }

        .alerta {
            padding: 13px 15px;
            margin-bottom: 20px;
            border: 1px solid rgba(239,68,68,.30);
            border-radius: 9px;
            background: rgba(239,68,68,.10);
            color: #fecaca;
            font-size: 12px;
            line-height: 1.6;
        }

        .acciones {
            display: flex;
            justify-content: flex-end;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 27px;
            padding-top: 22px;
            border-top: 1px solid var(--borde);
        }

        .boton {
            display: inline-flex;
            justify-content: center;
            align-items: center;
            min-height: 42px;
            padding: 11px 18px;
            border: 1px solid var(--borde);
            border-radius: 8px;
            text-decoration: none;
            cursor: pointer;
            font-family: inherit;
            font-size: 12px;
            font-weight: 700;
            transition: .2s;
        }

        .cancelar {
            background: #14243a;
            color: #dce8f6;
        }

        .cancelar:hover {
            border-color: #7187a2;
        }

        .guardar {
            border-color: rgba(0,180,216,.35);
            background: linear-gradient(135deg, #087ea4, #3457d5);
            color: white;
        }

        .guardar:hover {
            filter: brightness(1.12);
            transform: translateY(-1px);
        }

        .pie {
            padding-top: 20px;
            color: #7187a2;
            text-align: center;
            font-size: 11px;
        }

        @media (max-width: 600px) {
            .tarjeta {
                padding: 20px 16px;
            }

            .formulario {
                grid-template-columns: 1fr;
                gap: 16px;
            }

            .campo.completo {
                grid-column: auto;
            }

            .encabezado h1 {
                font-size: 22px;
            }

            .acciones .boton {
                flex: 1;
            }
        }
    </style>
</head>

<body>
<div class="contenedor">

    <header class="encabezado">
        <img
            src="<%= request.getContextPath() %>/img/logo.jpg"
            alt="Rescate Móvil"
            class="logo">

        <div>
            <h1>Nuevo cliente</h1>
            <p>Rescate Móvil · Panel administrativo</p>
        </div>
    </header>

    <section class="tarjeta">
        <h2>Registrar cliente</h2>
        <p class="descripcion">
            Ingresa la información del cliente. Los campos marcados
            con * son obligatorios.
        </p>

        <% if ("campos".equals(error)) { %>
            <div class="alerta">
                Completa todos los campos obligatorios antes de continuar.
            </div>
        <% } else if ("correo".equals(error)) { %>
            <div class="alerta">
                El correo electrónico no tiene un formato válido.
            </div>
        <% } else if ("documento".equals(error)) { %>
            <div class="alerta">
                Ya existe un cliente registrado con ese documento.
            </div>
        <% } else if ("registrar".equals(error)) { %>
            <div class="alerta">
                No fue posible registrar el cliente. Comprueba los datos
                e inténtalo nuevamente.
            </div>
        <% } %>

        <form
            class="formulario"
            action="<%= request.getContextPath() %>/admin/clientes"
            method="post">

            <input type="hidden" name="accion" value="crear">

            <div class="campo">
                <label for="nombre">
                    Nombre <span class="obligatorio">*</span>
                </label>
                <input
                    type="text"
                    id="nombre"
                    name="nombre"
                    maxlength="100"
                    placeholder="Nombre del cliente"
                    autocomplete="given-name"
                    required>
            </div>

            <div class="campo">
                <label for="apellido">
                    Apellido <span class="obligatorio">*</span>
                </label>
                <input
                    type="text"
                    id="apellido"
                    name="apellido"
                    maxlength="100"
                    placeholder="Apellido del cliente"
                    autocomplete="family-name"
                    required>
            </div>

            <div class="campo">
                <label for="documento">Documento de identidad</label>
                <input
                    type="text"
                    id="documento"
                    name="documento"
                    maxlength="30"
                    placeholder="Número de documento">
            </div>

            <div class="campo">
                <label for="telefono">
                    Teléfono <span class="obligatorio">*</span>
                </label>
                <input
                    type="tel"
                    id="telefono"
                    name="telefono"
                    maxlength="30"
                    placeholder="Teléfono principal"
                    autocomplete="tel"
                    required>
            </div>

            <div class="campo">
                <label for="telefonoSecundario">Teléfono secundario</label>
                <input
                    type="tel"
                    id="telefonoSecundario"
                    name="telefonoSecundario"
                    maxlength="30"
                    placeholder="Teléfono alternativo">
            </div>

            <div class="campo">
                <label for="correo">
                    Correo electrónico <span class="obligatorio">*</span>
                </label>
                <input
                    type="email"
                    id="correo"
                    name="correo"
                    maxlength="150"
                    placeholder="cliente@correo.com"
                    autocomplete="email"
                    required>
            </div>

            <div class="campo completo">
                <label for="direccion">
                    Dirección <span class="obligatorio">*</span>
                </label>
                <input
                    type="text"
                    id="direccion"
                    name="direccion"
                    maxlength="200"
                    placeholder="Dirección de residencia"
                    autocomplete="street-address"
                    required>
            </div>

            <div class="campo completo">
                <label for="ciudad">Ciudad</label>
                <input
                    type="text"
                    id="ciudad"
                    name="ciudad"
                    maxlength="100"
                    placeholder="Ciudad de residencia"
                    autocomplete="address-level2">
            </div>

            <div class="campo completo">
                <label for="notas">Notas adicionales</label>
                <textarea
                    id="notas"
                    name="notas"
                    maxlength="2000"
                    placeholder="Información adicional del cliente"></textarea>
                <span class="ayuda">
                    Campo opcional.
                </span>
            </div>

            <div class="campo completo">
                <div class="acciones">
                    <a
                        href="<%= request.getContextPath() %>/admin/clientes"
                        class="boton cancelar">
                        Cancelar
                    </a>

                    <button type="submit" class="boton guardar">
                        Guardar cliente
                    </button>
                </div>
            </div>
        </form>
    </section>

    <footer class="pie">
        © 2026 Rescate Móvil · Sistema de gestión de servicios técnicos
    </footer>

</div>
</body>
</html>