<%-- 
    Document   : nuevo-tecnico
    Created on : 11/10/2026, 9:50:37 p. m.
    Author     : aleja
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String contexto = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Nuevo técnico | Rescate Móvil</title>

    <style>
        :root {
            --fondo: #07111f;
            --panel: #101e30;
            --borde: #263b53;
            --texto: #f0f6ff;
            --secundario: #9eb0c7;
            --azul: #4361ee;
            --cian: #00b4d8;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            font-family: Arial, Helvetica, sans-serif;
            color: var(--texto);
            background:
                radial-gradient(
                    circle at top right,
                    rgba(0, 180, 216, .13),
                    transparent 35%
                ),
                var(--fondo);
        }

        .barra {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            padding: 18px 5%;
            border-bottom: 1px solid var(--borde);
            background: rgba(7, 17, 31, .94);
        }

        .marca {
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: bold;
            font-size: 20px;
            color: var(--texto);
            text-decoration: none;
        }

        .icono {
            display: grid;
            place-items: center;
            width: 45px;
            height: 45px;
            border-radius: 13px;
            background: linear-gradient(135deg, var(--cian), var(--azul));
            font-size: 25px;
        }

        .marca small {
            display: block;
            margin-top: 4px;
            font-size: 11px;
            font-weight: normal;
            color: var(--secundario);
        }

        .volver {
            padding: 10px 14px;
            border: 1px solid var(--borde);
            border-radius: 9px;
            color: var(--texto);
            text-decoration: none;
            font-size: 13px;
        }

        .volver:hover {
            border-color: var(--cian);
        }

        .contenedor {
            width: 92%;
            max-width: 760px;
            margin: 42px auto;
        }

        .encabezado {
            margin-bottom: 25px;
        }

        .encabezado h1 {
            margin: 0 0 10px;
            font-size: 30px;
        }

        .encabezado p {
            color: var(--secundario);
            line-height: 1.6;
            margin: 0;
        }

        .formulario {
            padding: 30px;
            border: 1px solid var(--borde);
            border-radius: 18px;
            background: rgba(16, 30, 48, .96);
            box-shadow: 0 20px 60px rgba(0, 0, 0, .18);
        }

        .nota {
            padding: 14px;
            margin-bottom: 25px;
            border: 1px solid rgba(0, 180, 216, .25);
            border-radius: 10px;
            background: rgba(0, 180, 216, .07);
            color: #bceeff;
            font-size: 13px;
            line-height: 1.6;
        }

        .grupo {
            margin-bottom: 22px;
        }

        label {
            display: block;
            margin-bottom: 9px;
            font-size: 13px;
            font-weight: bold;
        }

        .requerido {
            color: #ff8c9e;
        }

        input {
            display: block;
            width: 100%;
            padding: 13px 14px;
            border: 1px solid var(--borde);
            border-radius: 10px;
            outline: none;
            background: var(--fondo);
            color: var(--texto);
            font-size: 14px;
        }

        input:focus {
            border-color: var(--cian);
            box-shadow: 0 0 0 3px rgba(0, 180, 216, .08);
        }

        input::placeholder {
            color: #70839b;
        }

        .ayuda {
            display: block;
            margin-top: 7px;
            color: var(--secundario);
            font-size: 11px;
        }

        .fila {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
        }

        .acciones {
            display: flex;
            justify-content: flex-end;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 30px;
            padding-top: 22px;
            border-top: 1px solid var(--borde);
        }

        .boton {
            display: inline-flex;
            justify-content: center;
            align-items: center;
            padding: 12px 19px;
            border-radius: 10px;
            font-size: 13px;
            font-weight: bold;
            cursor: pointer;
            text-decoration: none;
            transition: .2s;
        }

        .boton:hover {
            transform: translateY(-1px);
        }

        .guardar {
            border: none;
            color: white;
            background: linear-gradient(135deg, var(--azul), var(--cian));
        }

        .cancelar {
            border: 1px solid var(--borde);
            color: var(--texto);
            background: transparent;
        }

        .pie {
            padding: 20px;
            text-align: center;
            color: var(--secundario);
            font-size: 12px;
        }

        @media (max-width: 600px) {
            .fila {
                grid-template-columns: 1fr;
                gap: 0;
            }

            .formulario {
                padding: 22px 18px;
            }

            .encabezado h1 {
                font-size: 25px;
            }

            .acciones .boton {
                flex: 1;
            }

            .barra {
                padding: 14px 4%;
            }
        }
    </style>
</head>

<body>

<header class="barra">
    <a class="marca" href="<%= contexto %>/admin/index.jsp">
        <span class="icono">📱</span>
        <span>
            Rescate Móvil
            <small>Administración del sistema</small>
        </span>
    </a>

    <a class="volver"
       href="<%= contexto %>/admin/tecnicos">
        ← Volver
    </a>
</header>

<main class="contenedor">

    <section class="encabezado">
        <h1>Registrar nuevo técnico</h1>
        <p>
            Ingresa los datos del especialista que formará parte
            del equipo de servicio técnico.
        </p>
    </section>

    <form class="formulario"
          action="<%= contexto %>/admin/tecnicos"
          method="post"
          accept-charset="UTF-8">

        <input type="hidden" name="accion" value="registrar">

        <div class="nota">
            Los campos marcados con <strong>*</strong> son obligatorios.
            El técnico se registrará inicialmente como activo y con cero
            reparaciones activas.
        </div>

        <div class="grupo">
            <label for="nombre">
                Nombre completo <span class="requerido">*</span>
            </label>

            <input type="text"
                   id="nombre"
                   name="nombre"
                   maxlength="120"
                   placeholder="Ej. Carlos Méndez"
                   autocomplete="name"
                   required>
        </div>

        <div class="grupo">
            <label for="especialidad">
                Especialidad técnica <span class="requerido">*</span>
            </label>

            <input type="text"
                   id="especialidad"
                   name="especialidad"
                   maxlength="180"
                   placeholder="Ej. iPhone, Samsung y pantallas OLED"
                   required>
        </div>

        <div class="fila">
            <div class="grupo">
                <label for="telefono">
                    Teléfono <span class="requerido">*</span>
                </label>

                <input type="tel"
                       id="telefono"
                       name="telefono"
                       maxlength="30"
                       placeholder="Ej. 3001234567"
                       autocomplete="tel"
                       required>
            </div>

            <div class="grupo">
                <label for="correo">
                    Correo electrónico <span class="requerido">*</span>
                </label>

                <input type="email"
                       id="correo"
                       name="correo"
                       maxlength="150"
                       placeholder="tecnico@correo.com"
                       autocomplete="email"
                       required>

                <span class="ayuda">
                    Ingresa una dirección de correo válida.
                </span>
            </div>
        </div>

        <div class="acciones">
            <a class="boton cancelar"
               href="<%= contexto %>/admin/tecnicos">
                Cancelar
            </a>

            <button class="boton guardar" type="submit">
                Registrar técnico
            </button>
        </div>

    </form>

</main>

<footer class="pie">
    © 2026 Rescate Móvil | Sistema de gestión de servicios técnicos
</footer>

</body>
</html>
