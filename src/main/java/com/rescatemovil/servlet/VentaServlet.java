
package com.rescatemovil.servlet;

import com.rescatemovil.dao.VentaDAO;
import com.rescatemovil.modelo.Venta;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/ventas")
public class VentaServlet extends HttpServlet {

    private final VentaDAO ventaDAO = new VentaDAO();

    private boolean verificarAdministrador(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        HttpSession sesion = request.getSession(false);

        if (sesion == null || sesion.getAttribute("rol") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return false;
        }

        String rol = String.valueOf(sesion.getAttribute("rol"));

        if (!rol.equalsIgnoreCase("admin")
                && !rol.equalsIgnoreCase("administrador")) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "No tienes permisos para acceder a las ventas.");

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

        if (!verificarAdministrador(request, response)) {
            return;
        }

        String accion = request.getParameter("accion");

        // Consultar el detalle de una venta.
        if ("detalle".equalsIgnoreCase(accion)) {
            mostrarDetalle(request, response);
            return;
        }

        // Obtener los filtros del formulario.
        String busqueda = request.getParameter("buscar");
        String fechaDesdeTexto = request.getParameter("fechaDesde");
        String fechaHastaTexto = request.getParameter("fechaHasta");

        // Mantener los filtros en el formulario después de buscar.
        request.setAttribute(
                "busqueda",
                busqueda == null ? "" : busqueda.trim());

        request.setAttribute(
                "fechaDesdeFiltro",
                fechaDesdeTexto == null ? "" : fechaDesdeTexto.trim());

        request.setAttribute(
                "fechaHastaFiltro",
                fechaHastaTexto == null ? "" : fechaHastaTexto.trim());

        try {
            Date fechaDesde = convertirFecha(fechaDesdeTexto);
            Date fechaHasta = convertirFecha(fechaHastaTexto);

            // Validar que la fecha inicial no sea posterior a la final.
            if (fechaDesde != null
                    && fechaHasta != null
                    && fechaDesde.after(fechaHasta)) {

                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "La fecha inicial no puede ser posterior a la fecha final.");

                return;
            }

            List<Venta> ventas;

            boolean hayBusqueda =
                    busqueda != null && !busqueda.trim().isEmpty();

            boolean hayFechaDesde = fechaDesde != null;
            boolean hayFechaHasta = fechaHasta != null;

            // Aplicar filtros si el administrador ingresó alguno.
            if (hayBusqueda || hayFechaDesde || hayFechaHasta) {

                ventas = ventaDAO.buscar(
                        busqueda,
                        fechaDesde,
                        fechaHasta);

            } else {
                // Si no hay filtros, mostrar todas las ventas.
                ventas = ventaDAO.listar();
            }

            request.setAttribute("ventas", ventas);

            request.getRequestDispatcher(
                    "/admin/ventas.jsp").forward(request, response);

        } catch (IllegalArgumentException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "La fecha ingresada no es válida. Utiliza el formato año-mes-día.");

        } catch (SQLException e) {

            throw new ServletException(
                    "Error al consultar el historial de ventas.", e);
        }
    }

    private Date convertirFecha(String fechaTexto) {

        if (fechaTexto == null || fechaTexto.trim().isEmpty()) {
            return null;
        }

        return Date.valueOf(fechaTexto.trim());
    }

    private void mostrarDetalle(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String idTexto = request.getParameter("id");

        try {
            if (idTexto == null || idTexto.trim().isEmpty()) {
                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Debes indicar el número de venta.");
                return;
            }

            int id = Integer.parseInt(idTexto);

            if (id <= 0) {
                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "El número de venta no es válido.");
                return;
            }

            Venta venta = ventaDAO.buscarPorId(id);

            if (venta == null) {
                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "No se encontró la venta solicitada.");
                return;
            }

            request.setAttribute("venta", venta);

            request.getRequestDispatcher(
                    "/admin/detalle-venta.jsp").forward(request, response);

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "El número de venta debe ser un entero válido.");

        } catch (SQLException e) {

            throw new ServletException(
                    "Error al consultar el detalle de la venta.", e);
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        if (!verificarAdministrador(request, response)) {
            return;
        }

        try {
            int clienteId = Integer.parseInt(
                    request.getParameter("clienteId"));

            int productoId = Integer.parseInt(
                    request.getParameter("productoId"));

            int cantidad = Integer.parseInt(
                    request.getParameter("cantidad"));

            String fechaTexto = request.getParameter("fecha");

            Date fecha;

            if (fechaTexto == null || fechaTexto.trim().isEmpty()) {
                fecha = new Date(System.currentTimeMillis());
            } else {
                fecha = Date.valueOf(fechaTexto);
            }

            if (clienteId <= 0 || productoId <= 0 || cantidad <= 0) {
                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Selecciona un cliente, un producto y una cantidad válida.");
                return;
            }

            Venta venta = new Venta();

            venta.setClienteId(clienteId);
            venta.setProductoId(productoId);
            venta.setCantidad(cantidad);
            venta.setFecha(fecha);

            // Registrar la venta y actualizar el inventario mediante el DAO.
            ventaDAO.registrar(venta);

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/ventas?resultado=ok");

        } catch (IllegalArgumentException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Los datos de la venta no son válidos. Verifica la fecha, el cliente, el producto y la cantidad.");

        } catch (SQLException e) {

            throw new ServletException(
                    "No fue posible registrar la venta.", e);
        }
    }
}