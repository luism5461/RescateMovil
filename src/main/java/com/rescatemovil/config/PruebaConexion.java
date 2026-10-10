/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.rescatemovil.config;

import java.sql.Connection;

public class PruebaConexion {

    public static void main(String[] args) {

        try (Connection conexion = Conexion.getConexion()) {

            if (conexion != null) {
                System.out.println("=================================");
                System.out.println("CONEXIÓN EXITOSA");
                System.out.println("Base de datos: rescatemovil");
                System.out.println("=================================");
            }

        } catch (Exception e) {

            System.out.println("=================================");
            System.out.println("ERROR DE CONEXIÓN");
            System.out.println("=================================");

            e.printStackTrace();
        }
    }
}