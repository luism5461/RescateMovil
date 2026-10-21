
package com.rescatemovil.servlet;

import com.rescatemovil.dao.ClienteDAO;
import com.rescatemovil.dao.ReparacionDAO;
import com.rescatemovil.dao.TecnicoDAO;
import com.rescatemovil.modelo.Reparacion;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.Arrays;
import java.util.List;

@WebServlet("/admin/reparaciones")
public class ReparacionServlet extends HttpServlet {

    private ReparacionDAO reparacionDAO;
    private ClienteDAO clienteDAO;
    private TecnicoDAO tecnicoDAO;

    private static final List<String> ESTADOS = Arrays.asList(
        "Recibido",
        "En proceso",
        "Listo para recoger",
        "Finalizado",
        "Entregado"
    );

    private static final List<String> METODOS_PAGO = Arrays.asList(
        "Nequi",
        "Daviplata",
        "PSE / Tarjeta",
        "Efectivo"
    );

    @Override
    public void init() throws ServletException {
        reparacionDAO = new ReparacionDAO();
        clienteDAO = new ClienteDAO();
        tecnicoDAO = new TecnicoDAO();
    }

    private boolean esAdministrador(HttpServletRequest request) {
        HttpSession sesion = request.getSession(false);

        return sesion != null
            && sesion.getAttribute("usuario") != null
            && "admin".equalsIgnoreCase(
                String.valueOf(sesion.getAttribute("rol"))
            );
    }

    private void cargarListasFormulario(
            HttpServletRequest request) {

        request.setAttribute(
            "clientes",
            clienteDAO.listarClientes()
        );

        request.setAttribute(
            "tecnicos",
            tecnicoDAO.listarTecnicos()
        );

        request.setAttribute("estados", ESTADOS);
        request.setAttribute("metodosPago", METODOS_PAGO);
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        if (!esAdministrador(request)) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        String accion = request.getParameter("accion");

        if ("nuevo".equals(accion)) {
            cargarListasFormulario(request);

            request.getRequestDispatcher(
                "/admin/nueva-reparacion.jsp"
            ).forward(request, response);

            return;
        }

        if ("editar".equals(accion)) {
            mostrarEdicion(request, response);
            return;
        }

        String busqueda = request.getParameter("buscar");

        List<Reparacion> reparaciones;

        if (busqueda != null && !busqueda.trim().isEmpty()) {
            reparaciones = reparacionDAO.buscarReparaciones(
                busqueda.trim()
            );
        } else {
            reparaciones = reparacionDAO.listarReparaciones();
        }

        request.setAttribute("reparaciones", reparaciones);
        request.setAttribute(
            "buscar",
            busqueda == null ? "" : busqueda
        );
        request.setAttribute("estados", ESTADOS);
        request.setAttribute("metodosPago", METODOS_PAGO);

        request.getRequestDispatcher(
            "/admin/reparaciones.jsp"
        ).forward(request, response);
    }

    private void mostrarEdicion(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        int id;

        try {
            id = Integer.parseInt(
                request.getParameter("id")
            );

            if (id <= 0) {
                throw new NumberFormatException();
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(
                request.getContextPath()
                + "/admin/reparaciones?error=id"
            );
            return;
        }

        Reparacion reparacion =
            reparacionDAO.obtenerReparacionPorId(id);

        if (reparacion == null) {
            response.sendRedirect(
                request.getContextPath()
                + "/admin/reparaciones?error=no_encontrada"
            );
            return;
        }

        cargarListasFormulario(request);
        request.setAttribute("reparacion", reparacion);

        request.getRequestDispatcher(
            "/admin/editar-reparacion.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        if (!esAdministrador(request)) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        String accion = request.getParameter("accion");

        if ("registrar".equals(accion)) {
            registrar(request, response);

        } else if ("actualizar".equals(accion)) {
            actualizar(request, response);

        } else if ("cambiarEstado".equals(accion)) {
            cambiarEstado(request, response);

        } else if ("eliminar".equals(accion)) {
            eliminar(request, response);

        } else {
            response.sendRedirect(
                request.getContextPath()
                + "/admin/reparaciones?error=accion"
            );
        }
    }

    private Reparacion obtenerDatosFormulario(
            HttpServletRequest request) {

        Reparacion reparacion = new Reparacion();

        String clienteTexto = request.getParameter("clienteId");
        String tecnicoTexto = request.getParameter("tecnicoId");
        String equipo = request.getParameter("equipo");
        String falla = request.getParameter("falla");
        String fechaIngresoTexto =
            request.getParameter("fechaIngreso");
        String fechaEntregaTexto =
            request.getParameter("fechaEntrega");
        String estado = request.getParameter("estado");
        String costoTexto = request.getParameter("costo");
        String pagadoTexto = request.getParameter("pagado");
        String metodoPago = request.getParameter("metodoPago");

        // Datos adicionales del equipo.
        String marca = request.getParameter("marca");
        String modelo = request.getParameter("modelo");
        String imei = request.getParameter("imei");
        String serialEquipo = request.getParameter("serialEquipo");
        String color = request.getParameter("color");
        String almacenamiento = request.getParameter("almacenamiento");
        String estadoFisico = request.getParameter("estadoFisico");
        String accesorios = request.getParameter("accesorios");
        String diagnostico = request.getParameter("diagnostico");
        String observaciones = request.getParameter("observaciones");

        if (vacio(clienteTexto)
                || vacio(tecnicoTexto)
                || vacio(equipo)
                || vacio(falla)
                || vacio(fechaIngresoTexto)
                || vacio(costoTexto)) {

            throw new IllegalArgumentException(
                "Completa los campos obligatorios."
            );
        }

        try {
            int clienteId = Integer.parseInt(clienteTexto.trim());
            int tecnicoId = Integer.parseInt(tecnicoTexto.trim());

            if (clienteId <= 0 || tecnicoId <= 0) {
                throw new IllegalArgumentException(
                    "Selecciona un cliente y un técnico válidos."
                );
            }

            reparacion.setClienteId(clienteId);
            reparacion.setTecnicoId(tecnicoId);

            Date fechaIngreso = Date.valueOf(
                fechaIngresoTexto.trim()
            );

            reparacion.setFechaIngreso(fechaIngreso);

            if (!vacio(fechaEntregaTexto)) {
                Date fechaEntrega = Date.valueOf(
                    fechaEntregaTexto.trim()
                );

                if (fechaEntrega.before(fechaIngreso)) {
                    throw new IllegalArgumentException(
                        "La fecha de entrega no puede ser anterior "
                        + "a la fecha de ingreso."
                    );
                }

                reparacion.setFechaEntrega(fechaEntrega);
            } else {
                reparacion.setFechaEntrega(null);
            }

            BigDecimal costo = new BigDecimal(
                costoTexto.trim()
            );

            if (costo.compareTo(BigDecimal.ZERO) < 0) {
                throw new IllegalArgumentException(
                    "El costo no puede ser negativo."
                );
            }

            reparacion.setCosto(costo);

        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(
                "El cliente, el técnico o el costo tienen un formato inválido."
            );
        } catch (IllegalArgumentException e) {
            throw e;
        }

        if (estado == null || !ESTADOS.contains(estado)) {
            throw new IllegalArgumentException(
                "Selecciona un estado de reparación válido."
            );
        }

        reparacion.setEquipo(equipo.trim());
        reparacion.setFalla(falla.trim());
        reparacion.setEstado(estado);

        // Guardar los detalles del equipo.
        reparacion.setMarca(textoONull(marca));
        reparacion.setModelo(textoONull(modelo));
        reparacion.setImei(textoONull(imei));
        reparacion.setSerialEquipo(textoONull(serialEquipo));
        reparacion.setColor(textoONull(color));
        reparacion.setAlmacenamiento(textoONull(almacenamiento));
        reparacion.setEstadoFisico(textoONull(estadoFisico));
        reparacion.setAccesorios(textoONull(accesorios));
        reparacion.setDiagnostico(textoONull(diagnostico));
        reparacion.setObservaciones(textoONull(observaciones));

        boolean pagado =
            "true".equalsIgnoreCase(pagadoTexto)
            || "on".equalsIgnoreCase(pagadoTexto)
            || "1".equals(pagadoTexto);

        reparacion.setPagado(pagado);

        if (pagado) {
            if (metodoPago == null
                    || !METODOS_PAGO.contains(metodoPago)) {
                throw new IllegalArgumentException(
                    "Selecciona un método de pago válido."
                );
            }

            reparacion.setMetodoPago(metodoPago);
            reparacion.setFechaPago(
                new Timestamp(System.currentTimeMillis())
            );

        } else {
            reparacion.setMetodoPago(null);
            reparacion.setFechaPago(null);
        }

        return reparacion;
    }

    private boolean vacio(String valor) {
        return valor == null || valor.trim().isEmpty();
    }

    private String textoONull(String valor) {
        if (valor == null || valor.trim().isEmpty()) {
            return null;
        }

        return valor.trim();
    }

    private void registrar(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        String context = request.getContextPath();

        try {
            Reparacion reparacion =
                obtenerDatosFormulario(request);

            reparacion.setCodigo(null);

            boolean registrado =
                reparacionDAO.registrarReparacion(reparacion);

            if (registrado) {
                response.sendRedirect(
                    context
                    + "/admin/reparaciones?mensaje=registrada"
                );
            } else {
                response.sendRedirect(
                    context
                    + "/admin/reparaciones?accion=nuevo&error=registrar"
                );
            }

        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                context
                + "/admin/reparaciones?accion=nuevo&error=datos"
            );
        }
    }

    private void actualizar(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        String context = request.getContextPath();

        try {
            int id = Integer.parseInt(
                request.getParameter("id")
            );

            if (id <= 0) {
                throw new NumberFormatException();
            }

            Reparacion reparacion =
                obtenerDatosFormulario(request);

            reparacion.setId(id);

            Reparacion anterior =
                reparacionDAO.obtenerReparacionPorId(id);

            if (anterior == null) {
                response.sendRedirect(
                    context
                    + "/admin/reparaciones?error=no_encontrada"
                );
                return;
            }

            reparacion.setCodigo(anterior.getCodigo());

            boolean actualizado =
                reparacionDAO.actualizarReparacion(reparacion);

            if (actualizado) {
                response.sendRedirect(
                    context
                    + "/admin/reparaciones?mensaje=actualizada"
                );
            } else {
                response.sendRedirect(
                    context
                    + "/admin/reparaciones?accion=editar&id="
                    + id
                    + "&error=actualizar"
                );
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(
                context + "/admin/reparaciones?error=id"
            );

        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                context
                + "/admin/reparaciones?accion=editar&id="
                + request.getParameter("id")
                + "&error=datos"
            );
        }
    }

    private void cambiarEstado(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        String context = request.getContextPath();

        try {
            int id = Integer.parseInt(
                request.getParameter("id")
            );

            String estado = request.getParameter("estado");

            if (id <= 0 || estado == null
                    || !ESTADOS.contains(estado)) {
                response.sendRedirect(
                    context + "/admin/reparaciones?error=datos"
                );
                return;
            }

            boolean actualizado =
                reparacionDAO.actualizarEstado(id, estado);

            response.sendRedirect(
                context
                + "/admin/reparaciones?mensaje="
                + (actualizado
                    ? "estado_actualizado"
                    : "actualizar")
            );

        } catch (NumberFormatException e) {
            response.sendRedirect(
                context + "/admin/reparaciones?error=id"
            );
        }
    }

    private void eliminar(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        String context = request.getContextPath();

        try {
            int id = Integer.parseInt(
                request.getParameter("id")
            );

            if (id <= 0) {
                throw new NumberFormatException();
            }

            boolean eliminado =
                reparacionDAO.eliminarReparacion(id);

            response.sendRedirect(
                context
                + "/admin/reparaciones?mensaje="
                + (eliminado
                    ? "eliminada"
                    : "error_eliminar")
            );

        } catch (NumberFormatException e) {
            response.sendRedirect(
                context + "/admin/reparaciones?error=id"
            );
        }
    }
}