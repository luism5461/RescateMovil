
package com.rescatemovil.dao;

import com.rescatemovil.config.Conexion;
import com.rescatemovil.modelo.Reparacion;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class ReparacionDAO {

    private static final String SQL_BASE =
        "SELECT r.id, r.codigo, r.cliente_id, r.tecnico_id, " +
        "r.equipo, r.falla, r.fecha_ingreso, r.fecha_entrega, " +
        "r.estado, r.costo, r.pagado, r.metodo_pago, r.fecha_pago, " +
        "c.nombre AS nombre_cliente, " +
        "c.apellido AS apellido_cliente, " +
        "c.telefono AS telefono_cliente, " +
        "t.nombre AS nombre_tecnico, " +
        "de.id AS detalle_id, de.marca, de.modelo, de.imei, " +
        "de.serial_equipo, de.color, de.almacenamiento, " +
        "de.estado_fisico, de.accesorios, de.diagnostico, " +
        "de.observaciones " +
        "FROM reparaciones r " +
        "INNER JOIN clientes c ON r.cliente_id = c.id " +
        "INNER JOIN tecnicos t ON r.tecnico_id = t.id " +
        "LEFT JOIN detalles_equipo de ON de.reparacion_id = r.id ";

    // =====================================================
    // LISTAR REPARACIONES
    // =====================================================

    public List<Reparacion> listarReparaciones() {

        List<Reparacion> lista = new ArrayList<>();

        String sql = SQL_BASE + "ORDER BY r.id DESC";

        try (Connection conexion = Conexion.getConexion();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(mapearReparacion(rs));
            }

        } catch (SQLException e) {
            System.err.println(
                "Error al listar reparaciones: " + e.getMessage()
            );
            e.printStackTrace();
        }

        return lista;
    }

    // =====================================================
    // OBTENER REPARACION POR ID
    // =====================================================

    public Reparacion obtenerReparacionPorId(int id) {

        if (id <= 0) {
            return null;
        }

        String sql = SQL_BASE + "WHERE r.id = ?";

        try (Connection conexion = Conexion.getConexion();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return mapearReparacion(rs);
                }
            }

        } catch (SQLException e) {
            System.err.println(
                "Error al consultar reparación: " + e.getMessage()
            );
            e.printStackTrace();
        }

        return null;
    }

    // =====================================================
    // BUSCAR REPARACIONES
    // =====================================================

    public List<Reparacion> buscarReparaciones(String termino) {

        List<Reparacion> lista = new ArrayList<>();

        String sql = SQL_BASE +
            "WHERE r.codigo LIKE ? " +
            "OR c.nombre LIKE ? " +
            "OR c.apellido LIKE ? " +
            "OR c.documento LIKE ? " +
            "OR c.telefono LIKE ? " +
            "OR r.equipo LIKE ? " +
            "OR r.falla LIKE ? " +
            "OR r.estado LIKE ? " +
            "OR t.nombre LIKE ? " +
            "ORDER BY r.id DESC";

        try (Connection conexion = Conexion.getConexion();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            String filtro = "%"
                + (termino == null ? "" : termino.trim())
                + "%";

            for (int i = 1; i <= 9; i++) {
                ps.setString(i, filtro);
            }

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    lista.add(mapearReparacion(rs));
                }
            }

        } catch (SQLException e) {
            System.err.println(
                "Error al buscar reparaciones: " + e.getMessage()
            );
            e.printStackTrace();
        }

        return lista;
    }

    // =====================================================
    // REGISTRAR REPARACION Y DETALLES DEL EQUIPO
    // =====================================================

    public boolean registrarReparacion(Reparacion reparacion) {

        if (reparacion == null) {
            return false;
        }

        String sql =
            "INSERT INTO reparaciones " +
            "(codigo, cliente_id, tecnico_id, equipo, falla, " +
            "fecha_ingreso, fecha_entrega, estado, costo, pagado, " +
            "metodo_pago, fecha_pago) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        Connection conexion = null;
        boolean autoCommitOriginal = true;

        try {

            conexion = Conexion.getConexion();

            if (conexion == null) {
                return false;
            }

            autoCommitOriginal = conexion.getAutoCommit();
            conexion.setAutoCommit(false);

            String codigo = reparacion.getCodigo();

            if (codigo == null || codigo.trim().isEmpty()) {
                codigo = generarCodigo();
            }

            try (PreparedStatement ps = conexion.prepareStatement(
                    sql, Statement.RETURN_GENERATED_KEYS)) {

                ps.setString(1, codigo);
                ps.setInt(2, reparacion.getClienteId());
                ps.setInt(3, reparacion.getTecnicoId());
                ps.setString(4, reparacion.getEquipo());
                ps.setString(5, reparacion.getFalla());
                ps.setDate(6, reparacion.getFechaIngreso());

                if (reparacion.getFechaEntrega() != null) {
                    ps.setDate(7, reparacion.getFechaEntrega());
                } else {
                    ps.setNull(7, Types.DATE);
                }

                ps.setString(8, reparacion.getEstado());
                ps.setBigDecimal(9, reparacion.getCosto());
                ps.setBoolean(10, reparacion.isPagado());

                if (reparacion.getMetodoPago() != null
                        && !reparacion.getMetodoPago()
                            .trim().isEmpty()) {
                    ps.setString(11, reparacion.getMetodoPago());
                } else {
                    ps.setNull(11, Types.VARCHAR);
                }

                if (reparacion.getFechaPago() != null) {
                    ps.setTimestamp(12, reparacion.getFechaPago());
                } else {
                    ps.setNull(12, Types.TIMESTAMP);
                }

                if (ps.executeUpdate() != 1) {
                    conexion.rollback();
                    return false;
                }

                try (ResultSet claves = ps.getGeneratedKeys()) {

                    if (!claves.next()) {
                        conexion.rollback();
                        return false;
                    }

                    reparacion.setId(claves.getInt(1));
                    reparacion.setCodigo(codigo);
                }
            }

            // Guarda los datos del equipo antes de confirmar.
            guardarDetalleEquipo(conexion, reparacion);

            conexion.commit();

            return true;

        } catch (SQLException e) {

            System.err.println(
                "Error al registrar reparación y equipo: "
                + e.getMessage()
            );
            e.printStackTrace();

            if (conexion != null) {
                try {
                    conexion.rollback();
                } catch (SQLException rollbackError) {
                    rollbackError.printStackTrace();
                }
            }

            return false;

        } finally {
            cerrarConexion(conexion, autoCommitOriginal);
        }
    }

    // =====================================================
    // ACTUALIZAR REPARACION Y DETALLES DEL EQUIPO
    // =====================================================

    public boolean actualizarReparacion(Reparacion reparacion) {

        if (reparacion == null || reparacion.getId() <= 0) {
            return false;
        }

        String sql =
            "UPDATE reparaciones SET " +
            "cliente_id = ?, tecnico_id = ?, equipo = ?, falla = ?, " +
            "fecha_ingreso = ?, fecha_entrega = ?, estado = ?, " +
            "costo = ?, pagado = ?, metodo_pago = ?, fecha_pago = ? " +
            "WHERE id = ?";

        Connection conexion = null;
        boolean autoCommitOriginal = true;

        try {

            conexion = Conexion.getConexion();

            if (conexion == null) {
                return false;
            }

            autoCommitOriginal = conexion.getAutoCommit();
            conexion.setAutoCommit(false);

            try (PreparedStatement ps = conexion.prepareStatement(sql)) {

                ps.setInt(1, reparacion.getClienteId());
                ps.setInt(2, reparacion.getTecnicoId());
                ps.setString(3, reparacion.getEquipo());
                ps.setString(4, reparacion.getFalla());
                ps.setDate(5, reparacion.getFechaIngreso());

                if (reparacion.getFechaEntrega() != null) {
                    ps.setDate(6, reparacion.getFechaEntrega());
                } else {
                    ps.setNull(6, Types.DATE);
                }

                ps.setString(7, reparacion.getEstado());
                ps.setBigDecimal(8, reparacion.getCosto());
                ps.setBoolean(9, reparacion.isPagado());

                if (reparacion.getMetodoPago() != null
                        && !reparacion.getMetodoPago()
                            .trim().isEmpty()) {
                    ps.setString(10, reparacion.getMetodoPago());
                } else {
                    ps.setNull(10, Types.VARCHAR);
                }

                if (reparacion.getFechaPago() != null) {
                    ps.setTimestamp(11, reparacion.getFechaPago());
                } else {
                    ps.setNull(11, Types.TIMESTAMP);
                }

                ps.setInt(12, reparacion.getId());

                if (ps.executeUpdate() == 0) {
                    conexion.rollback();
                    return false;
                }
            }

            guardarDetalleEquipo(conexion, reparacion);

            conexion.commit();

            return true;

        } catch (SQLException e) {

            System.err.println(
                "Error al actualizar reparación y equipo: "
                + e.getMessage()
            );
            e.printStackTrace();

            if (conexion != null) {
                try {
                    conexion.rollback();
                } catch (SQLException rollbackError) {
                    rollbackError.printStackTrace();
                }
            }

            return false;

        } finally {
            cerrarConexion(conexion, autoCommitOriginal);
        }
    }

    // =====================================================
    // GUARDAR O ACTUALIZAR DETALLES DEL EQUIPO
    // =====================================================

    private void guardarDetalleEquipo(
            Connection conexion,
            Reparacion reparacion) throws SQLException {

        String sqlBuscar =
            "SELECT id FROM detalles_equipo WHERE reparacion_id = ?";

        Integer detalleId = null;

        try (PreparedStatement ps =
                conexion.prepareStatement(sqlBuscar)) {

            ps.setInt(1, reparacion.getId());

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    detalleId = rs.getInt("id");
                }
            }
        }

        String marca = textoObligatorio(
            reparacion.getMarca(),
            "No especificada"
        );

        String modelo = textoObligatorio(
            reparacion.getModelo(),
            reparacion.getEquipo()
        );

        String estadoFisico = textoObligatorio(
            reparacion.getEstadoFisico(),
            "No especificado"
        );

        if (detalleId == null) {

            String sqlInsertar =
                "INSERT INTO detalles_equipo " +
                "(reparacion_id, marca, modelo, imei, serial_equipo, " +
                "color, almacenamiento, estado_fisico, falla, " +
                "accesorios, diagnostico, observaciones) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement ps =
                    conexion.prepareStatement(
                        sqlInsertar,
                        Statement.RETURN_GENERATED_KEYS)) {

                ps.setInt(1, reparacion.getId());
                ps.setString(2, marca);
                ps.setString(3, modelo);
                establecerTextoOpcional(
                    ps, 4, reparacion.getImei()
                );
                establecerTextoOpcional(
                    ps, 5, reparacion.getSerialEquipo()
                );
                establecerTextoOpcional(
                    ps, 6, reparacion.getColor()
                );
                establecerTextoOpcional(
                    ps, 7, reparacion.getAlmacenamiento()
                );
                ps.setString(8, estadoFisico);
                ps.setString(9, reparacion.getFalla());
                establecerTextoOpcional(
                    ps, 10, reparacion.getAccesorios()
                );
                establecerTextoOpcional(
                    ps, 11, reparacion.getDiagnostico()
                );
                establecerTextoOpcional(
                    ps, 12, reparacion.getObservaciones()
                );

                ps.executeUpdate();

                try (ResultSet claves = ps.getGeneratedKeys()) {
                    if (claves.next()) {
                        reparacion.setDetalleEquipoId(
                            claves.getInt(1)
                        );
                    }
                }
            }

        } else {

            String sqlActualizar =
                "UPDATE detalles_equipo SET " +
                "marca = ?, modelo = ?, imei = ?, serial_equipo = ?, " +
                "color = ?, almacenamiento = ?, estado_fisico = ?, " +
                "falla = ?, accesorios = ?, diagnostico = ?, " +
                "observaciones = ? " +
                "WHERE reparacion_id = ?";

            try (PreparedStatement ps =
                    conexion.prepareStatement(sqlActualizar)) {

                ps.setString(1, marca);
                ps.setString(2, modelo);
                establecerTextoOpcional(
                    ps, 3, reparacion.getImei()
                );
                establecerTextoOpcional(
                    ps, 4, reparacion.getSerialEquipo()
                );
                establecerTextoOpcional(
                    ps, 5, reparacion.getColor()
                );
                establecerTextoOpcional(
                    ps, 6, reparacion.getAlmacenamiento()
                );
                ps.setString(7, estadoFisico);
                ps.setString(8, reparacion.getFalla());
                establecerTextoOpcional(
                    ps, 9, reparacion.getAccesorios()
                );
                establecerTextoOpcional(
                    ps, 10, reparacion.getDiagnostico()
                );
                establecerTextoOpcional(
                    ps, 11, reparacion.getObservaciones()
                );
                ps.setInt(12, reparacion.getId());

                ps.executeUpdate();
            }
        }
    }

    // =====================================================
    // CAMBIAR ESTADO
    // =====================================================

    public boolean actualizarEstado(int id, String estado) {

        if (id <= 0 || estado == null) {
            return false;
        }

        String sql =
            "UPDATE reparaciones SET estado = ? WHERE id = ?";

        try (Connection conexion = Conexion.getConexion();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, estado);
            ps.setInt(2, id);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println(
                "Error al actualizar estado: " + e.getMessage()
            );
            e.printStackTrace();
            return false;
        }
    }

    // =====================================================
    // ELIMINAR REPARACION
    // =====================================================

    public boolean eliminarReparacion(int id) {

        if (id <= 0) {
            return false;
        }

        Connection conexion = null;
        boolean autoCommitOriginal = true;

        try {

            conexion = Conexion.getConexion();

            if (conexion == null) {
                return false;
            }

            autoCommitOriginal = conexion.getAutoCommit();
            conexion.setAutoCommit(false);

            // Eliminar primero el detalle asociado al equipo.
            String sqlDetalle =
                "DELETE FROM detalles_equipo WHERE reparacion_id = ?";

            try (PreparedStatement ps =
                    conexion.prepareStatement(sqlDetalle)) {

                ps.setInt(1, id);
                ps.executeUpdate();
            }

            // Los elementos de reparación se eliminan mediante
            // la clave foránea con ON DELETE CASCADE.
            String sqlReparacion =
                "DELETE FROM reparaciones WHERE id = ?";

            int filas;

            try (PreparedStatement ps =
                    conexion.prepareStatement(sqlReparacion)) {

                ps.setInt(1, id);
                filas = ps.executeUpdate();
            }

            if (filas == 0) {
                conexion.rollback();
                return false;
            }

            conexion.commit();

            return true;

        } catch (SQLException e) {

            System.err.println(
                "Error al eliminar reparación: " + e.getMessage()
            );
            e.printStackTrace();

            if (conexion != null) {
                try {
                    conexion.rollback();
                } catch (SQLException rollbackError) {
                    rollbackError.printStackTrace();
                }
            }

            return false;

        } finally {
            cerrarConexion(conexion, autoCommitOriginal);
        }
    }

    // =====================================================
    // GENERAR CODIGO AUTOMATICO
    // =====================================================

    private String generarCodigo() {
        return "REP-" + UUID.randomUUID()
            .toString()
            .substring(0, 8)
            .toUpperCase();
    }

    // =====================================================
    // MAPEAR RESULTADOS DE MYSQL
    // =====================================================

    private Reparacion mapearReparacion(ResultSet rs)
            throws SQLException {

        Reparacion r = new Reparacion();

        r.setId(rs.getInt("id"));
        r.setCodigo(rs.getString("codigo"));
        r.setClienteId(rs.getInt("cliente_id"));
        r.setTecnicoId(rs.getInt("tecnico_id"));
        r.setEquipo(rs.getString("equipo"));
        r.setFalla(rs.getString("falla"));
        r.setFechaIngreso(rs.getDate("fecha_ingreso"));
        r.setFechaEntrega(rs.getDate("fecha_entrega"));
        r.setEstado(rs.getString("estado"));
        r.setCosto(rs.getBigDecimal("costo"));
        r.setPagado(rs.getBoolean("pagado"));
        r.setMetodoPago(rs.getString("metodo_pago"));
        r.setFechaPago(rs.getTimestamp("fecha_pago"));

        r.setNombreCliente(rs.getString("nombre_cliente"));
        r.setApellidoCliente(rs.getString("apellido_cliente"));
        r.setTelefonoCliente(rs.getString("telefono_cliente"));
        r.setNombreTecnico(rs.getString("nombre_tecnico"));

        r.setDetalleEquipoId(rs.getInt("detalle_id"));

        if (rs.wasNull()) {
            r.setDetalleEquipoId(0);
        }

        r.setMarca(rs.getString("marca"));
        r.setModelo(rs.getString("modelo"));
        r.setImei(rs.getString("imei"));
        r.setSerialEquipo(rs.getString("serial_equipo"));
        r.setColor(rs.getString("color"));
        r.setAlmacenamiento(rs.getString("almacenamiento"));
        r.setEstadoFisico(rs.getString("estado_fisico"));
        r.setAccesorios(rs.getString("accesorios"));
        r.setDiagnostico(rs.getString("diagnostico"));
        r.setObservaciones(rs.getString("observaciones"));

        return r;
    }

    // =====================================================
    // MANEJO DE CAMPOS OPCIONALES
    // =====================================================

    private void establecerTextoOpcional(
            PreparedStatement ps,
            int posicion,
            String valor) throws SQLException {

        if (valor == null || valor.trim().isEmpty()) {
            ps.setNull(posicion, Types.VARCHAR);
        } else {
            ps.setString(posicion, valor.trim());
        }
    }

    private String textoObligatorio(
            String valor,
            String valorPredeterminado) {

        if (valor == null || valor.trim().isEmpty()) {
            return valorPredeterminado;
        }

        return valor.trim();
    }

    // =====================================================
    // CERRAR CONEXION Y RESTAURAR AUTOCOMMIT
    // =====================================================

    private void cerrarConexion(
            Connection conexion,
            boolean autoCommitOriginal) {

        if (conexion == null) {
            return;
        }

        try {
            conexion.setAutoCommit(autoCommitOriginal);
        } catch (SQLException e) {
            System.err.println(
                "No se pudo restaurar autoCommit: " + e.getMessage()
            );
        }

        try {
            conexion.close();
        } catch (SQLException e) {
            System.err.println(
                "No se pudo cerrar la conexión: " + e.getMessage()
            );
        }
    }
}
