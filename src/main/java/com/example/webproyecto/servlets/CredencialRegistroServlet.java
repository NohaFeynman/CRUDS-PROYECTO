package com.example.webproyecto.servlets;

import com.example.webproyecto.beans.Distrito;
import com.example.webproyecto.beans.Usuario;
import com.example.webproyecto.beans.Credencial;
import com.example.webproyecto.daos.CredencialDao;
import com.example.webproyecto.daos.DistritoDao;
import com.example.webproyecto.daos.UsuarioDao;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet(name = "CredencialRegistroServlet", urlPatterns = {"/registro"})
public class CredencialRegistroServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DistritoDao distritoDao = new DistritoDao();
        request.setAttribute("distritos", distritoDao.listarDistritos());
        request.getRequestDispatcher("registro.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Recoger parámetros
        String nombre = request.getParameter("nombre");
        String apellidoPaterno = request.getParameter("apellidoPaterno");
        String apellidoMaterno = request.getParameter("apellidoMaterno");
        String dni = request.getParameter("dni");
        String direccion = request.getParameter("direccion");
        int idDistrito = Integer.parseInt(request.getParameter("distrito"));
        String correo = request.getParameter("correo");
        String contrasenha = request.getParameter("contrasenha");
        String confirmarContrasenha = request.getParameter("confirmarContrasenha");

        // Validar contraseñas
        if (!contrasenha.equals(confirmarContrasenha)) {
            request.setAttribute("error", "Las contraseñas no coinciden");
            doGet(request, response);
            return;
        }

        // Crear objetos
        Usuario usuario = new Usuario();
        usuario.setNombre(nombre);
        usuario.setApellidopaterno(apellidoPaterno);
        usuario.setApellidomaterno(apellidoMaterno);
        usuario.setDni(dni);
        usuario.setDireccion(direccion);
        usuario.setIdDistrito(idDistrito);
        usuario.setIdRol(3); // Rol por defecto (2 = usuario normal)
        usuario.setIdEstado(2); // Estado activo

        Credencial credencial = new Credencial();
        credencial.setCorreo(correo);
        credencial.setContrasenha(contrasenha);

        // Registrar en BD
        UsuarioDao usuarioDao = new UsuarioDao();
        CredencialDao credencialDao = new CredencialDao();

        try {
            // Verificar si el correo ya existe
            if (credencialDao.existeCorreo(correo)) {
                request.setAttribute("error", "El correo ya está registrado");
                doGet(request, response);
                return;
            }

            // Verificar si el DNI ya existe
            if (usuarioDao.existeDni(dni)) {
                request.setAttribute("error", "El DNI ya está registrado");
                doGet(request, response);
                return;
            }

            // Insertar usuario
            if (usuarioDao.insertarUsuario(usuario)) {
                // Obtener ID del usuario insertado
                Usuario usuarioRegistrado = usuarioDao.obtenerUsuarioPorDni(dni);
                credencial.setIdUsuario(usuarioRegistrado.getIdUsuario());

                // Insertar credencial
                if (credencialDao.insertarCredencial(credencial)) {
                    // Redirigir a login con mensaje de éxito
                    response.sendRedirect("login.jsp?registro=exito");
                    return;
                }
            }

            request.setAttribute("error", "Error en el registro. Intente nuevamente.");
            doGet(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error en el servidor: " + e.getMessage()); // Mostrar detalle
            doGet(request, response);
        }
    }
}