package com.example.webproyecto.daos.encuestador;

import com.example.webproyecto.beans.Zona;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ZonaDao {
    private final String url = "jdbc:mysql://localhost:3306/proyecto";
    private final String user = "root";
    private final String pass = "root";

    public List<Zona> listarZonas() {
        List<Zona> zonas = new ArrayList<>();
        String sql = "SELECT idZona, nombreZona FROM zona ORDER BY nombreZona";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, user, pass);
                 PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Zona zona = new Zona(rs.getInt("idZona"), rs.getString("nombreZona"));
                    zonas.add(zona);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return zonas;
    }
}