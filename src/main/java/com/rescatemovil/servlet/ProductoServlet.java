
package com.rescatemovil.servlet;

import com.rescatemovil.dao.ProductoDAO;
import com.rescatemovil.modelo.Producto;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/admin/productos")
public class ProductoServlet extends HttpServlet {

    private ProductoDAO productoDAO;

    private static final Pattern PATRON_PRECIO =
            Pattern.compile("^\\d{1,10}(\\.\\d{1,2})?$");

    @Override
    public void init() throws ServletException {
        productoDAO = new ProductoDAO();
    }

    private boolean esAdministrador(HttpServletRequest request) {
        HttpSession sesion = request.getSession(false);

        return sesion != null
                && sesion.getAttribute("usuario") != null
                && "admin".equalsIgnoreCase(
                        String.valueOf(sesion.getAttribute("rol")));
    }

    private void redirigirLogin(HttpServletRequest request,
                                HttpServletResponse response)
            throws IOException {

        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        if (!esAdministrador(request)) {
            redirigirLogin(request, response);
            return;
        }

        String accion = request.getParameter("accion");

        if ("editar".equals(accion)) {
            mostrarEdicion(request, response);
            return;
        }

        String termino = request.getParameter("buscar");
        List<Producto> productos;

        if (termino != null && !termino.trim().isEmpty()) {
            productos = productoDAO.buscarProductos(termino);
        } else {
            productos = productoDAO.listarProductos();
        }

        request.setAttribute("productos", productos);

        request.getRequestDispatcher("/admin/productos.jsp")
                .forward(request, response);
    }

    private void mostrarEdicion(HttpServletRequest request,
                                HttpServletResponse response)
            throws ServletException, IOException {

        String idTexto = request.getParameter("id");

        try {
            int id = Integer.parseInt(idTexto);

            if (id <= 0) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/productos?error=id");
                return;
            }

            Producto producto = productoDAO.obtenerProductoPorId(id);

            if (producto == null) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/productos?error=no_encontrado");
                return;
            }

            request.setAttribute("producto", producto);

            request.getRequestDispatcher("/admin/editar-producto.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/productos?error=id");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        if (!esAdministrador(request)) {
            redirigirLogin(request, response);
            return;
        }

        String accion = request.getParameter("accion");

        if ("registrar".equals(accion)) {
            registrarProducto(request, response);
        } else if ("actualizar".equals(accion)) {
            actualizarProducto(request, response);
        } else if ("eliminar".equals(accion)) {
            eliminarProducto(request, response);
        } else {
            response.sendRedirect(request.getContextPath()
                    + "/admin/productos?error=accion");
        }
    }

    private void registrarProducto(HttpServletRequest request,
                                   HttpServletResponse response)
            throws IOException {

        try {
            Producto producto = obtenerDatosFormulario(request);

            if (!datosValidos(producto)) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/nuevo-producto.jsp?error=datos");
                return;
            }

            producto.setActivo(true);

            if (productoDAO.registrarProducto(producto)) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/productos?mensaje=registrado");
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/admin/nuevo-producto.jsp?error=registrar");
            }

        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/nuevo-producto.jsp?error=datos");
        }
    }

    private void actualizarProducto(HttpServletRequest request,
                                    HttpServletResponse response)
            throws IOException {

        String idTexto = request.getParameter("id");

        try {
            int id = Integer.parseInt(idTexto);

            if (id <= 0) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/productos?error=id");
                return;
            }

            Producto existente = productoDAO.obtenerProductoPorId(id);

            if (existente == null) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/productos?error=no_encontrado");
                return;
            }

            Producto datos = obtenerDatosFormulario(request);

            if (!datosValidos(datos)) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/editar-producto.jsp?id=" + id
                        + "&error=datos");
                return;
            }

            datos.setId(id);
            datos.setActivo(request.getParameter("activo") == null
                    ? existente.isActivo()
                    : "true".equals(request.getParameter("activo"))
                    || "1".equals(request.getParameter("activo"))
                    || "on".equals(request.getParameter("activo")));

            if (productoDAO.actualizarProducto(datos)) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/productos?mensaje=actualizado");
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/admin/tecnicos?error=actualizar");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/productos?error=id");
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/productos?error=datos");
        }
    }

    private void eliminarProducto(HttpServletRequest request,
                                  HttpServletResponse response)
            throws IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));

            if (id <= 0) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/productos?error=id");
                return;
            }

            if (productoDAO.eliminarProducto(id)) {
                response.sendRedirect(request.getContextPath()
                        + "/admin/productos?mensaje=eliminado");
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/admin/productos?error=eliminar");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/productos?error=id");
        }
    }

    private Producto obtenerDatosFormulario(HttpServletRequest request) {

        String nombre = limpiar(request.getParameter("nombre"));
        String descripcion = limpiar(request.getParameter("descripcion"));
        String precioTexto = limpiar(request.getParameter("precio"));
        String stockTexto = limpiar(request.getParameter("stock"));
        String categoria = limpiar(request.getParameter("categoria"));

        if (nombre.isEmpty()
                || descripcion.isEmpty()
                || precioTexto.isEmpty()
                || stockTexto.isEmpty()) {
            throw new IllegalArgumentException("Faltan campos obligatorios.");
        }

        if (!PATRON_PRECIO.matcher(precioTexto).matches()) {
            throw new IllegalArgumentException("El precio no es válido.");
        }

        BigDecimal precio = new BigDecimal(precioTexto);

        int stock;

        try {
            stock = Integer.parseInt(stockTexto);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("El stock no es válido.");
        }

        if (precio.compareTo(BigDecimal.ZERO) < 0
                || precio.compareTo(new BigDecimal("9999999999.99")) > 0
                || stock < 0) {
            throw new IllegalArgumentException("Precio o stock fuera de rango.");
        }

        Producto producto = new Producto();

        producto.setNombre(nombre);
        producto.setDescripcion(descripcion);
        producto.setPrecio(precio);
        producto.setStock(stock);
        producto.setCategoria(categoria.isEmpty() ? null : categoria);

        return producto;
    }

    private boolean datosValidos(Producto producto) {
        return producto.getNombre() != null
                && !producto.getNombre().trim().isEmpty()
                && producto.getNombre().length() <= 180
                && producto.getDescripcion() != null
                && !producto.getDescripcion().trim().isEmpty()
                && producto.getPrecio() != null
                && producto.getPrecio().compareTo(BigDecimal.ZERO) >= 0
                && producto.getStock() >= 0
                && (producto.getCategoria() == null
                    || producto.getCategoria().length() <= 80);
    }

    private String limpiar(String valor) {
        return valor == null ? "" : valor.trim();
    }
}
