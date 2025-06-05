package com.example.webproyecto.daos.encuestador;

import com.example.webproyecto.beans.Pregunta;
import com.example.webproyecto.beans.OpcionPregunta;

import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class PreguntaDao {

    private final String url = "jdbc:mysql://localhost:3306/proyecto";
    private final String user = "root";
    private final String pass = "root";

    // 1. Obtener TODAS las preguntas del formulario
    public List<Pregunta> obtenerPreguntasPorFormulario(int idFormulario) {
        List<Pregunta> lista = new ArrayList<>();

        String sql = """
            SELECT idPregunta, textoPregunta, tipoPregunta, idFormulario, orden, seccion, descripcion, obligatorio
            FROM pregunta
            WHERE idFormulario = ?
            ORDER BY orden ASC
        """;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection(url, user, pass);
                 PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setInt(1, idFormulario);

                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        Pregunta pregunta = new Pregunta();
                        pregunta.setIdPregunta(rs.getInt("idPregunta"));
                        pregunta.setTextoPregunta(rs.getString("textoPregunta"));
                        pregunta.setTipoPregunta(rs.getInt("tipoPregunta"));
                        pregunta.setIdFormulario(rs.getInt("idFormulario"));
                        pregunta.setOrden(rs.getInt("orden"));
                        pregunta.setSeccion(rs.getString("seccion"));
                        pregunta.setDescripcion(rs.getString("descripcion"));
                        pregunta.setObligatorio(rs.getInt("obligatorio"));

                        if (pregunta.getTipoPregunta() == 0) {
                            List<OpcionPregunta> opciones = obtenerOpcionesPorPregunta(pregunta.getIdPregunta(), conn);
                            pregunta.setOpciones(opciones);
                        }

                        lista.add(pregunta);
                    }
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return lista;
    }

    // 2. Obtener preguntas de una sección específica
    public List<Pregunta> obtenerPreguntasPorFormularioYSeccion(int idFormulario, String seccion) {
        List<Pregunta> lista = new ArrayList<>();

        String sql = """
            SELECT idPregunta, textoPregunta, tipoPregunta, idFormulario, orden, seccion, descripcion, obligatorio
            FROM pregunta
            WHERE idFormulario = ? AND seccion = ?
            ORDER BY orden ASC
        """;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection(url, user, pass);
                 PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setInt(1, idFormulario);
                stmt.setString(2, seccion);

                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        Pregunta pregunta = new Pregunta();
                        pregunta.setIdPregunta(rs.getInt("idPregunta"));
                        pregunta.setTextoPregunta(rs.getString("textoPregunta"));
                        pregunta.setTipoPregunta(rs.getInt("tipoPregunta"));
                        pregunta.setIdFormulario(rs.getInt("idFormulario"));
                        pregunta.setOrden(rs.getInt("orden"));
                        pregunta.setSeccion(rs.getString("seccion"));
                        pregunta.setDescripcion(rs.getString("descripcion"));
                        pregunta.setObligatorio(rs.getInt("obligatorio"));

                        if (pregunta.getTipoPregunta() == 0) {
                            List<OpcionPregunta> opciones = obtenerOpcionesPorPregunta(pregunta.getIdPregunta(), conn);
                            pregunta.setOpciones(opciones);
                        }

                        lista.add(pregunta);
                    }
                }

            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return lista;
    }

    // 3. Obtener UNA pregunta específica por su orden
    public Pregunta obtenerPreguntaPorFormularioYOrden(int idFormulario, int orden) {
        Pregunta pregunta = null;

        String sql = """
            SELECT idPregunta, textoPregunta, tipoPregunta, idFormulario, orden, seccion, descripcion, obligatorio
            FROM pregunta
            WHERE idFormulario = ? AND orden = ?
        """;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection(url, user, pass);
                 PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setInt(1, idFormulario);
                stmt.setInt(2, orden);

                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        pregunta = new Pregunta();
                        pregunta.setIdPregunta(rs.getInt("idPregunta"));
                        pregunta.setTextoPregunta(rs.getString("textoPregunta"));
                        pregunta.setTipoPregunta(rs.getInt("tipoPregunta"));
                        pregunta.setIdFormulario(rs.getInt("idFormulario"));
                        pregunta.setOrden(rs.getInt("orden"));
                        pregunta.setSeccion(rs.getString("seccion"));
                        pregunta.setDescripcion(rs.getString("descripcion"));
                        pregunta.setObligatorio(rs.getInt("obligatorio"));

                        if (pregunta.getTipoPregunta() == 0) {
                            List<OpcionPregunta> opciones = obtenerOpcionesPorPregunta(pregunta.getIdPregunta(), conn);
                            pregunta.setOpciones(opciones);
                        }
                    }
                }

            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return pregunta;
    }

    // Compartido por todos los métodos que necesiten cargar opciones
    private List<OpcionPregunta> obtenerOpcionesPorPregunta(int idPregunta, Connection conn) throws SQLException {
        List<OpcionPregunta> opciones = new ArrayList<>();

        String sql = """
            SELECT idOpcion, textoOpcion, idPregunta
            FROM opcionpregunta
            WHERE idPregunta = ?
        """;

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idPregunta);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    OpcionPregunta opcion = new OpcionPregunta();
                    opcion.setIdOpcion(rs.getInt("idOpcion"));
                    opcion.setTextoOpcion(rs.getString("textoOpcion"));
                    opcion.setIdPregunta(rs.getInt("idPregunta"));
                    opciones.add(opcion);
                }
            }
        }

        return opciones;
    }

    // 4. Obtener preguntas con sus opciones (opcional, para carga inicial)
    public List<Pregunta> obtenerPreguntasConOpciones(int idFormulario) {
        List<Pregunta> preguntas = new ArrayList<>();

        String sql = """
            SELECT p.idpregunta, p.textopregunta, p.tipopregunta, p.orden, p.seccion, p.descripcion, p.obligatorio,
                   o.idopcion, o.textoopcion
            FROM pregunta p
            LEFT JOIN opcionpregunta o ON p.idpregunta = o.idpregunta
            WHERE p.idformulario = ?
            ORDER BY p.orden ASC, o.idopcion ASC
        """;

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idFormulario);
            try (ResultSet rs = stmt.executeQuery()) {
                Map<Integer, Pregunta> mapaPreguntas = new LinkedHashMap<>();

                while (rs.next()) {
                    int idPregunta = rs.getInt("idpregunta");
                    Pregunta pregunta = mapaPreguntas.get(idPregunta);

                    if (pregunta == null) {
                        pregunta = new Pregunta();
                        pregunta.setIdPregunta(idPregunta);
                        pregunta.setTextoPregunta(rs.getString("textopregunta"));
                        pregunta.setTipoPregunta(rs.getInt("tipopregunta"));
                        pregunta.setOrden(rs.getInt("orden"));
                        pregunta.setSeccion(rs.getString("seccion"));
                        pregunta.setDescripcion(rs.getString("descripcion"));
                        pregunta.setObligatorio(rs.getInt("obligatorio"));
                        pregunta.setOpciones(new ArrayList<>());
                        mapaPreguntas.put(idPregunta, pregunta);
                    }

                    int idOpcion = rs.getInt("idopcion");
                    if (!rs.wasNull()) {
                        OpcionPregunta opcion = new OpcionPregunta();
                        opcion.setIdOpcion(idOpcion);
                        opcion.setTextoOpcion(rs.getString("textoopcion"));
                        opcion.setIdPregunta(idPregunta);
                        pregunta.getOpciones().add(opcion);
                    }
                }

                preguntas.addAll(mapaPreguntas.values());
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return preguntas;
    }
}
