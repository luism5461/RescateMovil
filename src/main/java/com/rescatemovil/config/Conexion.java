/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package com.rescatemovil.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    private static final String URL =
            "jdbc:mysql://localhost:3306/rescatemovil"
            + "?useSSL=false"
            + "&serverTimezone=America/Bogota"
            + "&allowPublicKeyRetrieval=true";

    private static final String USUARIO = "root";

    private static final String PASSWORD = "Luis1067-";

    public static Connection getConexion() throws SQLException {

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException(
                    "No se encontró el driver JDBC de MySQL.",
                    e
            );
        }

        return DriverManager.getConnection(
                URL,
                USUARIO,
                PASSWORD
        );
    }
}