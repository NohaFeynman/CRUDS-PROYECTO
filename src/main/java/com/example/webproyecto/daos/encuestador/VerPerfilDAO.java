package com.example.webproyecto.daos.encuestador;

import com.example.webproyecto.beans.Usuario;

import java.sql.*;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class VerPerfilDAO {
    private static final Logger logger = Logger.getLogger(VerPerfilDAO.class.getName());
    private final String url = "jdbc:mysql://localhost:3306/proyecto";
    private final String user = "root";
    private final String password = "root";

    public Map<String, Object> obtenerPerfilCompleto(int idUsuario) {
        Map<String, Object> datos = new HashMap<>();
        Usuario usuario = null;

        logger.log(Level.INFO, "Iniciando obtención de perfil para usuario ID: {0}", idUsuario);

        String sql = """
            SELECT u.idUsuario, u.nombre, u.apellidopaterno, u.apellidomaterno, u.dni, u.direccion,
                   u.idRol, u.idEstado, u.foto,
                   d.idDistrito, d.nombreDistrito,
                   z.idZona AS idZona, z.nombreZona AS nombreZona,
                   r.nombreRol,
                   e.nombreEstado,
                   c.correo
            FROM usuario u
            LEFT JOIN distrito d ON u.idDistrito = d.idDistrito
            LEFT JOIN zona z ON d.idZona = z.idZona
            LEFT JOIN rol r ON u.idRol = r.idRol
            LEFT JOIN estado e ON u.idEstado = e.idEstado
            LEFT JOIN credencial c ON u.idUsuario = c.idUsuario
            WHERE u.idUsuario = ?
        """;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            logger.info("Driver JDBC cargado correctamente");

            try (Connection conn = DriverManager.getConnection(url, user, password)) {
                logger.info("Conexión a BD establecida");

                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setInt(1, idUsuario);
                    logger.log(Level.INFO, "Ejecutando consulta: {0}", stmt.toString());

                    try (ResultSet rs = stmt.executeQuery()) {
                        if (rs.next()) {
                            logger.info("Usuario encontrado en BD");
                            usuario = new Usuario();

                            // Datos básicos
                            usuario.setIdUsuario(rs.getInt("idUsuario"));
                            usuario.setNombre(rs.getString("nombre"));
                            usuario.setApellidopaterno(rs.getString("apellidopaterno"));
                            usuario.setApellidomaterno(rs.getString("apellidomaterno"));
                            usuario.setDni(rs.getString("dni"));
                            usuario.setDireccion(rs.getString("direccion"));
                            usuario.setIdRol(rs.getInt("idRol"));
                            usuario.setIdEstado(rs.getInt("idEstado"));
                            usuario.setIdDistrito(rs.getInt("idDistrito"));

                            // Foto (base64)
                            Blob fotoBlob = rs.getBlob("foto");
                            if (fotoBlob != null && fotoBlob.length() > 0) {
                                byte[] fotoBytes = fotoBlob.getBytes(1, (int) fotoBlob.length());
                                String fotoBase64 = java.util.Base64.getEncoder().encodeToString(fotoBytes);
                                usuario.setFoto(fotoBase64);
                            } else {
                                usuario.setFoto(null);
                            }

                            // Armado del mapa de datos
                            datos.put("usuario", usuario);
                            datos.put("nombreDistrito", rs.getString("nombreDistrito") != null ?
                                    rs.getString("nombreDistrito") : "No especificado");
                            datos.put("correo", rs.getString("correo") != null ?
                                    rs.getString("correo") : "No especificado");
                            datos.put("nombreRol", rs.getString("nombreRol") != null ?
                                    rs.getString("nombreRol") : "No especificado");

                            // NUEVO: zona
                            datos.put("idZona", rs.getInt("idZona"));

                            // Apellidos concatenados
                            String apellidos = (rs.getString("apellidopaterno") != null ?
                                    rs.getString("apellidopaterno") : "") + " " +
                                    (rs.getString("apellidomaterno") != null ?
                                            rs.getString("apellidomaterno") : "");
                            datos.put("apellido", apellidos.trim());

                            logger.log(Level.INFO, "Datos preparados: {0}", datos);
                        } else {
                            logger.log(Level.WARNING, "No se encontró usuario con ID: {0}", idUsuario);
                        }
                    }
                }
            }
        } catch (ClassNotFoundException e) {
            logger.log(Level.SEVERE, "Error al cargar el driver JDBC", e);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error de SQL al obtener perfil", e);
        }

        return datos;
    }
}
