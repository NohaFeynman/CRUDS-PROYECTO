package com.example.webproyecto.servlets.encuestador;

import com.example.webproyecto.beans.*;
import com.example.webproyecto.daos.encuestador.VerPerfilDAO;
import com.example.webproyecto.daos.DistritoDao;
import com.example.webproyecto.daos.encuestador.ZonaDao;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "VerPerfilServlet", value = "/VerPerfilServlet")
public class VerPerfilServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("idUsuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {

            if (session.getAttribute("mensajeExito") != null) {
                request.setAttribute("mensajeExito", session.getAttribute("mensajeExito"));
                session.removeAttribute("mensajeExito");
            }

            int idUsuario = (int) session.getAttribute("idUsuario");
            System.out.println("ID de usuario en sesión: " + idUsuario);
            VerPerfilDAO perfilDao = new VerPerfilDAO();
            Map<String, Object> datosPerfil = perfilDao.obtenerPerfilCompleto(idUsuario);

            // Cargar lista de zonas y distritos
            ZonaDao zonaDao = new ZonaDao();
            request.setAttribute("zonas", zonaDao.listarZonas());
            DistritoDao distritoDao = new DistritoDao();
            request.setAttribute("distritos", distritoDao.listarDistritos());

            // Depuración - verificar datos recibidos del DAO
            System.out.println("Datos recibidos del DAO:");
            System.out.println("Usuario: " + datosPerfil.get("usuario"));
            System.out.println("Apellidos: " + datosPerfil.get("apellido"));
            System.out.println("Rol: " + datosPerfil.get("nombreRol"));

            if (datosPerfil != null && !datosPerfil.isEmpty() && datosPerfil.get("usuario") != null) {
                // Pasar todos los datos necesarios a la vista
                request.setAttribute("datosPerfil", datosPerfil);

                // Pasar el nombre completo como atributo separado
                Usuario usuario = (Usuario) datosPerfil.get("usuario");

                // NUEVO: guardar ruta de la foto en la sesión
                session.setAttribute("fotoPerfil", usuario.getFoto());

                String nombreCompleto = usuario.getNombre() + " " + datosPerfil.get("apellido");
                request.setAttribute("nombreCompleto", nombreCompleto);

                // Depuración
                System.out.println("Atributos enviados a la vista:");
                System.out.println("Nombre completo: " + nombreCompleto);

                request.getRequestDispatcher("/verPerfil.jsp").forward(request, response);
            } else {
                session.setAttribute("error", "No se encontraron datos del perfil");
                response.sendRedirect(request.getContextPath() + "/InicioEncuestadorServlet");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error al cargar perfil: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/InicioEncuestadorServlet");
        }
    }
}