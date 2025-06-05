package com.example.webproyecto.servlets.encuestador;

import com.example.webproyecto.daos.encuestador.SesionRespuestaDao;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet(name = "HistorialFormulariosServlet", value = "/HistorialFormulariosServlet")
public class HistorialFormulariosServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("idUsuario") == null ||
                (int) session.getAttribute("rolId") != 3) {
            response.sendRedirect("login.jsp");
            return;
        }

        int idEncuestador = (int) session.getAttribute("idUsuario");
        SesionRespuestaDao dao = new SesionRespuestaDao();
        List<Map<String, Object>> historialCompleto = dao.obtenerSesionesPorEncuestador(idEncuestador);

        // Filtros por fecha
        String fechaInicioStr = request.getParameter("fechaFiltroInicio");
        String fechaFinStr = request.getParameter("fechaFiltroFin");

        List<Map<String, Object>> historialFiltrado = new ArrayList<>();

        for (Map<String, Object> sesion : historialCompleto) {
            boolean coincide = true;

            Timestamp fechaInicio = (Timestamp) sesion.get("fechainicio");
            Timestamp fechaEnvio = (Timestamp) sesion.get("fechaenvio");
            Timestamp fechaComparar = (fechaEnvio != null) ? fechaEnvio : fechaInicio;

            if (fechaInicioStr != null && !fechaInicioStr.isEmpty()) {
                Timestamp desde = Timestamp.valueOf(fechaInicioStr + " 00:00:00");
                if (fechaComparar.before(desde)) coincide = false;
            }

            if (fechaFinStr != null && !fechaFinStr.isEmpty()) {
                Timestamp hasta = Timestamp.valueOf(fechaFinStr + " 23:59:59");
                if (fechaComparar.after(hasta)) coincide = false;
            }

            if (coincide) historialFiltrado.add(sesion);
        }
        // Copia para numerar en orden cronológico
        List<Map<String, Object>> historialOrdenCronologico = new ArrayList<>(historialFiltrado);
        historialOrdenCronologico.sort((s1, s2) -> {
            Timestamp f1 = (Timestamp) s1.get("fechainicio");
            Timestamp f2 = (Timestamp) s2.get("fechainicio");
            return f1.compareTo(f2); // ASCENDENTE para numeración
        });

        // Asignar número por orden cronológico
        int numeroCuestionario = 1;
        for (Map<String, Object> sesionOrdenada : historialOrdenCronologico) {
            sesionOrdenada.put("numeroCuestionario", numeroCuestionario++);
        }

        // Ordenar por fecha descendente para mostrar en pantalla
        historialFiltrado.sort((s1, s2) -> {
            Timestamp f1 = (Timestamp) s1.get("fechainicio");
            Timestamp f2 = (Timestamp) s2.get("fechainicio");
            return f2.compareTo(f1); // DESCENDENTE
        });



        // Paginación
        String paginaParam = request.getParameter("pagina");
        int paginaActual = 1;
        if (paginaParam != null && paginaParam.matches("\\d+")) {
            paginaActual = Integer.parseInt(paginaParam);
        }

        int elementosPorPagina = 6;
        int totalElementos = historialFiltrado.size();
        int totalPaginas = (int) Math.ceil((double) totalElementos / elementosPorPagina);
        int inicio = (paginaActual - 1) * elementosPorPagina;
        int fin = Math.min(inicio + elementosPorPagina, totalElementos);

        List<Map<String, Object>> historialPaginado = historialFiltrado.subList(inicio, fin);

        // Envío a JSP
        request.setAttribute("historialFormulariosPaginado", historialPaginado);
        request.setAttribute("paginaActual", paginaActual);
        request.setAttribute("totalPaginas", totalPaginas);
        request.setAttribute("fechaFiltroInicio", fechaInicioStr);
        request.setAttribute("fechaFiltroFin", fechaFinStr);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/historialFormularios.jsp");
        dispatcher.forward(request, response);
    }
}
