package com.example.webproyecto.beans;
//-------------------- roles --------------------
public class Rol {
    private Byte idRol;
    private String nombreRol;

    public Rol() {
    }

    public Rol(Byte idRol, String nombreRol) {
        this.idRol = idRol;
        this.nombreRol = nombreRol;
    }

    public Byte getIdRol() {
        return idRol;
    }

    public void setIdRol(Byte idRol) {
        this.idRol = idRol;
    }

    public String getNombreRol() {
        return nombreRol;
    }

    public void setNombreRol(String nombreRol) {
        this.nombreRol = nombreRol;
    }
}

