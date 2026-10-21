
package com.rescatemovil.dao;

import com.rescatemovil.config.Conexion;
import com.rescatemovil.modelo.Venta;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class VentaDAO {

    // =====================================================
    // LISTAR TODAS LAS VENTAS
    // =====================================================
    public List<Venta> listar() throws SQLException {
        List<Venta> ventas = new ArrayList<>();

        String sql =
            "SELECT v.id, v.fecha, v.cliente_id, v.producto_id, " +
            "v.cantidad, v.precio_unitario, v.total, " +
            "CONCAT(c.nombre, ' ', c.apellido) AS cliente_nombre, " +
            "p.nombre AS producto_nombre " +
            "FROM ventas v " +
            "INNER JOIN clientes c ON c.id = v.cliente_id " +
            "INNER JOIN productos p ON p.id = v.producto_id " +
            "ORDER BY v.id DESC";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ventas.add(mapearVenta(rs));
            }
        }

        return ventas;
    }

    // =====================================================
    // BUSCAR VENTAS POR CLIENTE, PRODUCTO, NÚMERO Y FECHAS
    // =====================================================
    public List<Venta> buscar(
            String texto,
            Date fechaDesde,
            Date fechaHasta) throws SQLException {

        List<Venta> ventas = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
            "SELECT v.id, v.fecha, v.cliente_id, v.producto_id, " +
            "v.cantidad, v.precio_unitario, v.total, " +
            "CONCAT(c.nombre, ' ', c.apellido) AS cliente_nombre, " +
            "p.nombre AS producto_nombre " +
            "FROM ventas v " +
            "INNER JOIN clientes c ON c.id = v.cliente_id " +
            "INNER JOIN productos p ON p.id = v.producto_id " +
            "WHERE 1 = 1 "
        );

        boolean buscarTexto =
            texto != null && !texto.trim().isEmpty();

        if (buscarTexto) {
            sql.append(
                "AND (" +
                "CONCAT(c.nombre, ' ', c.apellido) LIKE ? " +
                "OR p.nombre LIKE ? " +
                "OR CAST(v.id AS CHAR) LIKE ?" +
                ") "
            );
        }

        if (fechaDesde != null) {
            sql.append("AND v.fecha >= ? ");
        }

        if (fechaHasta != null) {
            sql.append("AND v.fecha <= ? ");
        }

        sql.append("ORDER BY v.id DESC");

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps =
                 con.prepareStatement(sql.toString())) {

            int parametro = 1;

            if (buscarTexto) {
                String patron = "%" + texto.trim() + "%";

                ps.setString(parametro++, patron);
                ps.setString(parametro++, patron);
                ps.setString(parametro++, patron);
            }

            if (fechaDesde != null) {
                ps.setDate(parametro++, fechaDesde);
            }

            if (fechaHasta != null) {
                ps.setDate(parametro++, fechaHasta);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ventas.add(mapearVenta(rs));
                }
            }
        }

        return ventas;
    }

    // =====================================================
    // CONSULTAR UNA VENTA POR SU NÚMERO
    // =====================================================
    public Venta buscarPorId(int id) throws SQLException {

        String sql =
            "SELECT v.id, v.fecha, v.cliente_id, v.producto_id, " +
            "v.cantidad, v.precio_unitario, v.total, " +
            "CONCAT(c.nombre, ' ', c.apellido) AS cliente_nombre, " +
            "p.nombre AS producto_nombre " +
            "FROM ventas v " +
            "INNER JOIN clientes c ON c.id = v.cliente_id " +
            "INNER JOIN productos p ON p.id = v.producto_id " +
            "WHERE v.id = ?";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearVenta(rs);
                }
            }
        }

        return null;
    }

    // =====================================================
    // CONVERTIR UNA FILA DE MYSQL EN UN OBJETO VENTA
    // =====================================================
    private Venta mapearVenta(ResultSet rs) throws SQLException {
        Venta venta = new Venta();

        venta.setId(rs.getInt("id"));
        venta.setFecha(rs.getDate("fecha"));
        venta.setClienteId(rs.getInt("cliente_id"));
        venta.setProductoId(rs.getInt("producto_id"));
        venta.setCantidad(rs.getInt("cantidad"));

        venta.setPrecioUnitario(
            rs.getBigDecimal("precio_unitario")
        );

        venta.setTotal(
            rs.getBigDecimal("total")
        );

        venta.setClienteNombre(
            rs.getString("cliente_nombre")
        );

        venta.setProductoNombre(
            rs.getString("producto_nombre")
        );

        return venta;
    }

    // =====================================================
    // REGISTRAR UNA VENTA Y DESCONTAR EL INVENTARIO
    // =====================================================
    public boolean registrar(Venta venta) throws SQLException {

        String sqlProducto =
            "SELECT precio, stock, activo FROM productos " +
            "WHERE id = ? FOR UPDATE";

        String sqlVenta =
            "INSERT INTO ventas " +
            "(fecha, cliente_id, producto_id, cantidad, " +
            "precio_unitario, total) VALUES (?, ?, ?, ?, ?, ?)";

        String sqlStock =
            "UPDATE productos SET stock = stock - ? " +
            "WHERE id = ? AND stock >= ? AND activo = 1";

        try (Connection con = Conexion.getConexion()) {
            con.setAutoCommit(false);

            try {
                BigDecimal precio;
                int stock;
                int activo;

                // Consultar y bloquear el producto durante la transacción.
                try (PreparedStatement ps =
                         con.prepareStatement(sqlProducto)) {

                    ps.setInt(1, venta.getProductoId());

                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            throw new SQLException(
                                "El producto seleccionado no existe."
                            );
                        }

                        precio = rs.getBigDecimal("precio");
                        stock = rs.getInt("stock");
                        activo = rs.getInt("activo");
                    }
                }

                if (activo != 1) {
                    throw new SQLException(
                        "El producto está inactivo."
                    );
                }

                if (venta.getCantidad() <= 0) {
                    throw new SQLException(
                        "La cantidad debe ser mayor que cero."
                    );
                }

                if (stock < venta.getCantidad()) {
                    throw new SQLException(
                        "Stock insuficiente. Existencias disponibles: "
                        + stock
                    );
                }

                Date fecha = venta.getFecha();

                if (fecha == null) {
                    fecha = new Date(System.currentTimeMillis());
                }

                BigDecimal total = precio.multiply(
                    BigDecimal.valueOf(venta.getCantidad())
                );

                // Insertar la venta.
                try (PreparedStatement ps =
                         con.prepareStatement(sqlVenta)) {

                    ps.setDate(1, fecha);
                    ps.setInt(2, venta.getClienteId());
                    ps.setInt(3, venta.getProductoId());
                    ps.setInt(4, venta.getCantidad());
                    ps.setBigDecimal(5, precio);
                    ps.setBigDecimal(6, total);

                    ps.executeUpdate();
                }

                // Descontar las unidades del inventario.
                try (PreparedStatement ps =
                         con.prepareStatement(sqlStock)) {

                    ps.setInt(1, venta.getCantidad());
                    ps.setInt(2, venta.getProductoId());
                    ps.setInt(3, venta.getCantidad());

                    if (ps.executeUpdate() != 1) {
                        throw new SQLException(
                            "No se pudo actualizar el inventario."
                        );
                    }
                }

                con.commit();
                return true;

            } catch (SQLException | RuntimeException e) {
                try {
                    con.rollback();
                } catch (SQLException rollbackError) {
                    e.addSuppressed(rollbackError);
                }

                throw e;

            } finally {
                try {
                    con.setAutoCommit(true);
                } catch (SQLException ignored) {
                    // La conexión se cerrará al salir del bloque.
                }
            }
        }
    }
}