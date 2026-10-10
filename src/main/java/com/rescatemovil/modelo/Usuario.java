/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package com.rescatemovil.modelo;

public class Usuario {

    private Long id;
    private String nombre;
    private String usuario;
    private String correo;
    private String telefono;
    private String rol;
    private String passwordHash;
    private boolean activo;
    private String fechaRegistro;

    public Usuario() {
    }

    public Usuario(Long id, String nombre, String usuario, String correo,
                    String telefono, String rol, String passwordHash,
                    boolean activo, String fechaRegistro) {

        this.id = id;
        this.nombre = nombre;
        this.usuario = usuario;
        this.correo = correo;
        this.telefono = telefono;
        this.rol = rol;
        this.passwordHash = passwordHash;
        this.activo = activo;
        this.fechaRegistro = fechaRegistro;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getUsuario() {
        return usuario;
    }

    public void setUsuario(String usuario) {
        this.usuario = usuario;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getRol() {
        return rol;
    }

    public void setRol(String rol) {
        this.rol = rol;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public boolean isActivo() {
        return activo;
    }

    public void setActivo(boolean activo) {
        this.activo = activo;
    }

    public String getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(String fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    @Override
    public String toString() {
        return "Usuario{"
                + "id=" + id
                + ", nombre='" + nombre + '\''
                + ", usuario='" + usuario + '\''
                + ", correo='" + correo + '\''
                + ", telefono='" + telefono + '\''
                + ", rol='" + rol + '\''
                + ", activo=" + activo
                + ", fechaRegistro='" + fechaRegistro + '\''
                + '}';
    }
}