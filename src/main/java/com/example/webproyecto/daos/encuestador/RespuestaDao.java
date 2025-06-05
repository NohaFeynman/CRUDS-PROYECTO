package com.example.webproyecto.daos.encuestador;

import com.example.webproyecto.beans.Respuesta;

import java.sql.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class RespuestaDao {

    private final String url = "jdbc:mysql://localhost:3306/proyecto";
    private final String user = "root";
    private final String pass = "root";

    public void guardarRespuestas(List<Respuesta> respuestas) {

        String sql = "INSERT INTO respuesta (textoRespuesta, idSesion, idPregunta, idOpcion) VALUES (?, ?, ?, ?)";

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            for (Respuesta r : respuestas) {
                stmt.setString(1, r.getTextoRespuesta());
                stmt.setInt(2, r.getIdSesion());
                stmt.setInt(3, r.getIdPregunta());
                if (r.getIdOpcion() != null) {
                    stmt.setInt(4, r.getIdOpcion());
                } else {
                    stmt.setNull(4, Types.INTEGER);
                }
                stmt.addBatch();
            }
            stmt.executeBatch();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Map<Integer, Respuesta> obtenerRespuestasPorSesion(int idSesion) {
        Map<Integer, Respuesta> respuestas = new HashMap<>();

        String sql = """
        SELECT idpregunta, textoRespuesta, idopcion
        FROM respuesta
        WHERE idsesion = ?
    """;

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idSesion);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Respuesta r = new Respuesta();
                    r.setIdPregunta(rs.getInt("idpregunta"));
                    r.setTextoRespuesta(rs.getString("textoRespuesta"));

                    int idOpcion = rs.getInt("idopcion");
                    if (!rs.wasNull()) {
                        r.setIdOpcion(idOpcion);
                    }

                    respuestas.put(r.getIdPregunta(), r);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return respuestas;
    }


    public void eliminarRespuestasPorSesion(int idSesion) {
        String sql = "DELETE FROM respuesta WHERE idsesion = ?";

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idSesion);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

}
