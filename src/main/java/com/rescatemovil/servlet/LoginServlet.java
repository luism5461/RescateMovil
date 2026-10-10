/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package com.rescatemovil.servlet;

import com.rescatemovil.dao.UsuarioDAO;
import com.rescatemovil.modelo.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO =
            new UsuarioDAO();

    /*
     * ==========================================
     * MÉTODO GET
     * ==========================================
     *
     * Si alguien entra directamente a:
     *
     * /RescateMovil/login
     *
     * lo enviamos nuevamente al formulario
     * de inicio de sesión.
     */
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/login.jsp"
        );
    }


    /*
     * ==========================================
     * MÉTODO POST
     * ==========================================
     *
     * Este método recibe:
     *
     * usuario
     * password
     *
     * y valida las credenciales mediante
     * UsuarioDAO.
     */
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");


        /*
         * ======================================
         * OBTENER DATOS DEL FORMULARIO
         * ======================================
         */

        String usuario =
                request.getParameter("usuario");

        String password =
                request.getParameter("password");


        /*
         * ======================================
         * VALIDAR CAMPOS VACÍOS
         * ======================================
         */

        if (usuario == null
                || usuario.trim().isEmpty()
                || password == null
                || password.isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=1"
            );

            return;
        }


        usuario = usuario.trim();


        /*
         * ======================================
         * VALIDAR USUARIO Y CONTRASEÑA
         * ======================================
         */

        Usuario usuarioEncontrado =
                usuarioDAO.validarLogin(
                        usuario,
                        password
                );


        /*
         * ======================================
         * CREDENCIALES INCORRECTAS
         * ======================================
         */

        if (usuarioEncontrado == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=1"
            );

            return;
        }


        /*
         * ======================================
         * CREAR SESIÓN
         * ======================================
         */

        HttpSession session =
                request.getSession(true);


        session.setAttribute(
                "usuario",
                usuarioEncontrado.getUsuario()
        );


        session.setAttribute(
                "usuarioId",
                usuarioEncontrado.getId()
        );


        session.setAttribute(
                "nombre",
                usuarioEncontrado.getNombre()
        );


        session.setAttribute(
                "rol",
                usuarioEncontrado.getRol()
        );


        /*
         * ======================================
         * OBTENER ROL
         * ======================================
         */

        String rol =
                usuarioEncontrado.getRol();


        /*
         * ======================================
         * REDIRECCIÓN SEGÚN ROL
         * ======================================
         */

        if ("admin".equalsIgnoreCase(rol)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/index.jsp"
            );

            return;
        }


        if ("tecnico".equalsIgnoreCase(rol)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/tecnico/index.jsp"
            );

            return;
        }


        if ("cliente".equalsIgnoreCase(rol)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/cliente/index.jsp"
            );

            return;
        }


        /*
         * ======================================
         * ROL NO RECONOCIDO
         * ======================================
         */

        session.invalidate();

        response.sendRedirect(
                request.getContextPath()
                + "/login.jsp?error=rol"
        );
    }
}