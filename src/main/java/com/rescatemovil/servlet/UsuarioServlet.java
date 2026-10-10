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
import java.util.List;

@WebServlet("/admin/usuarios")
public class UsuarioServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO =
            new UsuarioDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );
            return;
        }

        String rol =
                (String) session.getAttribute("rol");

        if (rol == null
                || !rol.equalsIgnoreCase("admin")) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=acceso"
            );

            return;
        }

        String accion =
                request.getParameter("action");

        /*
         * =====================================
         * EDITAR USUARIO
         * =====================================
         */
        if ("editar".equalsIgnoreCase(accion)) {

            String idParametro =
                    request.getParameter("id");

            if (idParametro == null
                    || idParametro.trim().isEmpty()) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/usuarios"
                );

                return;
            }

            try {

                long id =
                        Long.parseLong(
                                idParametro
                        );

                Usuario usuario =
                        usuarioDAO.buscarPorId(id);

                if (usuario == null) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/admin/usuarios?error=noencontrado"
                    );

                    return;
                }

                request.setAttribute(
                        "usuario",
                        usuario
                );

                request.getRequestDispatcher(
                        "/admin/editar-usuario.jsp"
                ).forward(
                        request,
                        response
                );

                return;

            } catch (NumberFormatException e) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/usuarios?error=id"
                );

                return;
            }
        }

        /*
         * =====================================
         * ELIMINAR USUARIO
         * =====================================
         */
        if ("eliminar".equalsIgnoreCase(accion)) {

            String idParametro =
                    request.getParameter("id");

            if (idParametro == null
                    || idParametro.trim().isEmpty()) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/usuarios?error=id"
                );

                return;
            }

            try {

                long id =
                        Long.parseLong(
                                idParametro
                        );

                boolean eliminado =
                        usuarioDAO.eliminarUsuario(id);

                if (eliminado) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/admin/usuarios?mensaje=eliminado"
                    );

                } else {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/admin/usuarios?error=eliminar"
                    );
                }

                return;

            } catch (NumberFormatException e) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/usuarios?error=id"
                );

                return;
            }
        }

        /*
         * =====================================
         * LISTAR USUARIOS
         * =====================================
         */

        List<Usuario> usuarios =
                usuarioDAO.listarUsuarios();

        request.setAttribute(
                "usuarios",
                usuarios
        );

        request.getRequestDispatcher(
                "/admin/usuarios.jsp"
        ).forward(
                request,
                response
        );
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session =
                request.getSession(false);

        if (session == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }

        String rol =
                (String) session.getAttribute("rol");

        if (rol == null
                || !rol.equalsIgnoreCase("admin")) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=acceso"
            );

            return;
        }

        String accion =
                request.getParameter("accion");

        /*
         * =====================================
         * ACTUALIZAR USUARIO
         * =====================================
         */

        if ("editar".equalsIgnoreCase(accion)) {

            actualizarUsuario(
                    request,
                    response
            );

            return;
        }

        /*
         * =====================================
         * CREAR USUARIO
         * =====================================
         */

        crearUsuario(
                request,
                response
        );
    }

    private void crearUsuario(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        String nombre =
                request.getParameter("nombre");

        String usuario =
                request.getParameter("usuario");

        String correo =
                request.getParameter("correo");

        String telefono =
                request.getParameter("telefono");

        String rolNuevo =
                request.getParameter("rol");

        String password =
                request.getParameter("password");

        String activoParametro =
                request.getParameter("activo");

        if (nombre == null
                || nombre.trim().isEmpty()
                || usuario == null
                || usuario.trim().isEmpty()
                || correo == null
                || correo.trim().isEmpty()
                || rolNuevo == null
                || rolNuevo.trim().isEmpty()
                || password == null
                || password.isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/nuevo-usuario.jsp?error=datos"
            );

            return;
        }

        Usuario nuevoUsuario =
                new Usuario();

        nuevoUsuario.setNombre(
                nombre.trim()
        );

        nuevoUsuario.setUsuario(
                usuario.trim()
        );

        nuevoUsuario.setCorreo(
                correo.trim()
        );

        if (telefono != null) {

            nuevoUsuario.setTelefono(
                    telefono.trim()
            );

        } else {

            nuevoUsuario.setTelefono("");
        }

        nuevoUsuario.setRol(
                rolNuevo.trim()
        );

        nuevoUsuario.setPasswordHash(
                password
        );

        boolean activo = true;

        if ("0".equals(activoParametro)) {
            activo = false;
        }

        nuevoUsuario.setActivo(
                activo
        );

        boolean registrado =
                usuarioDAO.insertarUsuario(
                        nuevoUsuario
                );

        if (registrado) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/usuarios"
            );

        } else {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/nuevo-usuario.jsp?error=registro"
            );
        }
    }

    private void actualizarUsuario(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        String idParametro =
                request.getParameter("id");

        String nombre =
                request.getParameter("nombre");

        String usuario =
                request.getParameter("usuario");

        String correo =
                request.getParameter("correo");

        String telefono =
                request.getParameter("telefono");

        String rolNuevo =
                request.getParameter("rol");

        String activoParametro =
                request.getParameter("activo");

        if (idParametro == null
                || idParametro.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/usuarios?error=id"
            );

            return;
        }

        long id;

        try {

            id =
                    Long.parseLong(
                            idParametro
                    );

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/usuarios?error=id"
            );

            return;
        }

        if (nombre == null
                || nombre.trim().isEmpty()
                || usuario == null
                || usuario.trim().isEmpty()
                || correo == null
                || correo.trim().isEmpty()
                || rolNuevo == null
                || rolNuevo.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/usuarios?action=editar&id="
                    + id
                    + "&error=datos"
            );

            return;
        }

        Usuario usuarioEditar =
                new Usuario();

        usuarioEditar.setId(id);

        usuarioEditar.setNombre(
                nombre.trim()
        );

        usuarioEditar.setUsuario(
                usuario.trim()
        );

        usuarioEditar.setCorreo(
                correo.trim()
        );

        if (telefono != null) {

            usuarioEditar.setTelefono(
                    telefono.trim()
            );

        } else {

            usuarioEditar.setTelefono("");
        }

        usuarioEditar.setRol(
                rolNuevo.trim()
        );

        boolean activo = true;

        if ("0".equals(activoParametro)) {
            activo = false;
        }

        usuarioEditar.setActivo(
                activo
        );

        boolean actualizado =
                usuarioDAO.actualizarUsuario(
                        usuarioEditar
                );

        if (actualizado) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/usuarios"
            );

        } else {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/usuarios?action=editar&id="
                    + id
                    + "&error=actualizar"
            );
        }
    }
}