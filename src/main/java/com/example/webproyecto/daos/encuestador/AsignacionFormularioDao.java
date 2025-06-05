package com.example.webproyecto.daos.encuestador;

import com.example.webproyecto.beans.AsignacionFormulario;
import com.example.webproyecto.beans.Formulario;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AsignacionFormularioDao {

    private final String url = "jdbc:mysql://localhost:3306/proyecto";
    private final String user = "root";
    private final String pass = "root";

    public List<AsignacionFormulario> obtenerFormulariosAsignados(int idEncuestador) {
        List<AsignacionFormulario> lista = new ArrayList<>();

        String sql = """
            SELECT af.*, f.titulo, f.descripcion, f.fechaCreacion
            FROM asignacionformulario af
            INNER JOIN formulario f ON af.idFormulario = f.idFormulario
            WHERE af.idEncuestador = ? and af.estado = 'Activo'
            """;

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            Class.forName("com.mysql.cj.jdbc.Driver");

            stmt.setInt(1, idEncuestador);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                AsignacionFormulario asignacion = new AsignacionFormulario();
                asignacion.setIdAsignacionFormulario(rs.getInt("idAsignacionFormulario"));
                asignacion.setIdEncuestador(rs.getInt("idEncuestador"));
                asignacion.setIdFormulario(rs.getInt("idFormulario"));
                asignacion.setFechaAsignacion(rs.getTimestamp("fechaAsignacion"));
                asignacion.setEstado(rs.getString("estado"));

                // Datos del formulario relacionado
                Formulario formulario = new Formulario();
                formulario.setIdFormulario(rs.getInt("idFormulario"));
                formulario.setTitulo(rs.getString("titulo"));
                formulario.setDescripcion(rs.getString("descripcion"));
                formulario.setFechaCreacion(rs.getTimestamp("fechaCreacion"));

                asignacion.setFormulario(formulario);

                lista.add(asignacion);
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return lista;
    }
}
