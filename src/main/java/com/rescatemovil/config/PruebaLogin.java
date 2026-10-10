/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.rescatemovil.config;

import com.rescatemovil.dao.UsuarioDAO;
import com.rescatemovil.modelo.Usuario;

public class PruebaLogin {

    public static void main(String[] args) {

        UsuarioDAO usuarioDAO = new UsuarioDAO();

        Usuario usuario = usuarioDAO.validarLogin(
                "admin",
                "admin123"
        );

        if (usuario != null) {

            System.out.println("LOGIN CORRECTO");
            System.out.println("Usuario: " + usuario.getUsuario());
            System.out.println("Nombre: " + usuario.getNombre());
            System.out.println("Rol: " + usuario.getRol());

        } else {

            System.out.println("LOGIN INCORRECTO");

        }
    }
}