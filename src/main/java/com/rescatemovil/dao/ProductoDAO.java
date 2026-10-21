
package com.rescatemovil.dao;

import com.rescatemovil.config.Conexion;
import com.rescatemovil.modelo.Producto;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ProductoDAO {

    public List<Producto> listarProductos() {
        List<Producto> productos = new ArrayList<>();

        String sql = "SELECT id, nombre, descripcion, precio, stock, "
                   + "categoria, activo, fecha_registro "
                   + "FROM productos ORDER BY id DESC";

        try (Connection conexion = Conexion.getConexion();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                productos.add(mapearProducto(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error al listar productos: " + e.getMessage());
            e.printStackTrace();
        }

        return productos;
    }

    public Producto obtenerProductoPorId(int id) {
        String sql = "SELECT id, nombre, descripcion, precio, stock, "
                   + "categoria, activo, fecha_registro "
                   + "FROM productos WHERE id = ?";

        try (Connection conexion = Conexion.getConexion();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearProducto(rs);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error al consultar producto: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    public boolean registrarProducto(Producto producto) {
        String sql = "INSERT INTO productos "
                   + "(nombre, descripcion, precio, stock, categoria, activo) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conexion = Conexion.getConexion();
             PreparedStatement ps = conexion.prepareStatement(
                     sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, producto.getNombre());
            ps.setString(2, producto.getDescripcion());
            ps.setBigDecimal(3, producto.getPrecio());
            ps.setInt(4, producto.getStock());

            if (producto.getCategoria() == null
                    || producto.getCategoria().trim().isEmpty()) {
                ps.setNull(5, java.sql.Types.VARCHAR);
            } else {
                ps.setString(5, producto.getCategoria().trim());
            }

            ps.setBoolean(6, producto.isActivo());

            int filas = ps.executeUpdate();

            if (filas > 0) {
                try (ResultSet claves = ps.getGeneratedKeys()) {
                    if (claves.next()) {
                        producto.setId(claves.getInt(1));
                    }
                }
                return true;
            }

        } catch (SQLException e) {
            System.err.println("Error al registrar producto: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    public boolean actualizarProducto(Producto producto) {
        String sql = "UPDATE productos SET nombre = ?, descripcion = ?, "
                   + "precio = ?, stock = ?, categoria = ?, activo = ? "
                   + "WHERE id = ?";

        try (Connection conexion = Conexion.getConexion();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, producto.getNombre());
            ps.setString(2, producto.getDescripcion());
            ps.setBigDecimal(3, producto.getPrecio());
            ps.setInt(4, producto.getStock());

            if (producto.getCategoria() == null
                    || producto.getCategoria().trim().isEmpty()) {
                ps.setNull(5, java.sql.Types.VARCHAR);
            } else {
                ps.setString(5, producto.getCategoria().trim());
            }

            ps.setBoolean(6, producto.isActivo());
            ps.setInt(7, producto.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al actualizar producto: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    public boolean eliminarProducto(int id) {
        String sql = "DELETE FROM productos WHERE id = ?";

        try (Connection conexion = Conexion.getConexion();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setInt(1, id);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al eliminar producto: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    public List<Producto> buscarProductos(String termino) {
        List<Producto> productos = new ArrayList<>();

        String sql = "SELECT id, nombre, descripcion, precio, stock, "
                   + "categoria, activo, fecha_registro "
                   + "FROM productos "
                   + "WHERE nombre LIKE ? "
                   + "OR descripcion LIKE ? "
                   + "OR categoria LIKE ? "
                   + "ORDER BY id DESC";

        String busqueda = "%" + (termino == null ? "" : termino.trim()) + "%";

        try (Connection conexion = Conexion.getConexion();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, busqueda);
            ps.setString(2, busqueda);
            ps.setString(3, busqueda);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    productos.add(mapearProducto(rs));
                }
            }

        } catch (SQLException e) {
            System.err.println("Error al buscar productos: " + e.getMessage());
            e.printStackTrace();
        }

        return productos;
    }

    private Producto mapearProducto(ResultSet rs) throws SQLException {
        Producto producto = new Producto();

        producto.setId(rs.getInt("id"));
        producto.setNombre(rs.getString("nombre"));
        producto.setDescripcion(rs.getString("descripcion"));
        producto.setPrecio(rs.getBigDecimal("precio"));
        producto.setStock(rs.getInt("stock"));
        producto.setCategoria(rs.getString("categoria"));
        producto.setActivo(rs.getBoolean("activo"));
        producto.setFechaRegistro(rs.getTimestamp("fecha_registro"));

        return producto;
    }
}
