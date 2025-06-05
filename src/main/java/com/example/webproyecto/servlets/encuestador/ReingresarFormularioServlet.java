package com.example.webproyecto.servlets.encuestador;

import com.example.webproyecto.beans.Pregunta;
import com.example.webproyecto.beans.Respuesta;
import com.example.webproyecto.daos.encuestador.PreguntaDao;
import com.example.webproyecto.daos.encuestador.RespuestaDao;
import com.example.webproyecto.daos.encuestador.SesionRespuestaDao;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ReingresarFormularioServlet", value = "/ReingresarFormularioServlet")
public class ReingresarFormularioServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("idUsuario") == null ||
                (int) session.getAttribute("rolId") != 3) {
            response.sendRedirect("login.jsp");
            return;
        }

        int idSesion = Integer.parseInt(request.getParameter("idSesion"));

        SesionRespuestaDao sesionDao = new SesionRespuestaDao();
        Map<String, Object> datosSesion = sesionDao.obtenerInfoSesion(idSesion);

        if (datosSesion == null) {
            response.sendRedirect("HistorialFormulariosServlet");
            return;
        }

        int idFormulario = (int) datosSesion.get("idformulario");
        int idAsignacionFormulario = (int) datosSesion.get("idasignacionformulario");

        // Obtener preguntas + opciones
        PreguntaDao preguntaDao = new PreguntaDao();
        List<Pregunta> preguntas = preguntaDao.obtenerPreguntasConOpciones(idFormulario);

        // Obtener respuestas anteriores
        RespuestaDao respuestaDao = new RespuestaDao();
        Map<Integer, Respuesta> respuestasAnteriores = respuestaDao.obtenerRespuestasPorSesion(idSesion);

        // Enviar a JSP
        request.setAttribute("preguntas", preguntas);
        request.setAttribute("respuestasAnteriores", respuestasAnteriores);
        request.setAttribute("idFormulario", idFormulario);
        request.setAttribute("idAsignacionFormulario", idAsignacionFormulario);
        request.setAttribute("idSesion", idSesion);
        request.setAttribute("modoReingreso", true);

        System.out.println("=== DEBUG MAP DE RESPUESTAS ===");
        for (Map.Entry<Integer, Respuesta> entry : respuestasAnteriores.entrySet()) {
            Integer idP = entry.getKey();
            Respuesta r = entry.getValue();
            System.out.println("🧪 PreguntaID: " + idP +
                    " | textoRespuesta = " + r.getTextoRespuesta() +
                    " | idOpcion = " + r.getIdOpcion());
        }

        System.out.println("===== DEBUG: MAP de respuestasAnteriores =====");
        for (Map.Entry<Integer, Respuesta> entry : respuestasAnteriores.entrySet()) {
            Respuesta r = entry.getValue();
            System.out.println("Pregunta ID: " + r.getIdPregunta());
            System.out.println("Texto respuesta: " + r.getTextoRespuesta());
            System.out.println("ID opción: " + r.getIdOpcion());
            System.out.println("-----------------------------");
        }


        RequestDispatcher dispatcher = request.getRequestDispatcher("/formularioRespuesta.jsp");
        dispatcher.forward(request, response);
    }
}

