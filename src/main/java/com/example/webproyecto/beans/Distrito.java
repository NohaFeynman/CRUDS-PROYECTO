package com.example.webproyecto.beans;

public class Distrito {
    private Integer idDistrito;
    private String nombreDistrito;
    private Integer idZona; // Foreign Key

    public Distrito() {
    }

    public Distrito(Integer idDistrito, String nombreDistrito, Integer idZona) {
        this.idDistrito = idDistrito;
        this.nombreDistrito = nombreDistrito;
        this.idZona = idZona;
    }

    public Integer getIdDistrito() {
        return idDistrito;
    }

    public void setIdDistrito(Integer idDistrito) {
        this.idDistrito = idDistrito;
    }

    public String getNombreDistrito() {
        return nombreDistrito;
    }

    public void setNombreDistrito(String nombreDistrito) {
        this.nombreDistrito = nombreDistrito;
    }

    public Integer getIdZona() {
        return idZona;
    }

    public void setIdZona(Integer idZona) {
        this.idZona = idZona;
    }
}