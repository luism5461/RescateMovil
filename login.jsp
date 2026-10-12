<%-- 
    Document   : login
    Created on : 23/09/2026, 8:42:53 p. m.
    Author     : aleja
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Iniciar sesión | Rescate Móvil</title>

    <meta name="description"
          content="Acceso a la plataforma Rescate Móvil">

    <style>

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html,
        body {
            width: 100%;
            min-height: 100%;
        }

        body {

            font-family: Arial, Helvetica, sans-serif;

            background:
                radial-gradient(
                    circle at 15% 20%,
                    rgba(0, 212, 255, 0.12),
                    transparent 30%
                ),
                radial-gradient(
                    circle at 85% 80%,
                    rgba(0, 102, 255, 0.12),
                    transparent 30%
                ),
                #07111f;

            color: white;

            min-height: 100vh;

            display: flex;

            align-items: center;

            justify-content: center;

            overflow-x: hidden;

            position: relative;

        }


        /* ==================================
           FONDOS DECORATIVOS
        ================================== */

        body::before {

            content: "";

            position: fixed;

            width: 400px;
            height: 400px;

            background: #00d4ff;

            opacity: 0.05;

            border-radius: 50%;

            filter: blur(100px);

            top: -150px;
            left: -150px;

            z-index: -1;

        }


        body::after {

            content: "";

            position: fixed;

            width: 450px;
            height: 450px;

            background: #0066ff;

            opacity: 0.06;

            border-radius: 50%;

            filter: blur(100px);

            bottom: -180px;
            right: -150px;

            z-index: -1;

        }


        /* ==================================
           CONTENEDOR PRINCIPAL
        ================================== */

        .login-container {

            width: 92%;

            max-width: 1050px;

            min-height: 620px;

            display: grid;

            grid-template-columns: 1fr 1fr;

            background: rgba(12, 26, 43, 0.92);

            border: 1px solid #1c354d;

            border-radius: 28px;

            overflow: hidden;

            box-shadow:
                0 30px 90px rgba(0, 0, 0, 0.55),
                0 0 80px rgba(0, 212, 255, 0.05);

        }


        /* ==================================
           PANEL IZQUIERDO
        ================================== */

        .info-panel {

            padding: 55px;

            display: flex;

            flex-direction: column;

            justify-content: center;

            position: relative;

            background:
                linear-gradient(
                    145deg,
                    rgba(0, 212, 255, 0.08),
                    rgba(0, 102, 255, 0.02)
                );

            border-right: 1px solid #1c354d;

        }


        .logo {

            width: 90px;

            height: 90px;

            object-fit: contain;

            border-radius: 22px;

            margin-bottom: 28px;

            box-shadow:
                0 15px 35px rgba(0, 0, 0, 0.3);

        }


        .badge {

            display: inline-block;

            width: fit-content;

            padding: 8px 15px;

            border-radius: 30px;

            border: 1px solid rgba(0, 212, 255, 0.35);

            background: rgba(0, 212, 255, 0.08);

            color: #00d4ff;

            font-size: 12px;

            font-weight: bold;

            letter-spacing: 1px;

            margin-bottom: 20px;

        }


        .info-panel h1 {

            font-size: 48px;

            line-height: 1.05;

            margin-bottom: 20px;

            letter-spacing: -1px;

        }


        .info-panel h1 span {

            color: #00d4ff;

        }


        .info-panel p {

            color: #91a4b9;

            font-size: 16px;

            line-height: 1.7;

            max-width: 420px;

        }


        .beneficios {

            margin-top: 35px;

            display: flex;

            flex-direction: column;

            gap: 15px;

        }


        .beneficio {

            display: flex;

            align-items: center;

            gap: 12px;

            color: #c8d5e2;

            font-size: 14px;

        }


        .beneficio-icon {

            width: 34px;

            height: 34px;

            display: flex;

            align-items: center;

            justify-content: center;

            border-radius: 10px;

            background: rgba(0, 212, 255, 0.1);

            color: #00d4ff;

            font-size: 16px;

        }


        /* ==================================
           PANEL LOGIN
        ================================== */

        .login-panel {

            padding: 55px;

            display: flex;

            flex-direction: column;

            justify-content: center;

            background: #0a1727;

        }


        .login-header {

            margin-bottom: 35px;

        }


        .login-header h2 {

            font-size: 32px;

            margin-bottom: 10px;

        }


        .login-header p {

            color: #91a4b9;

            font-size: 14px;

            line-height: 1.5;

        }


        /* ==================================
           MENSAJES
        ================================== */

        .mensaje-error {

            background: rgba(220, 53, 69, 0.12);

            border: 1px solid rgba(220, 53, 69, 0.35);

            color: #ff9da7;

            padding: 13px 15px;

            border-radius: 10px;

            margin-bottom: 20px;

            font-size: 13px;

        }


        .mensaje-exito {

            background: rgba(25, 135, 84, 0.12);

            border: 1px solid rgba(25, 135, 84, 0.35);

            color: #7ee2ae;

            padding: 13px 15px;

            border-radius: 10px;

            margin-bottom: 20px;

            font-size: 13px;

        }


        /* ==================================
           FORMULARIO
        ================================== */

        .campo {

            margin-bottom: 22px;

        }


        .campo label {

            display: block;

            margin-bottom: 9px;

            color: #d9e3ec;

            font-size: 14px;

            font-weight: bold;

        }


        .campo input {

            width: 100%;

            padding: 15px 16px;

            border: 1px solid #294158;

            border-radius: 11px;

            background: #07111f;

            color: white;

            font-size: 15px;

            outline: none;

            transition: 0.3s;

        }


        .campo input::placeholder {

            color: #62758a;

        }


        .campo input:focus {

            border-color: #00d4ff;

            box-shadow:
                0 0 0 3px rgba(0, 212, 255, 0.08);

        }


        /* ==================================
           BOTÓN
        ================================== */

        .btn-login {

            width: 100%;

            padding: 15px;

            border: none;

            border-radius: 11px;

            background: #00d4ff;

            color: #07111f;

            font-size: 15px;

            font-weight: bold;

            cursor: pointer;

            transition: 0.3s;

            margin-top: 5px;

        }


        .btn-login:hover {

            transform: translateY(-2px);

            box-shadow:
                0 12px 30px rgba(0, 212, 255, 0.20);

        }


        /* ==================================
           VOLVER
        ================================== */

        .volver {

            display: block;

            text-align: center;

            margin-top: 25px;

            color: #71869b;

            text-decoration: none;

            font-size: 14px;

            transition: 0.3s;

        }


        .volver:hover {

            color: #00d4ff;

        }


        /* ==================================
           PIE DEL LOGIN
        ================================== */

        .login-footer {

            margin-top: 35px;

            padding-top: 20px;

            border-top: 1px solid #1b3047;

            text-align: center;

            color: #52677d;

            font-size: 12px;

        }


        /* ==================================
           RESPONSIVE
        ================================== */

        @media (max-width: 800px) {

            body {

                padding: 25px 0;

            }


            .login-container {

                grid-template-columns: 1fr;

                min-height: auto;

            }


            .info-panel {

                padding: 40px 30px;

                border-right: none;

                border-bottom: 1px solid #1c354d;

            }


            .login-panel {

                padding: 40px 30px;

            }


            .info-panel h1 {

                font-size: 38px;

            }

        }


        @media (max-width: 450px) {

            .login-container {

                width: 94%;

                border-radius: 20px;

            }


            .info-panel,

            .login-panel {

                padding: 30px 22px;

            }


            .logo {

                width: 75px;

                height: 75px;

            }


            .info-panel h1 {

                font-size: 34px;

            }


            .login-header h2 {

                font-size: 27px;

            }

        }

    </style>

</head>


<body>


    <div class="login-container">


        <!-- ==================================
             INFORMACIÓN
        ================================== -->

        <section class="info-panel">


            <img
                src="img/logo.jpg"
                alt="Logo oficial de Rescate Móvil"
                class="logo">


            <div class="badge">
                📱 PLATAFORMA RESCATE MÓVIL
            </div>


            <h1>
                Bienvenido a
                <span>Rescate Móvil</span>
            </h1>


            <p>
                Gestiona de manera sencilla y segura los
                servicios técnicos, clientes, reparaciones,
                productos y ventas de tu negocio.
            </p>


            <div class="beneficios">


                <div class="beneficio">

                    <div class="beneficio-icon">
                        ✓
                    </div>

                    <span>
                        Gestión centralizada de información
                    </span>

                </div>


                <div class="beneficio">

                    <div class="beneficio-icon">
                        🔐
                    </div>

                    <span>
                        Acceso seguro mediante usuarios y roles
                    </span>

                </div>


                <div class="beneficio">

                    <div class="beneficio-icon">
                        ⚡
                    </div>

                    <span>
                        Administración rápida y organizada
                    </span>

                </div>


            </div>


        </section>


        <!-- ==================================
             LOGIN
        ================================== -->

        <section class="login-panel">


            <div class="login-header">

                <h2>
                    Iniciar sesión
                </h2>

                <p>
                    Ingresa tus credenciales para acceder
                    a la plataforma.
                </p>

            </div>


            <%
                String error = request.getParameter("error");

                if ("1".equals(error)
                        || "true".equals(error)
                        || "credenciales".equals(error)) {
            %>

                <div class="mensaje-error">
                    <strong>Acceso denegado.</strong>
                    Usuario o contraseña incorrectos.
                </div>

            <%
                }

                if ("acceso".equals(error)) {
            %>

                <div class="mensaje-error">
                    <strong>Acceso restringido.</strong>
                    No tienes permisos para acceder a esa sección.
                </div>

            <%
                }

                if ("logout".equals(request.getParameter("mensaje"))) {
            %>

                <div class="mensaje-exito">
                    Has cerrado sesión correctamente.
                </div>

            <%
                }
            %>


            <form
                action="<%= request.getContextPath() %>/login"
                method="post">


                <div class="campo">

                    <label for="usuario">
                        Usuario
                    </label>

                    <input
                        type="text"
                        id="usuario"
                        name="usuario"
                        placeholder="Ingresa tu usuario"
                        autocomplete="username"
                        required>

                </div>


                <div class="campo">

                    <label for="password">
                        Contraseña
                    </label>

                    <input
                        type="password"
                        id="password"
                        name="password"
                        placeholder="Ingresa tu contraseña"
                        autocomplete="current-password"
                        required>

                </div>


                <button
                    type="submit"
                    class="btn-login">

                    Iniciar sesión →

                </button>


            </form>


            <a
                href="index.html"
                class="volver">

                ← Volver a Rescate Móvil

            </a>


            <div class="login-footer">

                © 2026 Rescate Móvil
                <br>
                Plataforma de gestión de servicios técnicos móviles

            </div>


        </section>


    </div>


</body>

</html>