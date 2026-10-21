
package com.rescatemovil.dao;

import com.rescatemovil.config.Conexion;
import com.rescatemovil.modelo.Tecnico;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class TecnicoDAO {

    public List<Tecnico> listarTecnicos() {
        List<Tecnico> lista = new ArrayList<>();

        String sql = "SELECT id, usuario_id, nombre, especialidad, "
                   + "telefono, correo, reparaciones_activas, activo "
                   + "FROM tecnicos ORDER BY id DESC";

        try (Connection conexion = Conexion.getConexion();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(mapearTecnico(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error al listar técnicos:");
            e.printStackTrace();
        }

        return lista;
    }

    public Tecnico obtenerTecnicoPorId(int id) {
        String sql = "SELECT id, usuario_id, nombre, especialidad, "
                   + "telefono, correo, reparaciones_activas, activo "
                   + "FROM tecnicos WHERE id = ?";

        try (Connection conexion = Conexion.getConexion();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearTecnico(rs);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error al consultar técnico:");
            e.printStackTrace();
        }

        return null;
    }

    public boolean registrarTecnico(Tecnico tecnico) {
        if (tecnico == null) {
            return false;
        }

        String sql = "INSERT INTO tecnicos "
                   + "(usuario_id, nombre, especialidad, telefono, correo, "
                   + "reparaciones_activas, activo) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conexion = Conexion.getConexion();
             PreparedStatement ps = conexion.prepareStatement(
                     sql, Statement.RETURN_GENERATED_KEYS)) {

            if (tecnico.getUsuarioId() == null) {
                ps.setNull(1, java.sql.Types.BIGINT);
            } else {
                ps.setLong(1, tecnico.getUsuarioId());
            }

            ps.setString(2, tecnico.getNombre());
            ps.setString(3, tecnico.getEspecialidad());
            ps.setString(4, tecnico.getTelefono());
            ps.setString(5, tecnico.getCorreo());
            ps.setInt(6, tecnico.getReparacionesActivas());
            ps.setBoolean(7, tecnico.isActivo());

            int filas = ps.executeUpdate();

            if (filas > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        tecnico.setId(rs.getInt(1));
                    }
                }
                return true;
            }

        } catch (SQLException e) {
            System.err.println("Error al registrar técnico:");
            e.printStackTrace();
        }

        return false;
    }

    public boolean actualizarTecnico(Tecnico tecnico) {
        if (tecnico == null || tecnico.getId() <= 0) {
            return false;
        }

        String sql = "UPDATE tecnicos SET usuario_id = ?, nombre = ?, "
                   + "especialidad = ?, telefono = ?, correo = ?, "
                   + "reparaciones_activas = ?, activo = ? WHERE id = ?";

        try (Connection conexion = Conexion.getConexion();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            if (tecnico.getUsuarioId() == null) {
                ps.setNull(1, java.sql.Types.BIGINT);
            } else {
                ps.setLong(1, tecnico.getUsuarioId());
            }

            ps.setString(2, tecnico.getNombre());
            ps.setString(3, tecnico.getEspecialidad());
            ps.setString(4, tecnico.getTelefono());
            ps.setString(5, tecnico.getCorreo());
            ps.setInt(6, tecnico.getReparacionesActivas());
            ps.setBoolean(7, tecnico.isActivo());
            ps.setInt(8, tecnico.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al actualizar técnico:");
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminarTecnico(int id) {
        if (id <= 0) {
            return false;
        }

        // No se permite eliminar técnicos que tengan reparaciones activas.
        String sql = "DELETE FROM tecnicos "
                   + "WHERE id = ? AND reparaciones_activas = 0";

        try (Connection conexion = Conexion.getConexion();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al eliminar técnico:");
            e.printStackTrace();
            return false;
        }
    }

    public List<Tecnico> buscarTecnicos(String criterio) {
        List<Tecnico> lista = new ArrayList<>();

        String sql = "SELECT id, usuario_id, nombre, especialidad, "
                   + "telefono, correo, reparaciones_activas, activo "
                   + "FROM tecnicos "
                   + "WHERE nombre LIKE ? OR especialidad LIKE ? "
                   + "OR correo LIKE ? OR telefono LIKE ? "
                   + "ORDER BY id DESC";

        try (Connection conexion = Conexion.getConexion();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            String busqueda = "%"
                    + (criterio == null ? "" : criterio.trim())
                    + "%";

            ps.setString(1, busqueda);
            ps.setString(2, busqueda);
            ps.setString(3, busqueda);
            ps.setString(4, busqueda);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearTecnico(rs));
                }
            }

        } catch (SQLException e) {
            System.err.println("Error al buscar técnicos:");
            e.printStackTrace();
        }

        return lista;
    }

    private Tecnico mapearTecnico(ResultSet rs) throws SQLException {
        Tecnico tecnico = new Tecnico();

        tecnico.setId(rs.getInt("id"));

        long usuarioId = rs.getLong("usuario_id");
        if (rs.wasNull()) {
            tecnico.setUsuarioId(null);
        } else {
            tecnico.setUsuarioId(usuarioId);
        }

        tecnico.setNombre(rs.getString("nombre"));
        tecnico.setEspecialidad(rs.getString("especialidad"));
        tecnico.setTelefono(rs.getString("telefono"));
        tecnico.setCorreo(rs.getString("correo"));
        tecnico.setReparacionesActivas(
                rs.getInt("reparaciones_activas"));
        tecnico.setActivo(rs.getBoolean("activo"));

        return tecnico;
    }
}
