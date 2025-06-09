package com.example.webproyecto.servlets.encuestador;

import com.example.webproyecto.beans.Pregunta;
import com.example.webproyecto.daos.encuestador.PreguntaDao;
import com.example.webproyecto.daos.encuestador.FormularioDao;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "RespuestaFormularioServlet", value = "/RespuestaFormularioServlet")
public class RespuestaFormularioServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("idUsuario") == null ||
                (int) session.getAttribute("idrol") != 3) {
            response.sendRedirect("../login.jsp");
            return;
        }

        // Obtener parámetros
        String idFormularioStr = request.getParameter("idFormulario");
        String idAsignacionFormularioStr = request.getParameter("idAsignacionFormulario");
        String idEncuestado = request.getParameter("idEncuestado"); // puede ser null si no se usa aún
        System.out.println(idAsignacionFormularioStr);
        if (idFormularioStr == null || idFormularioStr.isEmpty()) {
            response.sendRedirect("FormulariosAsignadosServlet");
            return;
        }

        int idFormulario = Integer.parseInt(idFormularioStr);

        // Obtener preguntas y título
        PreguntaDao preguntaDao = new PreguntaDao();
        List<Pregunta> preguntas = preguntaDao.obtenerPreguntasPorFormulario(idFormulario);

        FormularioDao formularioDao = new FormularioDao();
        String titulo = formularioDao.obtenerTituloFormularioPorId(idFormulario);

        // Enviar datos al JSP
        request.setAttribute("preguntas", preguntas);
        request.setAttribute("idFormulario", idFormulario);
        request.setAttribute("titulo", titulo);
        request.setAttribute("idAsignacionFormulario", idAsignacionFormularioStr);
        request.setAttribute("idEncuestado", idEncuestado);
        System.out.println(idAsignacionFormularioStr);
        request.getRequestDispatcher("/formularioRespuesta.jsp").forward(request, response);
    }
}
