package com.example.webproyecto.beans;

public class Credencial {
    private int idCredenciales;
    private String correo;
    private String contrasenha;
    private int idUsuario;

    // Getters y Setters

    public int getIdCredenciales() {
        return idCredenciales;
    }

    public void setIdCredenciales(int idCredenciales) {
        this.idCredenciales = idCredenciales;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getContrasenha() {
        return contrasenha;
    }

    public void setContrasenha(String contrasenha) {
        this.contrasenha = contrasenha;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }
}
