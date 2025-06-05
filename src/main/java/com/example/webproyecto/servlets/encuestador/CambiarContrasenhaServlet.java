package com.example.webproyecto.servlets.encuestador;

import com.example.webproyecto.beans.Usuario;
import com.example.webproyecto.daos.CredencialDao;
import com.example.webproyecto.daos.encuestador.VerPerfilDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "CambiarContrasenhaServlet", value = "/CambiarContrasenhaServlet")
public class CambiarContrasenhaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("idUsuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int idUsuario = (int) session.getAttribute("idUsuario");
        VerPerfilDAO perfilDao = new VerPerfilDAO();
        Map<String, Object> datosPerfil = perfilDao.obtenerPerfilCompleto(idUsuario);

        if (datosPerfil != null && datosPerfil.get("usuario") != null) {
            // Pasar todos los datos necesarios
            request.setAttribute("datosPerfil", datosPerfil);

            // Pasar nombre completo como atributo separado
            Usuario usuario = (Usuario) datosPerfil.get("usuario");
            String nombreCompleto = usuario.getNombre() + " " + datosPerfil.get("apellido");
            request.setAttribute("nombreCompleto", nombreCompleto);

            request.getRequestDispatcher("/cambiarContrasenha.jsp").forward(request, response);
        } else {
            session.setAttribute("error", "No se pudo cargar los datos del perfil");
            response.sendRedirect(request.getContextPath() + "/InicioEncuestadorServlet");
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Validar sesión
        if (session == null || session.getAttribute("idUsuario") == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        int idUsuario = (int) session.getAttribute("idUsuario");
        String contrasenhaActual = request.getParameter("contrasenhaActual");
        String nuevaContrasenha = request.getParameter("nuevaContrasenha");
        String confirmarContrasenha = request.getParameter("confirmarContrasenha");

        // Validaciones
        if (contrasenhaActual == null || nuevaContrasenha == null || confirmarContrasenha == null) {
            // Recargar datos de perfil para el sidebar
            VerPerfilDAO perfilDao = new VerPerfilDAO();
            Map<String, Object> datosPerfil = perfilDao.obtenerPerfilCompleto(idUsuario);
            request.setAttribute("datosPerfil", datosPerfil);
            if (datosPerfil != null && datosPerfil.get("usuario") != null) {
                Usuario usuario = (Usuario) datosPerfil.get("usuario");
                String nombreCompleto = usuario.getNombre() + " " + datosPerfil.get("apellido");
                request.setAttribute("nombreCompleto", nombreCompleto);
            }
            request.setAttribute("error", "Todos los campos son obligatorios");
            request.getRequestDispatcher("/cambiarContrasenha.jsp").forward(request, response);
            return;
        }

        if (nuevaContrasenha.length() < 8) {
            VerPerfilDAO perfilDao = new VerPerfilDAO();
            Map<String, Object> datosPerfil = perfilDao.obtenerPerfilCompleto(idUsuario);
            request.setAttribute("datosPerfil", datosPerfil);
            if (datosPerfil != null && datosPerfil.get("usuario") != null) {
                Usuario usuario = (Usuario) datosPerfil.get("usuario");
                String nombreCompleto = usuario.getNombre() + " " + datosPerfil.get("apellido");
                request.setAttribute("nombreCompleto", nombreCompleto);
            }
            request.setAttribute("error", "La nueva contraseña debe tener al menos 8 caracteres");
            request.getRequestDispatcher("/cambiarContrasenha.jsp").forward(request, response);
            return;
        }

        if (!nuevaContrasenha.equals(confirmarContrasenha)) {
            VerPerfilDAO perfilDao = new VerPerfilDAO();
            Map<String, Object> datosPerfil = perfilDao.obtenerPerfilCompleto(idUsuario);
            request.setAttribute("datosPerfil", datosPerfil);
            if (datosPerfil != null && datosPerfil.get("usuario") != null) {
                Usuario usuario = (Usuario) datosPerfil.get("usuario");
                String nombreCompleto = usuario.getNombre() + " " + datosPerfil.get("apellido");
                request.setAttribute("nombreCompleto", nombreCompleto);
            }
            request.setAttribute("error", "Las contraseñas nuevas no coinciden");
            request.getRequestDispatcher("/cambiarContrasenha.jsp").forward(request, response);
            return;
        }

        // Procesar cambio de contraseña
        CredencialDao credencialDao = new CredencialDao();
        boolean cambioExitoso = credencialDao.cambiarContrasenha(
                idUsuario, contrasenhaActual, nuevaContrasenha);

        if (cambioExitoso) {
            session.setAttribute("mensajeExito", "Contraseña cambiada exitosamente");
            response.sendRedirect(request.getContextPath() + "/VerPerfilServlet");
        } else {
            VerPerfilDAO perfilDao = new VerPerfilDAO();
            Map<String, Object> datosPerfil = perfilDao.obtenerPerfilCompleto(idUsuario);
            request.setAttribute("datosPerfil", datosPerfil);
            if (datosPerfil != null && datosPerfil.get("usuario") != null) {
                Usuario usuario = (Usuario) datosPerfil.get("usuario");
                String nombreCompleto = usuario.getNombre() + " " + datosPerfil.get("apellido");
                request.setAttribute("nombreCompleto", nombreCompleto);
            }
            request.setAttribute("error", "Contraseña actual incorrecta");
            request.getRequestDispatcher("/cambiarContrasenha.jsp").forward(request, response);
        }
    }
}