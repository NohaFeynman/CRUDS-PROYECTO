package com.example.webproyecto.beans;

public class Zona {
    private int idzona;
    private String nombrezona;

    public int getIdzona() { return idzona; }
    public void setIdzona(int idzona) { this.idzona = idzona; }
    public String getNombrezona() { return nombrezona; }
    public void setNombrezona(String nombrezona) { this.nombrezona = nombrezona; }


    public Zona(Integer idZona, String nombreZona) {
        this.idzona = idZona;
        this.nombrezona = nombreZona;
    }

    public Integer getIdZona() {
        return idzona;
    }

    public void setIdZona(Integer idzona) {
        this.idzona = idzona;
    }

    public String getNombreZona() {
        return nombrezona;
    }

    public void setNombreZona(String nombrezona) {this.nombrezona = nombrezona;}
}