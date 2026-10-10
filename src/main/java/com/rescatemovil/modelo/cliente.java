/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package com.rescatemovil.modelo;

import java.sql.Date;

public class cliente {

    private int id;
    private Long usuarioId;
    private String nombre;
    private String apellido;
    private String documento;
    private String telefono;
    private String telefonoSecundario;
    private String correo;
    private String direccion;
    private String ciudad;
    private String notas;
    private Date fechaRegistro;

    public cliente() {
    }

    public cliente(int id, Long usuarioId, String nombre, String apellido,
                   String documento, String telefono, String telefonoSecundario,
                   String correo, String direccion, String ciudad,
                   String notas, Date fechaRegistro) {

        this.id = id;
        this.usuarioId = usuarioId;
        this.nombre = nombre;
        this.apellido = apellido;
        this.documento = documento;
        this.telefono = telefono;
        this.telefonoSecundario = telefonoSecundario;
        this.correo = correo;
        this.direccion = direccion;
        this.ciudad = ciudad;
        this.notas = notas;
        this.fechaRegistro = fechaRegistro;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Long getUsuarioId() {
        return usuarioId;
    }

    public void setUsuarioId(Long usuarioId) {
        this.usuarioId = usuarioId;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getApellido() {
        return apellido;
    }

    public void setApellido(String apellido) {
        this.apellido = apellido;
    }

    public String getDocumento() {
        return documento;
    }

    public void setDocumento(String documento) {
        this.documento = documento;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getTelefonoSecundario() {
        return telefonoSecundario;
    }

    public void setTelefonoSecundario(String telefonoSecundario) {
        this.telefonoSecundario = telefonoSecundario;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public String getCiudad() {
        return ciudad;
    }

    public void setCiudad(String ciudad) {
        this.ciudad = ciudad;
    }

    public String getNotas() {
        return notas;
    }

    public void setNotas(String notas) {
        this.notas = notas;
    }

    public Date getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(Date fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    public String getNombreCompleto() {
        String n = nombre != null ? nombre : "";
        String a = apellido != null ? apellido : "";

        return (n + " " + a).trim();
    }
}