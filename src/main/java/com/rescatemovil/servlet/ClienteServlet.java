
package com.rescatemovil.servlet;

import com.rescatemovil.dao.ClienteDAO;
import com.rescatemovil.modelo.cliente;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/clientes")
public class ClienteServlet extends HttpServlet {

    private ClienteDAO clienteDAO;

    @Override
    public void init() throws ServletException {
        clienteDAO = new ClienteDAO();
    }

    private boolean esAdministrador(
            HttpServletRequest request,
            HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp");
            return false;
        }

        String rol = (String) session.getAttribute("rol");

        if (rol == null || !"admin".equalsIgnoreCase(rol)) {
            response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "No tienes permiso para realizar esta operación.");
            return false;
        }

        return true;
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        if (!esAdministrador(request, response)) {
            return;
        }

        String accion = request.getParameter("accion");

        if ("editar".equals(accion)) {
            mostrarEditar(request, response);
        } else if ("nuevo".equals(accion)) {
            request.getRequestDispatcher(
                "/admin/nuevo-cliente.jsp").forward(request, response);
        } else {
            listarClientes(request, response);
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        if (!esAdministrador(request, response)) {
            return;
        }

        String accion = request.getParameter("accion");

        if ("crear".equals(accion)) {
            crearCliente(request, response);
        } else if ("actualizar".equals(accion)) {
            actualizarCliente(request, response);
        } else if ("eliminar".equals(accion)) {
            eliminarCliente(request, response);
        } else {
            response.sendRedirect(
                request.getContextPath() + "/admin/clientes");
        }
    }

    private void listarClientes(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        List<cliente> clientes = clienteDAO.listarClientes();

        request.setAttribute("clientes", clientes);

        request.getRequestDispatcher("/admin/clientes.jsp")
                .forward(request, response);
    }

    private void mostrarEditar(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String parametro = request.getParameter("id");

        try {
            if (parametro == null || parametro.trim().isEmpty()) {
                response.sendRedirect(
                    request.getContextPath() + "/admin/clientes");
                return;
            }

            int id = Integer.parseInt(parametro);

            if (id <= 0) {
                response.sendRedirect(
                    request.getContextPath() + "/admin/clientes");
                return;
            }

            cliente c = clienteDAO.obtenerClientePorId(id);

            if (c == null) {
                response.sendRedirect(
                    request.getContextPath()
                    + "/admin/clientes?error=noencontrado");
                return;
            }

            request.setAttribute("cliente", c);

            request.getRequestDispatcher(
                "/admin/editar-cliente.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(
                request.getContextPath() + "/admin/clientes?error=id");
        }
    }

    private void crearCliente(
            HttpServletRequest request,
            HttpServletResponse response) throws IOException {

        String nombre = limpiar(request.getParameter("nombre"));
        String apellido = limpiar(request.getParameter("apellido"));
        String documento = limpiar(request.getParameter("documento"));
        String telefono = limpiar(request.getParameter("telefono"));
        String telefonoSecundario =
            limpiar(request.getParameter("telefonoSecundario"));
        String correo = limpiar(request.getParameter("correo"));
        String direccion = limpiar(request.getParameter("direccion"));
        String ciudad = limpiar(request.getParameter("ciudad"));
        String notas = limpiar(request.getParameter("notas"));

        if (nombre.isEmpty() || apellido.isEmpty()
                || telefono.isEmpty() || correo.isEmpty()
                || direccion.isEmpty()) {
            redirigir(request, response, "error=campos");
            return;
        }

        if (!correo.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            redirigir(request, response, "error=correo");
            return;
        }

        cliente c = new cliente();
        c.setNombre(nombre);
        c.setApellido(apellido);
        c.setDocumento(documento);
        c.setTelefono(telefono);
        c.setTelefonoSecundario(telefonoSecundario);
        c.setCorreo(correo);
        c.setDireccion(direccion);
        c.setCiudad(ciudad);
        c.setNotas(notas);

        boolean registrado = clienteDAO.registrarCliente(c);

        if (registrado) {
            redirigir(request, response, "mensaje=creado");
        } else {
            redirigir(request, response, "error=registrar");
        }
    }

    private void actualizarCliente(
            HttpServletRequest request,
            HttpServletResponse response) throws IOException {

        String parametroId = request.getParameter("id");

        try {
            if (parametroId == null || parametroId.trim().isEmpty()) {
                redirigir(request, response, "error=id");
                return;
            }

            int id = Integer.parseInt(parametroId);

            if (id <= 0) {
                redirigir(request, response, "error=id");
                return;
            }

            String nombre = limpiar(request.getParameter("nombre"));
            String apellido = limpiar(request.getParameter("apellido"));
            String documento = limpiar(request.getParameter("documento"));
            String telefono = limpiar(request.getParameter("telefono"));
            String telefonoSecundario =
                limpiar(request.getParameter("telefonoSecundario"));
            String correo = limpiar(request.getParameter("correo"));
            String direccion = limpiar(request.getParameter("direccion"));
            String ciudad = limpiar(request.getParameter("ciudad"));
            String notas = limpiar(request.getParameter("notas"));

            if (nombre.isEmpty() || apellido.isEmpty()
                    || telefono.isEmpty() || correo.isEmpty()
                    || direccion.isEmpty()) {
                redirigir(request, response, "error=campos");
                return;
            }

            if (!correo.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
                redirigir(request, response, "error=correo");
                return;
            }

            cliente c = new cliente();
            c.setId(id);
            c.setNombre(nombre);
            c.setApellido(apellido);
            c.setDocumento(documento);
            c.setTelefono(telefono);
            c.setTelefonoSecundario(telefonoSecundario);
            c.setCorreo(correo);
            c.setDireccion(direccion);
            c.setCiudad(ciudad);
            c.setNotas(notas);

            if (clienteDAO.actualizarCliente(c)) {
                redirigir(request, response, "mensaje=actualizado");
            } else {
                redirigir(request, response, "error=actualizar");
            }

        } catch (NumberFormatException e) {
            redirigir(request, response, "error=id");
        }
    }

    private void eliminarCliente(
            HttpServletRequest request,
            HttpServletResponse response) throws IOException {

        String parametroId = request.getParameter("id");

        try {
            if (parametroId == null || parametroId.trim().isEmpty()) {
                redirigir(request, response, "error=id");
                return;
            }

            int id = Integer.parseInt(parametroId);

            if (id <= 0) {
                redirigir(request, response, "error=id");
                return;
            }

            boolean eliminado = clienteDAO.eliminarCliente(id);

            if (eliminado) {
                redirigir(request, response, "mensaje=eliminado");
            } else {
                redirigir(request, response, "error=eliminar");
            }

        } catch (NumberFormatException e) {
            redirigir(request, response, "error=id");
        }
    }

    private void redirigir(
            HttpServletRequest request,
            HttpServletResponse response,
            String parametro) throws IOException {

        response.sendRedirect(
            request.getContextPath() + "/admin/clientes?" + parametro);
    }

    private String limpiar(String valor) {
        return valor == null ? "" : valor.trim();
    }
}