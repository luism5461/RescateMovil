/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package com.rescatemovil.dao;

import com.rescatemovil.config.Conexion;
import com.rescatemovil.modelo.cliente;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

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

                cliente c = new cliente();

                c.setId(rs.getInt("id"));

                long usuarioId = rs.getLong("usuario_id");
                if (rs.wasNull()) {
                    c.setUsuarioId(null);
                } else {
                    c.setUsuarioId(usuarioId);
                }

                c.setNombre(rs.getString("nombre"));
                c.setApellido(rs.getString("apellido"));
                c.setDocumento(rs.getString("documento"));
                c.setTelefono(rs.getString("telefono"));
                c.setTelefonoSecundario(rs.getString("telefono_secundario"));
                c.setCorreo(rs.getString("correo"));
                c.setDireccion(rs.getString("direccion"));
                c.setCiudad(rs.getString("ciudad"));
                c.setNotas(rs.getString("notas"));
                c.setFechaRegistro(rs.getDate("fecha_registro"));

                clientes.add(c);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return clientes;
    }

    /**
     * Obtiene un cliente por su ID.
     */
    public cliente obtenerClientePorId(int id) {

        cliente c = null;

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

                    c = new cliente();

                    c.setId(rs.getInt("id"));

                    long usuarioId = rs.getLong("usuario_id");
                    if (rs.wasNull()) {
                        c.setUsuarioId(null);
                    } else {
                        c.setUsuarioId(usuarioId);
                    }

                    c.setNombre(rs.getString("nombre"));
                    c.setApellido(rs.getString("apellido"));
                    c.setDocumento(rs.getString("documento"));
                    c.setTelefono(rs.getString("telefono"));
                    c.setTelefonoSecundario(rs.getString("telefono_secundario"));
                    c.setCorreo(rs.getString("correo"));
                    c.setDireccion(rs.getString("direccion"));
                    c.setCiudad(rs.getString("ciudad"));
                    c.setNotas(rs.getString("notas"));
                    c.setFechaRegistro(rs.getDate("fecha_registro"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return c;
    }

    /**
     * Actualiza los datos de un cliente.
     *
     * No modifica:
     * - id
     * - usuario_id
     * - fecha_registro
     */
    public boolean actualizarCliente(cliente c) {

        String sql = "UPDATE clientes SET "
                   + "nombre = ?, "
                   + "apellido = ?, "
                   + "documento = ?, "
                   + "telefono = ?, "
                   + "telefono_secundario = ?, "
                   + "correo = ?, "
                   + "direccion = ?, "
                   + "ciudad = ?, "
                   + "notas = ? "
                   + "WHERE id = ?";

        try (
            Connection conexion = Conexion.getConexion();
            PreparedStatement ps = conexion.prepareStatement(sql)
        ) {

            ps.setString(1, c.getNombre());
            ps.setString(2, c.getApellido());

            if (c.getDocumento() == null || c.getDocumento().trim().isEmpty()) {
                ps.setNull(3, java.sql.Types.VARCHAR);
            } else {
                ps.setString(3, c.getDocumento());
            }

            ps.setString(4, c.getTelefono());

            if (c.getTelefonoSecundario() == null
                    || c.getTelefonoSecundario().trim().isEmpty()) {
                ps.setNull(5, java.sql.Types.VARCHAR);
            } else {
                ps.setString(5, c.getTelefonoSecundario());
            }

            ps.setString(6, c.getCorreo());
            ps.setString(7, c.getDireccion());

            if (c.getCiudad() == null || c.getCiudad().trim().isEmpty()) {
                ps.setNull(8, java.sql.Types.VARCHAR);
            } else {
                ps.setString(8, c.getCiudad());
            }

            if (c.getNotas() == null || c.getNotas().trim().isEmpty()) {
                ps.setNull(9, java.sql.Types.LONGVARCHAR);
            } else {
                ps.setString(9, c.getNotas());
            }

            ps.setInt(10, c.getId());

            int filasActualizadas = ps.executeUpdate();

            return filasActualizadas > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}