
package com.rescatemovil.servlet;

import com.rescatemovil.dao.TecnicoDAO;
import com.rescatemovil.modelo.Tecnico;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/admin/tecnicos")
public class TecnicoServlet extends HttpServlet {

    private TecnicoDAO tecnicoDAO;

    @Override
    public void init() throws ServletException {
        tecnicoDAO = new TecnicoDAO();
    }

    private boolean verificarAdministrador(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        HttpSession sesion = request.getSession(false);

        if (sesion == null || sesion.getAttribute("usuario") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return false;
        }

        String rol = String.valueOf(sesion.getAttribute("rol"));

        if (!"admin".equalsIgnoreCase(rol)) {
            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "No tienes permiso para acceder a este módulo.");
            return false;
        }

        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        if (!verificarAdministrador(request, response)) {
            return;
        }

        String accion = request.getParameter("accion");

        if ("editar".equals(accion)) {
            mostrarFormularioEditar(request, response);
        } else {
            listarTecnicos(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        if (!verificarAdministrador(request, response)) {
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String accion = request.getParameter("accion");

        if ("registrar".equals(accion)) {
            registrarTecnico(request, response);
        } else if ("actualizar".equals(accion)) {
            actualizarTecnico(request, response);
        } else if ("eliminar".equals(accion)) {
            eliminarTecnico(request, response);
        } else {
            response.sendRedirect(
                    request.getContextPath() + "/admin/tecnicos");
        }
    }

    private void listarTecnicos(HttpServletRequest request,
                                HttpServletResponse response)
            throws ServletException, IOException {

        String criterio = request.getParameter("buscar");
        List<Tecnico> tecnicos;

        if (criterio != null && !criterio.trim().isEmpty()) {
            tecnicos = tecnicoDAO.buscarTecnicos(criterio);
        } else {
            tecnicos = tecnicoDAO.listarTecnicos();
        }

        request.setAttribute("tecnicos", tecnicos);

        request.getRequestDispatcher("/admin/tecnicos.jsp")
                .forward(request, response);
    }

    private void mostrarFormularioEditar(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        int id;

        try {
            id = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/tecnicos?error=id");
            return;
        }

        Tecnico tecnico = tecnicoDAO.obtenerTecnicoPorId(id);

        if (tecnico == null) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/tecnicos?error=noencontrado");
            return;
        }

        request.setAttribute("tecnico", tecnico);

        request.getRequestDispatcher("/admin/editar-tecnico.jsp")
                .forward(request, response);
    }

    private void registrarTecnico(HttpServletRequest request,
                                  HttpServletResponse response)
            throws IOException {

        Tecnico tecnico = obtenerDatosFormulario(request);

        if (!datosValidos(tecnico)) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/tecnicos?error=campos");
            return;
        }

        tecnico.setReparacionesActivas(0);
        tecnico.setActivo(true);

        boolean registrado = tecnicoDAO.registrarTecnico(tecnico);

        if (registrado) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/tecnicos?mensaje=registrado");
        } else {
            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/tecnicos?error=registrar");
        }
    }

    private void actualizarTecnico(HttpServletRequest request,
                                   HttpServletResponse response)
            throws IOException {

        int id;

        try {
            id = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/tecnicos?error=id");
            return;
        }

        Tecnico existente = tecnicoDAO.obtenerTecnicoPorId(id);

        if (existente == null) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/tecnicos?error=noencontrado");
            return;
        }

        Tecnico tecnico = obtenerDatosFormulario(request);
        tecnico.setId(id);

        // Conservamos la relación con el usuario y el estado actual.
        tecnico.setUsuarioId(existente.getUsuarioId());
        tecnico.setReparacionesActivas(
                existente.getReparacionesActivas());
        tecnico.setActivo(existente.isActivo());

        if (!datosValidos(tecnico)) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/tecnicos?error=campos");
            return;
        }

        boolean actualizado = tecnicoDAO.actualizarTecnico(tecnico);

        if (actualizado) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/tecnicos?mensaje=actualizado");
        } else {
            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/tecnicos?error=actualizar");
        }
    }

    private void eliminarTecnico(HttpServletRequest request,
                                 HttpServletResponse response)
            throws IOException {

        int id;

        try {
            id = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/tecnicos?error=id");
            return;
        }

        boolean eliminado = tecnicoDAO.eliminarTecnico(id);

        if (eliminado) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/tecnicos?mensaje=eliminado");
        } else {
            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/tecnicos?error=eliminar");
        }
    }

    private Tecnico obtenerDatosFormulario(
            HttpServletRequest request) {

        Tecnico tecnico = new Tecnico();

        tecnico.setNombre(limpiar(request.getParameter("nombre")));
        tecnico.setEspecialidad(
                limpiar(request.getParameter("especialidad")));
        tecnico.setTelefono(limpiar(request.getParameter("telefono")));
        tecnico.setCorreo(limpiar(request.getParameter("correo")));

        return tecnico;
    }

    private boolean datosValidos(Tecnico tecnico) {
        if (tecnico.getNombre() == null
                || tecnico.getNombre().isEmpty()
                || tecnico.getEspecialidad() == null
                || tecnico.getEspecialidad().isEmpty()
                || tecnico.getTelefono() == null
                || tecnico.getTelefono().isEmpty()
                || tecnico.getCorreo() == null
                || tecnico.getCorreo().isEmpty()) {
            return false;
        }

        return tecnico.getCorreo().matches(
                "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    }

    private String limpiar(String valor) {
        return valor == null ? "" : valor.trim();
    }
}
