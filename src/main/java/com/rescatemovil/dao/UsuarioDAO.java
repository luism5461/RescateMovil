package com.rescatemovil.dao;

import com.rescatemovil.config.Conexion;
import com.rescatemovil.modelo.Usuario;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {

    private Usuario convertirUsuario(ResultSet rs)
            throws SQLException {

        Usuario usuario = new Usuario();

        usuario.setId(rs.getLong("id"));
        usuario.setNombre(rs.getString("nombre"));
        usuario.setUsuario(rs.getString("usuario"));
        usuario.setCorreo(rs.getString("correo"));
        usuario.setTelefono(rs.getString("telefono"));
        usuario.setRol(rs.getString("rol"));
        usuario.setPasswordHash(rs.getString("password_hash"));
        usuario.setActivo(rs.getBoolean("activo"));
        usuario.setFechaRegistro(rs.getString("fecha_registro"));

        return usuario;
    }

    private String convertirSHA256(String password) {

        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");

            byte[] hash = md.digest(
                    password.getBytes(StandardCharsets.UTF_8)
            );

            StringBuilder hexadecimal = new StringBuilder();

            for (byte b : hash) {
                String valor = Integer.toHexString(0xff & b);

                if (valor.length() == 1) {
                    hexadecimal.append('0');
                }

                hexadecimal.append(valor);
            }

            return hexadecimal.toString();

        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(
                    "No se pudo utilizar SHA-256", e
            );
        }
    }

    public Usuario buscarPorUsuario(String nombreUsuario) {

        String sql = """
                SELECT id, nombre, usuario, correo, telefono,
                       rol, password_hash, activo, fecha_registro
                FROM usuarios
                WHERE usuario = ?
                """;

        try (Connection conexion = Conexion.getConexion();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, nombreUsuario);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return convertirUsuario(rs);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error al buscar usuario:");
            e.printStackTrace();
        }

        return null;
    }

    public Usuario validarLogin(String nombreUsuario, String password) {

        if (nombreUsuario == null || password == null) {
            return null;
        }

        Usuario usuario = buscarPorUsuario(nombreUsuario.trim());

        if (usuario == null || !usuario.isActivo()
                || usuario.getPasswordHash() == null) {
            return null;
        }

        String hash = convertirSHA256(password);

        if (hash.equalsIgnoreCase(usuario.getPasswordHash())) {
            return usuario;
        }

        return null;
    }

    public List<Usuario> listarUsuarios() {

        List<Usuario> lista = new ArrayList<>();

        String sql = """
                SELECT id, nombre, usuario, correo, telefono,
                       rol, password_hash, activo, fecha_registro
                FROM usuarios
                ORDER BY id ASC
                """;

        try (Connection conexion = Conexion.getConexion();
             PreparedStatement ps = conexion.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(convertirUsuario(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error al listar usuarios:");
            e.printStackTrace();
        }

        return lista;
    }

    public Usuario buscarPorId(long id) {

        String sql = """
                SELECT id, nombre, usuario, correo, telefono,
                       rol, password_hash, activo, fecha_registro
                FROM usuarios
                WHERE id = ?
                """;

        try (Connection conexion = Conexion.getConexion();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setLong(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return convertirUsuario(rs);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error al buscar usuario por ID:");
            e.printStackTrace();
        }

        return null;
    }

    /*
     * Comprueba si existe un nombre de usuario.
     * Al editar, permite excluir el ID del usuario actual.
     */
    public boolean existeUsuario(String nombreUsuario, long excluirId) {

        String sql = """
                SELECT COUNT(*)
                FROM usuarios
                WHERE LOWER(usuario) = LOWER(?)
                  AND id <> ?
                """;

        try (Connection conexion = Conexion.getConexion();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, nombreUsuario.trim());
            ps.setLong(2, excluirId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }

        } catch (SQLException e) {
            System.err.println("Error al validar nombre de usuario:");
            e.printStackTrace();
            // Ante un fallo de consulta, no afirmar que el dato está libre.
            return true;
        }

        return true;
    }

    /*
     * Comprueba si existe un correo electrónico.
     * Al editar, permite excluir el ID del usuario actual.
     */
    public boolean existeCorreo(String correo, long excluirId) {

        String sql = """
                SELECT COUNT(*)
                FROM usuarios
                WHERE LOWER(correo) = LOWER(?)
                  AND id <> ?
                """;

        try (Connection conexion = Conexion.getConexion();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, correo.trim());
            ps.setLong(2, excluirId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }

        } catch (SQLException e) {
            System.err.println("Error al validar correo:");
            e.printStackTrace();
            return true;
        }

        return true;
    }

    public boolean insertarUsuario(Usuario usuario) {

        if (usuario == null
                || usuario.getNombre() == null
                || usuario.getUsuario() == null
                || usuario.getCorreo() == null
                || usuario.getPasswordHash() == null) {
            return false;
        }

        String nombre = usuario.getNombre().trim();
        String nombreUsuario = usuario.getUsuario().trim();
        String correo = usuario.getCorreo().trim();
        String password = usuario.getPasswordHash();

        if (nombre.isEmpty()
                || nombreUsuario.isEmpty()
                || correo.isEmpty()
                || password.trim().isEmpty()) {
            return false;
        }

        if (existeUsuario(nombreUsuario, 0)
                || existeCorreo(correo, 0)) {
            return false;
        }

        String sql = """
                INSERT INTO usuarios
                    (nombre, usuario, correo, telefono, rol,
                     password_hash, activo)
                VALUES (?, ?, ?, ?, ?, ?, ?)
                """;

        String passwordHash = convertirSHA256(password);

        try (Connection conexion = Conexion.getConexion();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, nombre);
            ps.setString(2, nombreUsuario);
            ps.setString(3, correo);
            ps.setString(4, usuario.getTelefono());
            ps.setString(5, usuario.getRol());
            ps.setString(6, passwordHash);
            ps.setBoolean(7, usuario.isActivo());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al insertar usuario:");
            e.printStackTrace();
            return false;
        }
    }

    public boolean actualizarUsuario(Usuario usuario) {

        if (usuario == null
                || usuario.getId() == null
                || usuario.getNombre() == null
                || usuario.getUsuario() == null
                || usuario.getCorreo() == null) {
            return false;
        }

        String nombre = usuario.getNombre().trim();
        String nombreUsuario = usuario.getUsuario().trim();
        String correo = usuario.getCorreo().trim();

        if (nombre.isEmpty()
                || nombreUsuario.isEmpty()
                || correo.isEmpty()) {
            return false;
        }

        long id = usuario.getId();

        if (existeUsuario(nombreUsuario, id)
                || existeCorreo(correo, id)) {
            return false;
        }

        String sql = """
                UPDATE usuarios
                SET nombre = ?,
                    usuario = ?,
                    correo = ?,
                    telefono = ?,
                    rol = ?,
                    activo = ?
                WHERE id = ?
                """;

        try (Connection conexion = Conexion.getConexion();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setString(1, nombre);
            ps.setString(2, nombreUsuario);
            ps.setString(3, correo);
            ps.setString(4, usuario.getTelefono());
            ps.setString(5, usuario.getRol());
            ps.setBoolean(6, usuario.isActivo());
            ps.setLong(7, id);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al actualizar usuario:");
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminarUsuario(long id) {

        String sql = """
                DELETE FROM usuarios
                WHERE id = ?
                """;

        try (Connection conexion = Conexion.getConexion();
             PreparedStatement ps = conexion.prepareStatement(sql)) {

            ps.setLong(1, id);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("Error al eliminar usuario:");
            e.printStackTrace();
            return false;
        }
    }
}