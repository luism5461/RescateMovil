/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.rescatemovil.dao;

import com.rescatemovil.modelo.Usuario;

public class PruebaUsuarioDAO {

    public static void main(String[] args) {

        UsuarioDAO usuarioDAO = new UsuarioDAO();

        Usuario usuario = usuarioDAO.buscarPorUsuario("admin");

        if (usuario != null) {

            System.out.println("======================================");
            System.out.println("USUARIO ENCONTRADO");
            System.out.println("======================================");
            System.out.println("ID: " + usuario.getId());
            System.out.println("Nombre: " + usuario.getNombre());
            System.out.println("Usuario: " + usuario.getUsuario());
            System.out.println("Correo: " + usuario.getCorreo());
            System.out.println("Rol: " + usuario.getRol());
            System.out.println("Activo: " + usuario.isActivo());
            System.out.println("======================================");

        } else {

            System.out.println("USUARIO NO ENCONTRADO");
        }
    }
}