package com.example.webproyecto.beans;
public class Carpeta {
    private Integer idcarpeta;
    private String nombreCarpeta;

    public Carpeta() {
    }

    public Carpeta(Integer idcarpeta, String nombreCarpeta) {
        this.idcarpeta = idcarpeta;
        this.nombreCarpeta = nombreCarpeta;
    }

    public Integer getIdcarpeta() {
        return idcarpeta;
    }

    public void setIdcarpeta(Integer idcarpeta) {
        this.idcarpeta = idcarpeta;
    }

    public String getNombreCarpeta() {
        return nombreCarpeta;
    }

    public void setNombreCarpeta(String nombreCarpeta) {
        this.nombreCarpeta = nombreCarpeta;
    }
}