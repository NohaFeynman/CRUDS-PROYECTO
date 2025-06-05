package com.example.webproyecto.daos;

import com.example.webproyecto.beans.Distrito;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DistritoDao {
    private final String url = "jdbc:mysql://localhost:3306/proyecto";
    private final String user = "root";
    private final String pass = "root";

    public List<Distrito> listarDistritos() {
        List<Distrito> distritos = new ArrayList<>();
        String sql = "SELECT iddistrito, nombredistrito, idzona FROM distrito ORDER BY nombredistrito";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection(url, user, pass);
                 PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {
                    Distrito distrito = new Distrito();
                    distrito.setIdDistrito(rs.getInt("iddistrito"));
                    distrito.setNombreDistrito(rs.getString("nombredistrito"));
                    distrito.setIdZona(rs.getInt("idzona"));
                    distritos.add(distrito);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return distritos;
    }
}