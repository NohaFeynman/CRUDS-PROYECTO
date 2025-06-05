package com.example.webproyecto.beans;

//-------------------- respuestas --------------------
public class Respuesta {
    private Integer idRespuesta;
    private String textoRespuesta;
    private Integer idSesion;     // Foreign Key
    private Integer idPregunta;   // Foreign Key
    private Integer idOpcion;     // Foreign Key (Nullable)

    public Respuesta() {
    }

    public Respuesta(Integer idRespuesta, String textoRespuesta, Integer idSesion, Integer idPregunta, Integer idOpcion) {
        this.idRespuesta = idRespuesta;
        this.textoRespuesta = textoRespuesta;
        this.idSesion = idSesion;
        this.idPregunta = idPregunta;
        this.idOpcion = idOpcion;
    }

    public Integer getIdRespuesta() {
        return idRespuesta;
    }

    public void setIdRespuesta(Integer idRespuesta) {
        this.idRespuesta = idRespuesta;
    }

    public String getTextoRespuesta() {
        return textoRespuesta;
    }

    public void setTextoRespuesta(String textoRespuesta) {
        this.textoRespuesta = textoRespuesta;
    }

    public Integer getIdSesion() {
        return idSesion;
    }

    public void setIdSesion(Integer idSesion) {
        this.idSesion = idSesion;
    }

    public Integer getIdPregunta() {
        return idPregunta;
    }

    public void setIdPregunta(Integer idPregunta) {
        this.idPregunta = idPregunta;
    }

    public Integer getIdOpcion() {
        return idOpcion;
    }

    public void setIdOpcion(Integer idOpcion) {
        this.idOpcion = idOpcion;
    }
}