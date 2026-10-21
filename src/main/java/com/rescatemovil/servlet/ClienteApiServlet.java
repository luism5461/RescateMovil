
package com.rescatemovil.servlet;

import com.google.gson.Gson;
import com.google.gson.JsonParseException;
import com.rescatemovil.dao.ClienteDAO;
import com.rescatemovil.modelo.cliente;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * API REST de clientes de Rescate Móvil.
 *
 * GET    /api/v1/clientes       Lista los clientes.
 * GET    /api/v1/clientes/{id}  Consulta un cliente.
 * POST   /api/v1/clientes       Registra un cliente.
 * PUT    /api/v1/clientes/{id}  Actualiza un cliente.
 * DELETE /api/v1/clientes/{id}  Elimina un cliente.
 *
 * Compatible con Java 21 y Apache Tomcat 9.
 */
@WebServlet(
        name = "ClienteApiServlet",
        urlPatterns = {"/api/v1/clientes/*"}
)
public class ClienteApiServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ClienteDAO clienteDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        clienteDAO = new ClienteDAO();
        gson = new Gson();

        log("ClienteApiServlet iniciado correctamente.");
    }

    /**
     * Registra cada petición que llega a este servlet.
     * Permite comprobar en la consola si Tomcat ejecuta esta clase.
     */
    @Override
    protected void service(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        log("API REST recibida: método=" + request.getMethod()
                + ", URI=" + request.getRequestURI()
                + ", pathInfo=" + request.getPathInfo());

        super.service(request, response);
    }

    /**
     * Configura las respuestas como JSON UTF-8.
     */
    private void configurarRespuesta(HttpServletResponse response) {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-store");
    }

    /**
     * Envía un mensaje JSON con el código HTTP indicado.
     */
    private void responderMensaje(
            HttpServletResponse response,
            int estado,
            String mensaje) throws IOException {

        response.setStatus(estado);
        response.getWriter().write(
                gson.toJson(new MensajeRespuesta(mensaje))
        );
    }

    /**
     * Lee el cuerpo JSON de la solicitud.
     */
    private String leerCuerpo(HttpServletRequest request)
            throws IOException {

        try (BufferedReader reader = request.getReader()) {
            return reader.lines()
                    .collect(Collectors.joining("\n"))
                    .trim();
        }
    }

    /**
     * Obtiene el ID de la ruta.
     * Ejemplo: /api/v1/clientes/5 devuelve 5.
     *
     * Devuelve null si no se indicó ID.
     * Devuelve -1 si el ID no es válido.
     */
    private Integer obtenerId(HttpServletRequest request) {

        String ruta = request.getPathInfo();

        if (ruta == null || ruta.isEmpty() || "/".equals(ruta)) {
            return null;
        }

        if (!ruta.startsWith("/")) {
            return -1;
        }

        String valor = ruta.substring(1);

        if (valor.isEmpty() || valor.contains("/")) {
            return -1;
        }

        try {
            int id = Integer.parseInt(valor);
            return id > 0 ? id : -1;
        } catch (NumberFormatException e) {
            return -1;
        }
    }

    /**
     * Valida los campos obligatorios.
     */
    private String validarCliente(cliente c) {

        if (c == null) {
            return "El cuerpo JSON no contiene un cliente válido.";
        }

        if (c.getNombre() == null
                || c.getNombre().trim().isEmpty()) {
            return "El campo nombre es obligatorio.";
        }

        if (c.getApellido() == null
                || c.getApellido().trim().isEmpty()) {
            return "El campo apellido es obligatorio.";
        }

        if (c.getDocumento() == null
                || c.getDocumento().trim().isEmpty()) {
            return "El campo documento es obligatorio.";
        }

        return null;
    }

    /**
     * GET: lista todos los clientes o consulta uno por su ID.
     */
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        configurarRespuesta(response);

        try {
            Integer id = obtenerId(request);

            if (id == null) {
                List<cliente> clientes = clienteDAO.listarClientes();

                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write(gson.toJson(clientes));
                return;
            }

            if (id < 1) {
                responderMensaje(response,
                        HttpServletResponse.SC_BAD_REQUEST,
                        "El ID del cliente no es válido.");
                return;
            }

            cliente encontrado = clienteDAO.obtenerClientePorId(id);

            if (encontrado == null) {
                responderMensaje(response,
                        HttpServletResponse.SC_NOT_FOUND,
                        "No se encontró el cliente solicitado.");
                return;
            }

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(gson.toJson(encontrado));

        } catch (Exception e) {
            log("Error al consultar clientes mediante la API.", e);

            responderMensaje(response,
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Ocurrió un error al consultar los clientes.");
        }
    }

    /**
     * POST: registra un cliente nuevo.
     */
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        configurarRespuesta(response);
        request.setCharacterEncoding("UTF-8");

        try {
            Integer id = obtenerId(request);

            if (id != null) {
                responderMensaje(response,
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Para registrar utilice /api/v1/clientes sin ID.");
                return;
            }

            String cuerpoJSON = leerCuerpo(request);

            log("JSON recibido para registrar cliente: " + cuerpoJSON);

            if (cuerpoJSON.isEmpty()) {
                responderMensaje(response,
                        HttpServletResponse.SC_BAD_REQUEST,
                        "El cuerpo de la solicitud está vacío.");
                return;
            }

            cliente nuevoCliente = gson.fromJson(
                    cuerpoJSON, cliente.class);

            String error = validarCliente(nuevoCliente);

            if (error != null) {
                responderMensaje(response,
                        HttpServletResponse.SC_BAD_REQUEST, error);
                return;
            }

            boolean registrado =
                    clienteDAO.registrarCliente(nuevoCliente);

            if (registrado) {
                responderMensaje(response,
                        HttpServletResponse.SC_CREATED,
                        "Cliente registrado correctamente.");
            } else {
                responderMensaje(response,
                        HttpServletResponse.SC_BAD_REQUEST,
                        "No fue posible registrar el cliente.");
            }

        } catch (JsonParseException e) {
            responderMensaje(response,
                    HttpServletResponse.SC_BAD_REQUEST,
                    "El JSON enviado no tiene un formato válido.");

        } catch (Exception e) {
            log("Error al registrar un cliente mediante la API.", e);

            responderMensaje(response,
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Ocurrió un error interno al registrar el cliente.");
        }
    }

    /**
     * PUT: actualiza un cliente utilizando el ID de la URL.
     */
    @Override
    protected void doPut(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        configurarRespuesta(response);
        request.setCharacterEncoding("UTF-8");

        log(">>> SE EJECUTÓ doPut DE ClienteApiServlet <<<");

        try {
            Integer id = obtenerId(request);

            if (id == null || id < 1) {
                responderMensaje(response,
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Indique un ID válido: /api/v1/clientes/{id}.");
                return;
            }

            String cuerpoJSON = leerCuerpo(request);

            log("JSON recibido para actualizar cliente " + id
                    + ": " + cuerpoJSON);

            if (cuerpoJSON.isEmpty()) {
                responderMensaje(response,
                        HttpServletResponse.SC_BAD_REQUEST,
                        "El cuerpo JSON está vacío.");
                return;
            }

            cliente actualizado = gson.fromJson(
                    cuerpoJSON, cliente.class);

            String error = validarCliente(actualizado);

            if (error != null) {
                responderMensaje(response,
                        HttpServletResponse.SC_BAD_REQUEST, error);
                return;
            }

            cliente existente = clienteDAO.obtenerClientePorId(id);

            if (existente == null) {
                responderMensaje(response,
                        HttpServletResponse.SC_NOT_FOUND,
                        "No se encontró el cliente que desea actualizar.");
                return;
            }

            // El ID de la URL define el registro que se actualizará.
            actualizado.setId(id);

            boolean resultado =
                    clienteDAO.actualizarCliente(actualizado);

            if (resultado) {
                responderMensaje(response,
                        HttpServletResponse.SC_OK,
                        "Cliente actualizado correctamente.");
            } else {
                responderMensaje(response,
                        HttpServletResponse.SC_BAD_REQUEST,
                        "No fue posible actualizar el cliente.");
            }

        } catch (JsonParseException e) {
            responderMensaje(response,
                    HttpServletResponse.SC_BAD_REQUEST,
                    "El JSON enviado no tiene un formato válido.");

        } catch (Exception e) {
            log("Error al actualizar un cliente mediante la API.", e);

            responderMensaje(response,
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Ocurrió un error interno al actualizar el cliente.");
        }
    }

    /**
     * DELETE: elimina el cliente indicado por el ID.
     */
    @Override
    protected void doDelete(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        configurarRespuesta(response);

        log(">>> SE EJECUTÓ doDelete DE ClienteApiServlet <<<");

        try {
            Integer id = obtenerId(request);

            if (id == null || id < 1) {
                responderMensaje(response,
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Indique un ID válido para eliminar el cliente.");
                return;
            }

            cliente existente = clienteDAO.obtenerClientePorId(id);

            if (existente == null) {
                responderMensaje(response,
                        HttpServletResponse.SC_NOT_FOUND,
                        "No se encontró el cliente que desea eliminar.");
                return;
            }

            boolean eliminado = clienteDAO.eliminarCliente(id);

            if (eliminado) {
                responderMensaje(response,
                        HttpServletResponse.SC_OK,
                        "Cliente eliminado correctamente.");
            } else {
                responderMensaje(response,
                        HttpServletResponse.SC_BAD_REQUEST,
                        "No fue posible eliminar el cliente.");
            }

        } catch (Exception e) {
            log("Error al eliminar un cliente mediante la API.", e);

            responderMensaje(response,
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Ocurrió un error interno al eliminar el cliente.");
        }
    }

    /**
     * Devuelve mensajes con una estructura JSON uniforme.
     */
    private static class MensajeRespuesta {

        private final String mensaje;

        public MensajeRespuesta(String mensaje) {
            this.mensaje = mensaje;
        }

        public String getMensaje() {
            return mensaje;
        }
    }
}
