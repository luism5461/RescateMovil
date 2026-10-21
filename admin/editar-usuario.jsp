
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.rescatemovil.modelo.Usuario"%>
<%@page import="java.util.Locale"%>

<%
    Usuario usuarioActual = (Usuario) request.getAttribute("usuario");

    if (usuarioActual == null) {
        response.sendRedirect(
            request.getContextPath() + "/admin/usuarios?error=noencontrado"
        );
        return;
    }

    String error = request.getParameter("error");

    String nombre = usuarioActual.getNombre() == null
            ? "" : usuarioActual.getNombre();

    String nombreUsuario = usuarioActual.getUsuario() == null
            ? "" : usuarioActual.getUsuario();

    String correo = usuarioActual.getCorreo() == null
            ? "" : usuarioActual.getCorreo();

    String telefono = usuarioActual.getTelefono() == null
            ? "" : usuarioActual.getTelefono();

    String rol = usuarioActual.getRol() == null
            ? "" : usuarioActual.getRol().toLowerCase(Locale.ROOT);
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Editar usuario | Rescate Móvil</title>

    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            min-height: 100vh;
            font-family: Arial, Helvetica, sans-serif;
            color: #eaf4ff;
            background:
                radial-gradient(circle at top left, #123b58, transparent 40%),
                linear-gradient(135deg, #07111f, #0b1728);
            padding: 30px 16px;
        }

        .contenedor {
            max-width: 760px;
            width: 100%;
            margin: 0 auto;
        }

        .encabezado {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 25px;
        }

        .logo {
            width: 65px;
            height: 65px;
            object-fit: contain;
            background: #fff;
            border-radius: 14px;
            padding: 5px;
        }

        .encabezado h1 {
            font-size: 25px;
            margin-bottom: 6px;
        }

        .encabezado p,
        .descripcion {
            color: #a8bfd5;
        }

        .encabezado p {
            font-size: 14px;
        }

        .tarjeta {
            background: rgba(15, 30, 49, 0.96);
            border: 1px solid rgba(0, 180, 216, 0.25);
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 18px 50px rgba(0, 0, 0, 0.25);
        }

        .titulo-formulario {
            font-size: 22px;
            margin-bottom: 10px;
        }

        .descripcion {
            font-size: 14px;
            line-height: 1.6;
            margin-bottom: 22px;
        }

        .identificador {
            display: inline-block;
            color: #7de8ff;
            background: rgba(0, 180, 216, 0.12);
            border: 1px solid rgba(0, 180, 216, 0.25);
            border-radius: 20px;
            padding: 7px 12px;
            font-size: 13px;
            margin-bottom: 22px;
        }

        .rejilla {
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
            color: #dceafa;
            font-size: 14px;
            font-weight: bold;
        }

        input,
        select {
            width: 100%;
            padding: 13px 14px;
            border: 1px solid #30465e;
            border-radius: 10px;
            background: #0a1727;
            color: #f1f7ff;
            font-size: 14px;
            outline: none;
        }

        input:focus,
        select:focus {
            border-color: #00b4d8;
            box-shadow: 0 0 0 3px rgba(0, 180, 216, 0.12);
        }

        .ayuda {
            color: #91a8bd;
            font-size: 12px;
            line-height: 1.5;
        }

        .mensaje {
            padding: 13px 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-size: 14px;
            line-height: 1.5;
        }

        .mensaje.error {
            color: #ffd8d8;
            background: rgba(220, 53, 69, 0.14);
            border: 1px solid rgba(220, 53, 69, 0.4);
        }

        .acciones {
            display: flex;
            justify-content: flex-end;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 28px;
        }

        .boton {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 44px;
            padding: 12px 19px;
            border-radius: 10px;
            border: none;
            text-decoration: none;
            font-weight: bold;
            font-size: 14px;
            cursor: pointer;
            transition: 0.2s;
        }

        .boton-guardar {
            background: linear-gradient(135deg, #00b4d8, #4361ee);
            color: #fff;
        }

        .boton-guardar:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0, 180, 216, 0.2);
        }

        .boton-volver {
            color: #dceafa;
            background: #203249;
            border: 1px solid #354a61;
        }

        .boton-volver:hover {
            background: #2b415a;
        }

        .pie {
            text-align: center;
            color: #8097ad;
            font-size: 12px;
            margin-top: 22px;
        }

        @media (max-width: 600px) {
            .tarjeta {
                padding: 22px 18px;
            }

            .rejilla {
                grid-template-columns: 1fr;
            }

            .campo.completo {
                grid-column: auto;
            }

            .encabezado h1 {
                font-size: 21px;
            }

            .acciones {
                flex-direction: column-reverse;
            }

            .boton {
                width: 100%;
            }
        }
    </style>
</head>

<body>

    <main class="contenedor">

        <header class="encabezado">
            <img
                class="logo"
                src="<%= request.getContextPath() %>/img/logo.jpg"
                alt="Logo de Rescate Móvil"
            >

            <div>
                <h1>Rescate Móvil</h1>
                <p>Administración de usuarios</p>
            </div>
        </header>

        <section class="tarjeta">

            <h2 class="titulo-formulario">Editar usuario</h2>

            <p class="descripcion">
                Modifica los datos del usuario, su rol y el estado
                de su cuenta. Los cambios se guardarán en MySQL.
            </p>

            <div class="identificador">
                Usuario ID: <%= usuarioActual.getId() %>
            </div>

            <% if ("actualizar".equals(error)) { %>
                <div class="mensaje error">
                    No fue posible actualizar el usuario.
                    Verifica los datos y revisa la consola de NetBeans
                    si el problema continúa.
                </div>
            <% } else if ("datos".equals(error)) { %>
                <div class="mensaje error">
                    Algunos datos no son válidos. Revisa los campos
                    e inténtalo nuevamente.
                </div>
            <% } %>

            <form
                action="<%= request.getContextPath() %>/admin/usuarios"
                method="post"
            >

                <input type="hidden" name="accion" value="editar">

                <input
                    type="hidden"
                    name="id"
                    value="<%= usuarioActual.getId() %>"
                >

                <div class="rejilla">

                    <div class="campo completo">
                        <label for="nombre">Nombre completo *</label>
                        <input
                            type="text"
                            id="nombre"
                            name="nombre"
                            value="<%= nombre %>"
                            maxlength="150"
                            autocomplete="name"
                            required
                        >
                    </div>

                    <div class="campo">
                        <label for="usuario">Nombre de usuario *</label>
                        <input
                            type="text"
                            id="usuario"
                            name="usuario"
                            value="<%= nombreUsuario %>"
                            maxlength="80"
                            autocomplete="username"
                            required
                        >
                    </div>

                    <div class="campo">
                        <label for="correo">Correo electrónico *</label>
                        <input
                            type="email"
                            id="correo"
                            name="correo"
                            value="<%= correo %>"
                            maxlength="150"
                            autocomplete="email"
                            required
                        >
                    </div>

                    <div class="campo completo">
                        <label for="telefono">Teléfono</label>
                        <input
                            type="tel"
                            id="telefono"
                            name="telefono"
                            value="<%= telefono %>"
                            maxlength="30"
                            autocomplete="tel"
                        >
                    </div>

                    <div class="campo">
                        <label for="rol">Rol del usuario *</label>
                        <select id="rol" name="rol" required>

                            <option value="">Selecciona un rol</option>

                            <option value="admin"
                                <%= "admin".equals(rol) ? "selected" : "" %>>
                                Administrador
                            </option>

                            <option value="tecnico"
                                <%= "tecnico".equals(rol) ? "selected" : "" %>>
                                Técnico
                            </option>

                            <option value="cliente"
                                <%= "cliente".equals(rol) ? "selected" : "" %>>
                                Cliente
                            </option>

                        </select>
                    </div>

                    <div class="campo">
                        <label for="activo">Estado de la cuenta *</label>
                        <select id="activo" name="activo" required>

                            <option value="1"
                                <%= usuarioActual.isActivo() ? "selected" : "" %>>
                                Activo
                            </option>

                            <option value="0"
                                <%= !usuarioActual.isActivo() ? "selected" : "" %>>
                                Inactivo
                            </option>

                        </select>

                        <span class="ayuda">
                            Desactivar una cuenta puede impedir que el usuario
                            inicie sesión, según las validaciones del sistema.
                        </span>
                    </div>

                </div>

                <div class="acciones">

                    <a
                        class="boton boton-volver"
                        href="<%= request.getContextPath() %>/admin/usuarios"
                    >
                        Cancelar
                    </a>

                    <button
                        class="boton boton-guardar"
                        type="submit"
                    >
                        Guardar cambios
                    </button>

                </div>

            </form>

        </section>

        <footer class="pie">
            © 2026 Rescate Móvil | Sistema de gestión de servicios técnicos
        </footer>

    </main>

</body>
</html>