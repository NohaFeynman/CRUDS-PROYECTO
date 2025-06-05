package com.example.webproyecto.daos;

import com.example.webproyecto.beans.Credencial;
import com.example.webproyecto.beans.Usuario;
import com.mysql.cj.jdbc.Blob;

import java.sql.*;

public class CredencialDao {

    private final String url = "jdbc:mysql://localhost:3306/proyecto";
    private final String user = "root";
    private final String pass = "root";

    public Usuario validarLogin(String correo, String contrasenha) {
        Usuario usuario = null;

        String sql = """
            SELECT u.idUsuario, u.nombre, u.apellidopaterno, u.apellidomaterno, u.dni, u.direccion,
                   u.idRol, u.idDistrito, u.idEstado, u.foto
            FROM usuario u
            INNER JOIN credencial c ON u.idUsuario = c.idUsuario
            WHERE c.correo = ? AND c.contrasenha = ? AND u.idEstado = 2
            """;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection(url, user, pass);
                 PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setString(1, correo);
                stmt.setString(2, contrasenha);

                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    usuario = new Usuario();


                    usuario.setIdUsuario(rs.getInt("idUsuario"));
                    usuario.setNombre(rs.getString("nombre"));
                    usuario.setApellidopaterno(rs.getString("apellidopaterno"));
                    usuario.setApellidomaterno(rs.getString("apellidomaterno"));
                    usuario.setDni(rs.getString("dni"));
                    usuario.setDireccion(rs.getString("direccion"));
                    usuario.setIdDistrito(rs.getInt("idDistrito"));
                    usuario.setIdRol(rs.getInt("idRol"));
                    usuario.setIdEstado(rs.getInt("idEstado"));
                    usuario.setFoto(rs.getString("foto"));
                    System.out.println(usuario.getNombre());
                }

            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return usuario;
    }

    public boolean cambiarContrasenha(int idUsuario, String contrasenaActual, String nuevaContrasenha) {
        // Primero verificamos que la contraseña actual sea correcta
        String sqlVerificar = "SELECT 1 FROM credencial WHERE idUsuario = ? AND contrasenha = ?";
        String sqlActualizar = "UPDATE credencial SET contrasenha = ? WHERE idUsuario = ?";

        try (Connection conn = DriverManager.getConnection(url, user, pass)) {
            // Verificar contraseña actual
            try (PreparedStatement stmtVerificar = conn.prepareStatement(sqlVerificar)) {
                stmtVerificar.setInt(1, idUsuario);
                stmtVerificar.setString(2, contrasenaActual);

                ResultSet rs = stmtVerificar.executeQuery();
                if (!rs.next()) {
                    return false; // La contraseña actual no coincide
                }
            }

            // Actualizar a la nueva contraseña
            try (PreparedStatement stmtActualizar = conn.prepareStatement(sqlActualizar)) {
                stmtActualizar.setString(1, nuevaContrasenha);
                stmtActualizar.setInt(2, idUsuario);

                return stmtActualizar.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Métodos adicionales para CredencialDao.java

    // Métodos adicionales para CredencialDao
    public boolean insertarCredencial(Credencial credencial) {
        String sql = "INSERT INTO credencial (correo, contrasenha, idUsuario) VALUES (?, ?, ?)";

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, credencial.getCorreo());
            stmt.setString(2, credencial.getContrasenha());
            stmt.setInt(3, credencial.getIdUsuario());

            int filasAfectadas = stmt.executeUpdate();
            return filasAfectadas > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean existeCorreo(String correo) {
        String sql = "SELECT 1 FROM credencial WHERE correo = ?";

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, correo);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean actualizarCorreo(int idUsuario, String nuevoCorreo) {
        String sql = "UPDATE credencial SET correo = ? WHERE idUsuario = ?";

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, nuevoCorreo);
            stmt.setInt(2, idUsuario);

            int filasAfectadas = stmt.executeUpdate();
            return filasAfectadas > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

}


