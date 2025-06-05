package com.example.webproyecto.daos.encuestador;

import java.sql.*;

public class FormularioDao {

    private final String url = "jdbc:mysql://localhost:3306/proyecto";
    private final String user = "root";
    private final String pass = "root";

    /**
     * Retorna el título de un formulario dado su ID.
     *
     * @param idFormulario ID del formulario
     * @return título del formulario si existe, cadena vacía si no
     */
    public String obtenerTituloFormularioPorId(int idFormulario) {
        String titulo = "";

        String sql = "SELECT titulo FROM formulario WHERE idFormulario = ?";

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idFormulario);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    titulo = rs.getString("titulo");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return titulo;
    }
}

