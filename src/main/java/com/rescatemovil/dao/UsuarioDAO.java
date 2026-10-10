/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

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

    public Usuario buscarPorUsuario(String nombreUsuario) {

        String sql = """
                SELECT id,
                       nombre,
                       usuario,
                       correo,
                       telefono,
                       rol,
                       password_hash,
                       activo,
                       fecha_registro
                FROM usuarios
                WHERE usuario = ?
                """;

        System.out.println("======================================");
        System.out.println("BUSCANDO USUARIO");
        System.out.println("Usuario buscado: " + nombreUsuario);

        try (Connection conexion =
                     Conexion.getConexion();

             PreparedStatement ps =
                     conexion.prepareStatement(sql)) {

            System.out.println("CONEXION A BD: OK");

            ps.setString(1, nombreUsuario);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    System.out.println(
                            "USUARIO ENCONTRADO EN BD"
                    );

                    System.out.println(
                            "ID: " + rs.getLong("id")
                    );

                    System.out.println(
                            "Usuario BD: "
                            + rs.getString("usuario")
                    );

                    System.out.println(
                            "Nombre BD: "
                            + rs.getString("nombre")
                    );

                    System.out.println(
                            "Rol BD: "
                            + rs.getString("rol")
                    );

                    System.out.println(
                            "Activo BD: "
                            + rs.getBoolean("activo")
                    );

                    return convertirUsuario(rs);
                }

                System.out.println(
                        "USUARIO NO EXISTE EN LA CONSULTA"
                );
            }

        } catch (SQLException e) {

            System.out.println(
                    "ERROR SQL AL BUSCAR USUARIO"
            );

            e.printStackTrace();
        }

        return null;
    }

    public Usuario validarLogin(
            String nombreUsuario,
            String password) {

        System.out.println("======================================");
        System.out.println("VALIDANDO LOGIN");
        System.out.println("Usuario: " + nombreUsuario);

        Usuario usuario =
                buscarPorUsuario(nombreUsuario);

        if (usuario == null) {

            System.out.println(
                    "VALIDACION: USUARIO NULL"
            );

            return null;
        }

        if (!usuario.isActivo()) {

            System.out.println(
                    "VALIDACION: USUARIO INACTIVO"
            );

            return null;
        }

        String passwordHash =
                convertirSHA256(password);

        System.out.println(
                "HASH CALCULADO: "
                + passwordHash
        );

        System.out.println(
                "HASH BD: "
                + usuario.getPasswordHash()
        );

        if (passwordHash.equalsIgnoreCase(
                usuario.getPasswordHash())) {

            System.out.println(
                    "VALIDACION DE PASSWORD: CORRECTA"
            );

            return usuario;
        }

        System.out.println(
                "VALIDACION DE PASSWORD: INCORRECTA"
        );

        return null;
    }

    private Usuario convertirUsuario(
            ResultSet rs)
            throws SQLException {

        Usuario usuario =
                new Usuario();

        usuario.setId(
                rs.getLong("id")
        );

        usuario.setNombre(
                rs.getString("nombre")
        );

        usuario.setUsuario(
                rs.getString("usuario")
        );

        usuario.setCorreo(
                rs.getString("correo")
        );

        usuario.setTelefono(
                rs.getString("telefono")
        );

        usuario.setRol(
                rs.getString("rol")
        );

        usuario.setPasswordHash(
                rs.getString("password_hash")
        );

        usuario.setActivo(
                rs.getBoolean("activo")
        );

        usuario.setFechaRegistro(
                rs.getString("fecha_registro")
        );

        return usuario;
    }

    public List<Usuario> listarUsuarios() {

        List<Usuario> lista =
                new ArrayList<>();

        String sql = """
                SELECT id,
                       nombre,
                       usuario,
                       correo,
                       telefono,
                       rol,
                       password_hash,
                       activo,
                       fecha_registro
                FROM usuarios
                ORDER BY id ASC
                """;

        try (Connection conexion =
                     Conexion.getConexion();

             PreparedStatement ps =
                     conexion.prepareStatement(sql);

             ResultSet rs =
                     ps.executeQuery()) {

            while (rs.next()) {

                lista.add(
                        convertirUsuario(rs)
                );
            }

        } catch (SQLException e) {

            System.err.println(
                    "Error al listar usuarios:"
            );

            e.printStackTrace();
        }

        return lista;
    }

    private String convertirSHA256(
            String password) {

        try {

            MessageDigest md =
                    MessageDigest.getInstance(
                            "SHA-256"
                    );

            byte[] hash =
                    md.digest(
                            password.getBytes(
                                    StandardCharsets.UTF_8
                            )
                    );

            StringBuilder hexadecimal =
                    new StringBuilder();

            for (byte b : hash) {

                String hexadecimalByte =
                        Integer.toHexString(
                                0xff & b
                        );

                if (hexadecimalByte.length()
                        == 1) {

                    hexadecimal.append('0');
                }

                hexadecimal.append(
                        hexadecimalByte
                );
            }

            return hexadecimal.toString();

        } catch (NoSuchAlgorithmException e) {

            throw new RuntimeException(
                    "No se pudo utilizar SHA-256",
                    e
            );
        }
    }

    public Usuario buscarPorId(long id) {

        String sql = """
                SELECT id,
                       nombre,
                       usuario,
                       correo,
                       telefono,
                       rol,
                       password_hash,
                       activo,
                       fecha_registro
                FROM usuarios
                WHERE id = ?
                """;

        try (Connection conexion =
                     Conexion.getConexion();

             PreparedStatement ps =
                     conexion.prepareStatement(sql)) {

            ps.setLong(1, id);

            try (ResultSet rs =
                         ps.executeQuery()) {

                if (rs.next()) {

                    return convertirUsuario(rs);
                }
            }

        } catch (SQLException e) {

            System.err.println(
                    "Error al buscar usuario por ID:"
            );

            e.printStackTrace();
        }

        return null;
    }

    public boolean insertarUsuario(
            Usuario usuario) {

        String sql = """
                INSERT INTO usuarios
                (
                    nombre,
                    usuario,
                    correo,
                    telefono,
                    rol,
                    password_hash,
                    activo
                )
                VALUES (?, ?, ?, ?, ?, ?, ?)
                """;

        String passwordHash =
                convertirSHA256(
                        usuario.getPasswordHash()
                );

        try (Connection conexion =
                     Conexion.getConexion();

             PreparedStatement ps =
                     conexion.prepareStatement(sql)) {

            ps.setString(
                    1,
                    usuario.getNombre()
            );

            ps.setString(
                    2,
                    usuario.getUsuario()
            );

            ps.setString(
                    3,
                    usuario.getCorreo()
            );

            ps.setString(
                    4,
                    usuario.getTelefono()
            );

            ps.setString(
                    5,
                    usuario.getRol()
            );

            ps.setString(
                    6,
                    passwordHash
            );

            ps.setBoolean(
                    7,
                    usuario.isActivo()
            );

            int filasAfectadas =
                    ps.executeUpdate();

            return filasAfectadas > 0;

        } catch (SQLException e) {

            System.err.println(
                    "Error al insertar usuario:"
            );

            e.printStackTrace();

            return false;
        }
    }

    public boolean actualizarUsuario(
            Usuario usuario) {

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

        try (Connection conexion =
                     Conexion.getConexion();

             PreparedStatement ps =
                     conexion.prepareStatement(sql)) {

            ps.setString(
                    1,
                    usuario.getNombre()
            );

            ps.setString(
                    2,
                    usuario.getUsuario()
            );

            ps.setString(
                    3,
                    usuario.getCorreo()
            );

            ps.setString(
                    4,
                    usuario.getTelefono()
            );

            ps.setString(
                    5,
                    usuario.getRol()
            );

            ps.setBoolean(
                    6,
                    usuario.isActivo()
            );

            ps.setLong(
                    7,
                    usuario.getId()
            );

            int filasAfectadas =
                    ps.executeUpdate();

            return filasAfectadas > 0;

        } catch (SQLException e) {

            System.err.println(
                    "Error al actualizar usuario:"
            );

            e.printStackTrace();

            return false;
        }
    }

    public boolean eliminarUsuario(long id) {

        String sql = """
                DELETE FROM usuarios
                WHERE id = ?
                """;

        try (Connection conexion =
                     Conexion.getConexion();

             PreparedStatement ps =
                     conexion.prepareStatement(sql)) {

            ps.setLong(1, id);

            int filasAfectadas =
                    ps.executeUpdate();

            return filasAfectadas > 0;

        } catch (SQLException e) {

            System.err.println(
                    "Error al eliminar usuario:"
            );

            e.printStackTrace();

            return false;
        }
    }
}