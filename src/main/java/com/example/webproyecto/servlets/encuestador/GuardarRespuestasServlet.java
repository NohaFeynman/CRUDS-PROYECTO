package com.example.webproyecto.servlets.encuestador;

import com.example.webproyecto.beans.Respuesta;
import com.example.webproyecto.beans.SesionRespuesta;
import com.example.webproyecto.beans.Pregunta;
import com.example.webproyecto.daos.encuestador.RespuestaDao;
import com.example.webproyecto.daos.encuestador.SesionRespuestaDao;
import com.example.webproyecto.daos.encuestador.PreguntaDao;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.*;

@WebServlet(name = "GuardarRespuestasServlet", value = "/GuardarRespuestasServlet")
public class GuardarRespuestasServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("idUsuario") == null ||
                (int) session.getAttribute("idrol") != 3) {
            response.sendRedirect("login.jsp");
            return;
        }

        int idEncuestador = (int) session.getAttribute("idUsuario");
        int idAsignacionFormulario = Integer.parseInt(request.getParameter("idAsignacionFormulario"));
        int idFormulario = Integer.parseInt(request.getParameter("idFormulario"));
        String accion = request.getParameter("accion");
        int estadoTerminado = accion.equals("terminar") ? 1 : 0;
        String idEncuestado = request.getParameter("idEncuestado");

        String idSesionParam = request.getParameter("idSesion");
        boolean esReingreso = idSesionParam != null && !idSesionParam.trim().isEmpty();
        int idSesion;

        SesionRespuestaDao sesionDao = new SesionRespuestaDao();

        if (esReingreso) {
            idSesion = Integer.parseInt(idSesionParam);
            Timestamp fechaEnvio = (estadoTerminado == 1) ? Timestamp.valueOf(LocalDateTime.now()) : null;
            sesionDao.actualizarEstadoYFechaEnvio(idSesion, estadoTerminado, fechaEnvio);

            // Obtener idEncuestador real por la sesión
            int idEncuestadorReal = sesionDao.obtenerIdEncuestadorPorSesion(idSesion);
            int anio = LocalDateTime.now().getYear();
            int cantidadPrevias = sesionDao.contarSesionesPorEncuestadorYAño(idEncuestadorReal, anio);
            int numeroSesion = anio * 1000 + cantidadPrevias;
            sesionDao.actualizarNumeroSesion(idSesion, numeroSesion);

            RespuestaDao respuestaDao = new RespuestaDao();
            respuestaDao.eliminarRespuestasPorSesion(idSesion);
        } else {
            SesionRespuesta sesionNueva = new SesionRespuesta();
            sesionNueva.setFechaInicio(LocalDateTime.now());
            sesionNueva.setEstadoTerminado(estadoTerminado);
            sesionNueva.setIdAsignacionFormulario(idAsignacionFormulario);
            sesionNueva.setIdEncuestado(idEncuestado != null ? idEncuestado : null);
            if (estadoTerminado == 1) {
                sesionNueva.setFechaEnvio(LocalDateTime.now());
            }

            idSesion = sesionDao.crearSesionRespuesta(sesionNueva);
            if (idSesion <= 0) {
                response.sendRedirect("error.jsp");
                return;
            }

            // Asignar número de sesión único
            int anio = LocalDateTime.now().getYear();
            int cantidadPrevias = sesionDao.contarSesionesPorEncuestadorYAño(idEncuestador, anio);
            int numeroSesion = anio * 1000 + cantidadPrevias;
            sesionDao.actualizarNumeroSesion(idSesion, numeroSesion);
        }

        // Recolectar respuestas ingresadas
        List<Respuesta> listaRespuestas = new ArrayList<>();
        Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String param = paramNames.nextElement();
            if (param.startsWith("respuesta_")) {
                int idPregunta = Integer.parseInt(param.substring(10));
                String valor = request.getParameter(param);
                String tipoStr = request.getParameter("tipo_" + idPregunta);
                int tipoPregunta = tipoStr != null ? Integer.parseInt(tipoStr) : 1;

                if (valor != null && !valor.trim().isEmpty()) {
                    Respuesta r = new Respuesta();
                    r.setIdSesion(idSesion);
                    r.setIdPregunta(idPregunta);

                    if (tipoPregunta == 0) {
                        r.setIdOpcion(Integer.parseInt(valor));
                    } else {
                        r.setTextoRespuesta(valor);
                    }

                    listaRespuestas.add(r);
                }
            }
        }

        // Validar: al menos una pregunta respondida
        if (listaRespuestas.isEmpty()) {
            response.sendRedirect("formularioRespuesta.jsp?error=vacio");
            return;
        }

        // Validar preguntas obligatorias solo si se va a terminar y enviar
        if (estadoTerminado == 1) {
            PreguntaDao preguntaDao = new PreguntaDao();
            List<Pregunta> todas = preguntaDao.obtenerPreguntasPorFormulario(idFormulario);

            int ordenMaxSeccionC = todas.stream()
                    .filter(p -> "C".equalsIgnoreCase(p.getSeccion()))
                    .mapToInt(Pregunta::getOrden).max().orElse(-1);

            for (Pregunta p : todas) {
                if (p.getObligatorio() == 1) {
                    // Ignorar la última de la sección C
                    if ("C".equalsIgnoreCase(p.getSeccion()) && p.getOrden() == ordenMaxSeccionC) {
                        continue;
                    }

                    boolean respondida = listaRespuestas.stream()
                            .anyMatch(r -> r.getIdPregunta() == p.getIdPregunta());

                    if (!respondida) {
                        response.sendRedirect("formularioRespuesta.jsp?error=obligatorias");
                        return;
                    }
                }
            }
        }

        // Guardar respuestas
        RespuestaDao respuestaDao = new RespuestaDao();
        respuestaDao.guardarRespuestas(listaRespuestas);

        // Redirigir al historial
        response.sendRedirect("HistorialFormulariosServlet");
    }
}
