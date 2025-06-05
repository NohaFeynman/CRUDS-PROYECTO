package com.example.webproyecto.servlets.encuestador;

import com.example.webproyecto.beans.Usuario;
import com.example.webproyecto.daos.UsuarioDao;
import com.example.webproyecto.daos.encuestador.VerPerfilDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.InputStream;
import java.util.Map;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 5,   // 5MB
        maxRequestSize = 1024 * 1024 * 10 // 10MB
)
@WebServlet("/ActualizarPerfilServlet")
public class ActualizarPerfilServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String redirectUrl = request.getContextPath() + "/VerPerfilServlet";
        UsuarioDao usuarioDao = new UsuarioDao();

        try {
            // Validación de sesión
            Integer idUsuario = (Integer) session.getAttribute("idUsuario");
            if (idUsuario == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            // Obtener parámetros (pueden ser null o vacíos)
            String direccion = request.getParameter("direccion");
            String idDistritoStr = request.getParameter("idDistrito");
            Integer idDistrito = null;
            if (idDistritoStr != null && !idDistritoStr.isEmpty()) {
                try {
                    idDistrito = Integer.parseInt(idDistritoStr);
                } catch (NumberFormatException e) {
                    session.setAttribute("mensajeError", "Distrito inválido");
                    response.sendRedirect(redirectUrl);
                    return;
                }
            }

            Part filePart = request.getPart("fotoPerfil");
            InputStream fotoStream = null;
            if (filePart != null && filePart.getSize() > 0) {
                if (!filePart.getContentType().startsWith("image/")) {
                    session.setAttribute("mensajeError", "Solo se permiten imágenes (JPEG, PNG, etc.)");
                    response.sendRedirect(redirectUrl);
                    return;
                }
                fotoStream = filePart.getInputStream();
            }

            // Si todos los campos están vacíos, no hacer nada
            if ((direccion == null || direccion.trim().isEmpty()) && idDistrito == null && fotoStream == null) {
                session.setAttribute("mensajeError", "No se detectaron cambios para actualizar");
                response.sendRedirect(redirectUrl);
                return;
            }
            if (direccion != null && direccion.trim().isEmpty()) direccion = null;

            // Actualizar solo los campos modificados
            boolean exito = usuarioDao.actualizarPorPartes(idUsuario, direccion, idDistrito, fotoStream);

            if (exito) {
                // Forzar recarga completa del perfil
                VerPerfilDAO perfilDao = new VerPerfilDAO();
                Map<String, Object> datosPerfil = perfilDao.obtenerPerfilCompleto(idUsuario);
                session.setAttribute("datosPerfil", datosPerfil);
                session.setAttribute("mensajeExito", "Perfil actualizado correctamente");
                session.setAttribute("fotoTimestamp", System.currentTimeMillis());
            } else {
                session.setAttribute("mensajeError", "Error al actualizar perfil");
            }
        } catch (Exception e) {
            session.setAttribute("mensajeError", "Error: " + e.getMessage());
            e.printStackTrace();
        }
        response.sendRedirect(redirectUrl);
    }
}

/*public class ActualizarPerfilServlet extends HttpServlet { // ← Sin @MultipartConfig

    /*protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String redirectUrl = request.getContextPath() + "/VerPerfilServlet";

        try {
            // 1. Validar sesión
            if (session.getAttribute("idUsuario") == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            // 2. Obtener parámetros con validación
            int idUsuario = (int) session.getAttribute("idUsuario");
            String direccion = request.getParameter("direccion");
            String idDistritoStr = request.getParameter("idDistrito"); // Obtener como String primero

            // 3. Validar campos obligatorios
            if (direccion == null || direccion.trim().isEmpty() || idDistritoStr == null) {
                session.setAttribute("mensajeError", "Dirección y distrito son requeridos");
                response.sendRedirect(redirectUrl);
                return;
            }

            // 4. Convertir distrito a int
            int idDistrito;
            try {
                idDistrito = Integer.parseInt(idDistritoStr);
            } catch (NumberFormatException e) {
                session.setAttribute("mensajeError", "Distrito inválido");
                response.sendRedirect(redirectUrl);
                return;
            }


            System.out.println("Valores a actualizar - idUsuario: " + idUsuario +
                    ", direccion: " + direccion +
                    ", idDistrito: " + idDistrito);

            // 5. Actualizar en BD
            UsuarioDao usuarioDao = new UsuarioDao();
            boolean exito = usuarioDao.actualizarDireccionYDistrito(idUsuario, direccion, idDistrito);


            System.out.println("Resultado de actualización: " + exito);

            // 6. Mostrar resultado
            if (exito) {
                session.setAttribute("mensajeExito", "¡Perfil actualizado correctamente!");
            } else {
                session.setAttribute("mensajeError", "Error al actualizar en la base de datos");
            }

        } catch (Exception e) {
            session.setAttribute("mensajeError", "Error: " + e.getMessage());
            e.printStackTrace();
        }

        response.sendRedirect(redirectUrl);
    }
}*/


    /*protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String redirectUrl = request.getContextPath() + "/VerPerfilServlet";

        try {
            // 1. Obtener parámetros
            int idUsuario = (int) session.getAttribute("idUsuario");
            String direccion = request.getParameter("direccion");
            int idDistrito = Integer.parseInt(request.getParameter("idDistrito"));
            Part filePart = request.getPart("fotoPerfil"); // Puede ser null

            // 2. Validaciones básicas
            if (direccion == null || direccion.trim().isEmpty()) {
                throw new ServletException("La dirección es requerida");
            }

            // 3. Procesar imagen (si se subió)
            String nuevaRutaFoto = null;
            if (filePart != null && filePart.getSize() > 0) {
                if (!filePart.getContentType().startsWith("image/")) {
                    throw new ServletException("Solo se permiten imágenes (JPEG, PNG, etc.)");
                }

                // Crear directorio "uploads" si no existe
                String uploadPath = getServletContext().getRealPath("/uploads");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();

                // Generar nombre único para el archivo
                String fileName = "user_" + idUsuario + "_" + System.currentTimeMillis() +
                        filePart.getSubmittedFileName().substring(filePart.getSubmittedFileName().lastIndexOf("."));
                String filePath = uploadPath + File.separator + fileName;

                // Guardar archivo
                try (InputStream input = filePart.getInputStream();
                     OutputStream output = new FileOutputStream(filePath)) {
                    byte[] buffer = new byte[1024];
                    int bytesRead;
                    while ((bytesRead = input.read(buffer)) != -1) {
                        output.write(buffer, 0, bytesRead);
                    }
                }

                nuevaRutaFoto = "uploads/" + fileName;

                // Eliminar foto anterior (si existe)
                Usuario usuarioActual = new UsuarioDao().obtenerUsuarioPorId(idUsuario);
                if (usuarioActual != null && usuarioActual.getFoto() != null) {
                    File fotoAnterior = new File(getServletContext().getRealPath(usuarioActual.getFoto()));
                    if (fotoAnterior.exists()) fotoAnterior.delete();
                }
            }

            // 4. Actualizar en la base de datos
            UsuarioDao usuarioDao = new UsuarioDao();

            boolean exito = usuarioDao.actualizarPorPartes(idUsuario, direccion, idDistrito, nuevaRutaFoto);

            if (exito) {
                Usuario usuarioActualizado = usuarioDao.obtenerUsuarioPorId(idUsuario); // volver a cargar datos
                session.setAttribute("datosPerfil", usuarioActualizado); // ahora sí actualizado
                session.setAttribute("mensajeExito", "¡Perfil actualizado correctamente!");
                if (nuevaRutaFoto != null) {
                    session.setAttribute("fotoPerfil", nuevaRutaFoto);
                }
            } else {
                throw new ServletException("Error al actualizar en la base de datos");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("mensajeError", "Distrito inválido");
        } catch (Exception e) {
            session.setAttribute("mensajeError", "Error: " + e.getMessage());
            e.printStackTrace();
        }

        response.sendRedirect(redirectUrl);
    }*/