
package com.rescatemovil.modelo;

public class Tecnico {

    private int id;
    private Long usuarioId;
    private String nombre;
    private String especialidad;
    private String telefono;
    private String correo;
    private int reparacionesActivas;
    private boolean activo;

    public Tecnico() {
    }

    public Tecnico(int id, Long usuarioId, String nombre,
                   String especialidad, String telefono,
                   String correo, int reparacionesActivas,
                   boolean activo) {
        this.id = id;
        this.usuarioId = usuarioId;
        this.nombre = nombre;
        this.especialidad = especialidad;
        this.telefono = telefono;
        this.correo = correo;
        this.reparacionesActivas = reparacionesActivas;
        this.activo = activo;
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

    public String getEspecialidad() {
        return especialidad;
    }

    public void setEspecialidad(String especialidad) {
        this.especialidad = especialidad;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public int getReparacionesActivas() {
        return reparacionesActivas;
    }

    public void setReparacionesActivas(int reparacionesActivas) {
        this.reparacionesActivas = reparacionesActivas;
    }

    public boolean isActivo() {
        return activo;
    }

    public void setActivo(boolean activo) {
        this.activo = activo;
    }
}