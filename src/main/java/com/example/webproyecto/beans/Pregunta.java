package com.example.webproyecto.beans;

import java.util.List;

public class Pregunta {
    private int idPregunta;
    private String textoPregunta;
    private int tipoPregunta; // 1 = Abierta, 0 = Opción múltiple
    private int idFormulario;
    private int orden;
    private String seccion;
    private String descripcion;
    private int obligatorio;

    // Lista de opciones si es tipo opción múltiple
    private List<OpcionPregunta> opciones;

    // Getters y Setters
    public int getIdPregunta() {
        return idPregunta;
    }

    public void setIdPregunta(int idPregunta) {
        this.idPregunta = idPregunta;
    }

    public String getTextoPregunta() {
        return textoPregunta;
    }

    public void setTextoPregunta(String textoPregunta) {
        this.textoPregunta = textoPregunta;
    }

    public int getTipoPregunta() {
        return tipoPregunta;
    }

    public void setTipoPregunta(int tipoPregunta) {
        this.tipoPregunta = tipoPregunta;
    }

    public int getIdFormulario() {
        return idFormulario;
    }

    public void setIdFormulario(int idFormulario) {
        this.idFormulario = idFormulario;
    }

    public int getOrden() {
        return orden;
    }

    public void setOrden(int orden) {
        this.orden = orden;
    }

    public List<OpcionPregunta> getOpciones() {
        return opciones;
    }

    public void setOpciones(List<OpcionPregunta> opciones) {
        this.opciones = opciones;
    }

    public String getSeccion() {
        return seccion;
    }

    public void setSeccion(String seccion) {
        this.seccion = seccion;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public int getObligatorio() {
        return obligatorio;
    }

    public void setObligatorio(int obligatorio) {
        this.obligatorio = obligatorio;
    }
}
