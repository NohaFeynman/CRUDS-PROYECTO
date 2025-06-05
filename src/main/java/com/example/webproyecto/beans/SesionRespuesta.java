package com.example.webproyecto.beans;
import java.time.LocalDateTime;
import java.util.Date;

public class SesionRespuesta {
    private Integer idSesion;
    private LocalDateTime fechaInicio;
    private LocalDateTime fechaEnvio;
    private int estadoTerminado; // 0 = no, 1 = si
    private Integer idAsignacionFormulario; // Foreign Key
    private String idEncuestado;
    private int numeroSesion;

    public SesionRespuesta() {
    }

    public SesionRespuesta(Integer idSesion, LocalDateTime fechaInicio, LocalDateTime fechaEnvio, int estadoTerminado, Integer idAsignacionFormulario, String idEncuestado) {
        this.idSesion = idSesion;
        this.fechaInicio = fechaInicio;
        this.fechaEnvio = fechaEnvio;
        this.estadoTerminado = estadoTerminado;
        this.idAsignacionFormulario = idAsignacionFormulario;
        this.idEncuestado = idEncuestado;

    }

    public Integer getIdSesion() {
        return idSesion;
    }

    public void setIdSesion(Integer idSesion) {
        this.idSesion = idSesion;
    }

    public LocalDateTime getFechaInicio() {
        return fechaInicio;
    }

    public void setFechaInicio(LocalDateTime fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    public LocalDateTime getFechaEnvio() {
        return fechaEnvio;
    }

    public void setFechaEnvio(LocalDateTime fechaEnvio) {
        this.fechaEnvio = fechaEnvio;
    }

    public int getEstadoTerminado() {
        return estadoTerminado;
    }

    public void setEstadoTerminado(int estadoTerminado) {
        this.estadoTerminado = estadoTerminado;
    }

    public Integer getIdAsignacionFormulario() {
        return idAsignacionFormulario;
    }

    public void setIdAsignacionFormulario(Integer idAsignacionFormulario) {
        this.idAsignacionFormulario = idAsignacionFormulario;
    }

    public String getIdEncuestado() {
        return idEncuestado;
    }

    public void setIdEncuestado(String idEncuestado) {
        this.idEncuestado = idEncuestado;
    }

    public int getNumeroSesion() {
        return numeroSesion;
    }

    public void setNumeroSesion(int numeroSesion) {
        this.numeroSesion = numeroSesion;
    }
}