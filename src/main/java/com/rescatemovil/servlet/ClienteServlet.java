/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */


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

    /**
     * Procesa las solicitudes GET.
     */
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Verificar que exista una sesión
        if (session == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );
            return;
        }

        // Verificar que el usuario tenga rol administrador
        String rol = (String) session.getAttribute("rol");

        if (rol == null || !"admin".equalsIgnoreCase(rol)) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );
            return;
        }

        String accion = request.getParameter("accion");

        if (accion == null || accion.isEmpty()) {
            listarClientes(request, response);
            return;
        }

        switch (accion) {

            case "editar":
                mostrarEditar(request, response);
                break;

            case "eliminar":
                eliminarCliente(request, response);
                break;

            default:
                listarClientes(request, response);
                break;
        }
    }

    /**
     * Procesa las solicitudes POST.
     */
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        // Verificar sesión
        if (session == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );
            return;
        }

        // Verificar rol administrador
        String rol = (String) session.getAttribute("rol");

        if (rol == null || !"admin".equalsIgnoreCase(rol)) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );
            return;
        }

        String accion = request.getParameter("accion");

        if ("actualizar".equals(accion)) {

            actualizarCliente(request, response);

        } else {

            listarClientes(request, response);
        }
    }

    /**
     * Muestra la lista de clientes.
     */
    private void listarClientes(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        List<cliente> clientes = clienteDAO.listarClientes();

        request.setAttribute("clientes", clientes);

        request.getRequestDispatcher(
                "/admin/clientes.jsp"
        ).forward(request, response);
    }

    /**
     * Busca un cliente y muestra el formulario de edición.
     */
    private void mostrarEditar(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String idParametro = request.getParameter("id");

        if (idParametro == null || idParametro.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/clientes"
            );
            return;
        }

        try {

            int id = Integer.parseInt(idParametro);

            cliente c = clienteDAO.obtenerClientePorId(id);

            if (c == null) {

                response.sendRedirect(
                        request.getContextPath() + "/admin/clientes"
                );
                return;
            }

            request.setAttribute("cliente", c);

            request.getRequestDispatcher(
                    "/admin/editar-cliente.jsp"
            ).forward(request, response);

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath() + "/admin/clientes"
            );
        }
    }

    /**
     * Actualiza un cliente en la base de datos.
     */
    private void actualizarCliente(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        try {

            String idParametro = request.getParameter("id");

            if (idParametro == null || idParametro.trim().isEmpty()) {

                response.sendRedirect(
                        request.getContextPath() + "/admin/clientes"
                );
                return;
            }

            int id = Integer.parseInt(idParametro);

            String nombre = request.getParameter("nombre");
            String apellido = request.getParameter("apellido");
            String documento = request.getParameter("documento");
            String telefono = request.getParameter("telefono");
            String telefonoSecundario =
                    request.getParameter("telefonoSecundario");
            String correo = request.getParameter("correo");
            String direccion = request.getParameter("direccion");
            String ciudad = request.getParameter("ciudad");
            String notas = request.getParameter("notas");

            // Limpiar espacios
            nombre = limpiar(nombre);
            apellido = limpiar(apellido);
            documento = limpiar(documento);
            telefono = limpiar(telefono);
            telefonoSecundario = limpiar(telefonoSecundario);
            correo = limpiar(correo);
            direccion = limpiar(direccion);
            ciudad = limpiar(ciudad);
            notas = limpiar(notas);

            /*
             * Validación de campos obligatorios.
             *
             * Según la estructura de la tabla clientes:
             * nombre, apellido, telefono, correo y direccion
             * no pueden quedar vacíos.
             */
            if (nombre.isEmpty()
                    || apellido.isEmpty()
                    || telefono.isEmpty()
                    || correo.isEmpty()
                    || direccion.isEmpty()) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/clientes?error=campos"
                );
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

            boolean actualizado =
                    clienteDAO.actualizarCliente(c);

            if (actualizado) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/clientes?mensaje=actualizado"
                );

            } else {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/clientes?error=actualizar"
                );
            }

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/clientes?error=id"
            );
        }
    }

    /**
     * Elimina un cliente.
     *
     * Por ahora esta función solamente redirige.
     * La eliminación real la implementaremos posteriormente.
     */
    private void eliminarCliente(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        response.sendRedirect(
                request.getContextPath() + "/admin/clientes"
        );
    }

    /**
     * Limpia un texto recibido desde el formulario.
     */
    private String limpiar(String valor) {

        if (valor == null) {
            return "";
        }

        return valor.trim();
    }
}