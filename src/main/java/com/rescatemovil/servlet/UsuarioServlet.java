
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
import java.util.Arrays;

@WebServlet("/admin/usuarios")
public class UsuarioServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    private boolean esAdministrador(HttpServletRequest request,
                                    HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );
            return false;
        }

        String rol = (String) session.getAttribute("rol");

        if (rol == null || !rol.equalsIgnoreCase("admin")) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp?error=acceso"
            );
            return false;
        }

        return true;
    }

    private boolean correoValido(String correo) {
        if (correo == null) {
            return false;
        }

        return correo.matches(
                "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        );
    }

    private boolean rolValido(String rol) {
        return rol != null
                && Arrays.asList("admin", "tecnico", "cliente")
                        .contains(rol.trim().toLowerCase());
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        if (!esAdministrador(request, response)) {
            return;
        }

        String accion = request.getParameter("action");

        if ("editar".equalsIgnoreCase(accion)) {

            String idParametro = request.getParameter("id");

            try {
                long id = Long.parseLong(idParametro);

                if (id <= 0) {
                    throw new NumberFormatException();
                }

                Usuario usuario = usuarioDAO.buscarPorId(id);

                if (usuario == null) {
                    response.sendRedirect(
                            request.getContextPath()
                            + "/admin/usuarios?error=noencontrado"
                    );
                    return;
                }

                request.setAttribute("usuario", usuario);
                request.getRequestDispatcher(
                        "/admin/editar-usuario.jsp"
                ).forward(request, response);
                return;

            } catch (NumberFormatException | NullPointerException e) {
                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/usuarios?error=id"
                );
                return;
            }
        }

        if ("eliminar".equalsIgnoreCase(accion)) {

            try {
                long id = Long.parseLong(
                        request.getParameter("id")
                );

                if (id <= 0) {
                    throw new NumberFormatException();
                }

                boolean eliminado = usuarioDAO.eliminarUsuario(id);

                response.sendRedirect(
                        request.getContextPath()
                        + (eliminado
                        ? "/admin/usuarios?mensaje=eliminado"
                        : "/admin/usuarios?error=eliminar")
                );
                return;

            } catch (NumberFormatException | NullPointerException e) {
                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/usuarios?error=id"
                );
                return;
            }
        }

        List<Usuario> usuarios = usuarioDAO.listarUsuarios();
        request.setAttribute("usuarios", usuarios);

        request.getRequestDispatcher(
                "/admin/usuarios.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        if (!esAdministrador(request, response)) {
            return;
        }

        String accion = request.getParameter("accion");

        if ("editar".equalsIgnoreCase(accion)) {
            actualizarUsuario(request, response);
        } else {
            crearUsuario(request, response);
        }
    }

    private void crearUsuario(HttpServletRequest request,
                              HttpServletResponse response)
            throws IOException {

        String nombre = limpiar(request.getParameter("nombre"));
        String nombreUsuario = limpiar(request.getParameter("usuario"));
        String correo = limpiar(request.getParameter("correo"));
        String telefono = limpiar(request.getParameter("telefono"));
        String rolNuevo = limpiar(request.getParameter("rol"));
        String password = request.getParameter("password");
        String activoParametro = request.getParameter("activo");

        String base = request.getContextPath()
                + "/admin/nuevo-usuario.jsp";

        if (vacio(nombre) || vacio(nombreUsuario)
                || vacio(correo) || vacio(rolNuevo)
                || password == null || password.trim().isEmpty()) {
            response.sendRedirect(base + "?error=datos");
            return;
        }

        if (!correoValido(correo)) {
            response.sendRedirect(base + "?error=formatoCorreo");
            return;
        }

        if (!rolValido(rolNuevo)) {
            response.sendRedirect(base + "?error=rol");
            return;
        }

        if (password.length() < 8) {
            response.sendRedirect(base + "?error=password");
            return;
        }

        if (usuarioDAO.existeUsuario(nombreUsuario, 0)) {
            response.sendRedirect(base + "?error=usuario");
            return;
        }

        if (usuarioDAO.existeCorreo(correo, 0)) {
            response.sendRedirect(base + "?error=correo");
            return;
        }

        Usuario nuevoUsuario = new Usuario();
        nuevoUsuario.setNombre(nombre);
        nuevoUsuario.setUsuario(nombreUsuario);
        nuevoUsuario.setCorreo(correo);
        nuevoUsuario.setTelefono(telefono);
        nuevoUsuario.setRol(rolNuevo.toLowerCase());
        nuevoUsuario.setPasswordHash(password);
        nuevoUsuario.setActivo(!"0".equals(activoParametro));

        boolean registrado = usuarioDAO.insertarUsuario(nuevoUsuario);

        if (registrado) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/usuarios?mensaje=creado"
            );
        } else {
            response.sendRedirect(base + "?error=registro");
        }
    }

    private void actualizarUsuario(HttpServletRequest request,
                                  HttpServletResponse response)
            throws IOException {

        String idParametro = request.getParameter("id");
        String nombre = limpiar(request.getParameter("nombre"));
        String nombreUsuario = limpiar(request.getParameter("usuario"));
        String correo = limpiar(request.getParameter("correo"));
        String telefono = limpiar(request.getParameter("telefono"));
        String rolNuevo = limpiar(request.getParameter("rol"));
        String activoParametro = request.getParameter("activo");

        long id;

        try {
            id = Long.parseLong(idParametro);

            if (id <= 0) {
                throw new NumberFormatException();
            }
        } catch (NumberFormatException | NullPointerException e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/usuarios?error=id"
            );
            return;
        }

        String base = request.getContextPath()
                + "/admin/usuarios?action=editar&id=" + id;

        if (vacio(nombre) || vacio(nombreUsuario)
                || vacio(correo) || vacio(rolNuevo)) {
            response.sendRedirect(base + "&error=datos");
            return;
        }

        if (!correoValido(correo)) {
            response.sendRedirect(base + "&error=formatoCorreo");
            return;
        }

        if (!rolValido(rolNuevo)) {
            response.sendRedirect(base + "&error=rol");
            return;
        }

        if (usuarioDAO.existeUsuario(nombreUsuario, id)) {
            response.sendRedirect(base + "&error=usuario");
            return;
        }

        if (usuarioDAO.existeCorreo(correo, id)) {
            response.sendRedirect(base + "&error=correo");
            return;
        }

        Usuario usuarioEditar = new Usuario();
        usuarioEditar.setId(id);
        usuarioEditar.setNombre(nombre);
        usuarioEditar.setUsuario(nombreUsuario);
        usuarioEditar.setCorreo(correo);
        usuarioEditar.setTelefono(telefono);
        usuarioEditar.setRol(rolNuevo.toLowerCase());
        usuarioEditar.setActivo(!"0".equals(activoParametro));

        boolean actualizado = usuarioDAO.actualizarUsuario(usuarioEditar);

        if (actualizado) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/usuarios?mensaje=actualizado"
            );
        } else {
            response.sendRedirect(base + "&error=actualizar");
        }
    }

    private String limpiar(String valor) {
        return valor == null ? "" : valor.trim();
    }

    private boolean vacio(String valor) {
        return valor == null || valor.trim().isEmpty();
    }
}