
package com.rescatemovil.dao;

import com.rescatemovil.config.Conexion;
import com.rescatemovil.modelo.cliente;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

/**
 * Acceso a datos para la gestión de clientes de Rescate Móvil.
 * Contiene operaciones CRUD sobre la tabla clientes.
 */
public class ClienteDAO {

    /**
     * Lista todos los clientes registrados.
     */
    public List<cliente> listarClientes() {
        List<cliente> clientes = new ArrayList<>();

        String sql = "SELECT id, usuario_id, nombre, apellido, documento, "
                   + "telefono, telefono_secundario, correo, direccion, "
                   + "ciudad, notas, fecha_registro "
                   + "FROM clientes ORDER BY id DESC";

        try (
            Connection conexion = Conexion.getConexion();
            PreparedStatement ps = conexion.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                clientes.add(mapearCliente(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error al listar los clientes.");
            e.printStackTrace();
        }

        return clientes;
    }

    /**
     * Consulta un cliente por su identificador.
     */
    public cliente obtenerClientePorId(int id) {
        if (id <= 0) {
            return null;
        }

        String sql = "SELECT id, usuario_id, nombre, apellido, documento, "
                   + "telefono, telefono_secundario, correo, direccion, "
                   + "ciudad, notas, fecha_registro "
                   + "FROM clientes WHERE id = ?";

        try (
            Connection conexion = Conexion.getConexion();
            PreparedStatement ps = conexion.prepareStatement(sql)
        ) {
            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearCliente(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println(
                "Error al consultar el cliente con ID " + id);
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Convierte una fila de la base de datos en un objeto cliente.
     */
    private cliente mapearCliente(ResultSet rs) throws SQLException {
        cliente c = new cliente();

        c.setId(rs.getInt("id"));

        long usuarioId = rs.getLong("usuario_id");
        c.setUsuarioId(rs.wasNull() ? null : usuarioId);

        c.setNombre(rs.getString("nombre"));
        c.setApellido(rs.getString("apellido"));
        c.setDocumento(rs.getString("documento"));
        c.setTelefono(rs.getString("telefono"));
        c.setTelefonoSecundario(
            rs.getString("telefono_secundario"));
        c.setCorreo(rs.getString("correo"));
        c.setDireccion(rs.getString("direccion"));
        c.setCiudad(rs.getString("ciudad"));
        c.setNotas(rs.getString("notas"));
        c.setFechaRegistro(rs.getDate("fecha_registro"));

        return c;
    }

    /**
     * Registra un cliente nuevo.
     */
    public boolean registrarCliente(cliente c) {
        if (c == null) {
            return false;
        }

        String sql = "INSERT INTO clientes "
                   + "(nombre, apellido, documento, telefono, "
                   + "telefono_secundario, correo, direccion, ciudad, "
                   + "notas, fecha_registro) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_DATE)";

        try (
            Connection conexion = Conexion.getConexion();
            PreparedStatement ps = conexion.prepareStatement(sql)
        ) {
            ps.setString(1, c.getNombre());
            ps.setString(2, c.getApellido());
            establecerTextoOpcional(
                ps, 3, c.getDocumento(), Types.VARCHAR);
            ps.setString(4, c.getTelefono());
            establecerTextoOpcional(
                ps, 5, c.getTelefonoSecundario(), Types.VARCHAR);
            ps.setString(6, c.getCorreo());
            ps.setString(7, c.getDireccion());
            establecerTextoOpcional(
                ps, 8, c.getCiudad(), Types.VARCHAR);
            establecerTextoOpcional(
                ps, 9, c.getNotas(), Types.LONGVARCHAR);

            int filas = ps.executeUpdate();

            System.out.println(
                "API/DAO: filas insertadas = " + filas);

            return filas > 0;

        } catch (SQLException e) {
            System.err.println("Error al registrar el cliente.");
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Actualiza los datos del cliente cuyo ID se proporciona.
     */
    public boolean actualizarCliente(cliente c) {
        if (c == null || c.getId() <= 0) {
            System.err.println(
                "Actualización cancelada: cliente o ID inválido.");
            return false;
        }

        String sql = "UPDATE clientes SET "
                   + "nombre = ?, apellido = ?, documento = ?, "
                   + "telefono = ?, telefono_secundario = ?, correo = ?, "
                   + "direccion = ?, ciudad = ?, notas = ? "
                   + "WHERE id = ?";

        System.out.println("=== DIAGNÓSTICO PUT CLIENTES ===");
        System.out.println("ID recibido por el DAO: " + c.getId());
        System.out.println("Nombre recibido: " + c.getNombre());
        System.out.println("Apellido recibido: " + c.getApellido());
        System.out.println("Documento recibido: " + c.getDocumento());
        System.out.println("Teléfono recibido: " + c.getTelefono());
        System.out.println("Correo recibido: " + c.getCorreo());
        System.out.println("Ciudad recibida: " + c.getCiudad());
        System.out.println("Notas recibidas: " + c.getNotas());

        try (
            Connection conexion = Conexion.getConexion();
            PreparedStatement ps = conexion.prepareStatement(sql)
        ) {
            ps.setString(1, c.getNombre());
            ps.setString(2, c.getApellido());

            establecerTextoOpcional(
                ps, 3, c.getDocumento(), Types.VARCHAR);
            ps.setString(4, c.getTelefono());

            establecerTextoOpcional(
                ps, 5, c.getTelefonoSecundario(), Types.VARCHAR);

            ps.setString(6, c.getCorreo());
            ps.setString(7, c.getDireccion());

            establecerTextoOpcional(
                ps, 8, c.getCiudad(), Types.VARCHAR);
            establecerTextoOpcional(
                ps, 9, c.getNotas(), Types.LONGVARCHAR);

            // El último parámetro determina qué registro se modifica.
            ps.setInt(10, c.getId());

            int filasActualizadas = ps.executeUpdate();

            System.out.println(
                "Filas modificadas por MySQL: "
                + filasActualizadas);
            System.out.println(
                "=== FIN DIAGNÓSTICO PUT CLIENTES ===");

            return filasActualizadas > 0;

        } catch (SQLException e) {
            System.err.println(
                "Error al actualizar el cliente con ID " + c.getId());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Elimina un cliente por su identificador.
     */
    public boolean eliminarCliente(int id) {
        if (id <= 0) {
            return false;
        }

        String sql = "DELETE FROM clientes WHERE id = ?";

        try (
            Connection conexion = Conexion.getConexion();
            PreparedStatement ps = conexion.prepareStatement(sql)
        ) {
            ps.setInt(1, id);

            int filasEliminadas = ps.executeUpdate();

            System.out.println(
                "Filas eliminadas por MySQL: " + filasEliminadas);

            return filasEliminadas > 0;

        } catch (SQLException e) {
            System.err.println(
                "Error al eliminar el cliente con ID " + id);
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Guarda un texto opcional como NULL si está vacío.
     */
    private void establecerTextoOpcional(
            PreparedStatement ps,
            int posicion,
            String valor,
            int tipoSQL) throws SQLException {

        if (valor == null || valor.trim().isEmpty()) {
            ps.setNull(posicion, tipoSQL);
        } else {
            ps.setString(posicion, valor.trim());
        }
    }
}