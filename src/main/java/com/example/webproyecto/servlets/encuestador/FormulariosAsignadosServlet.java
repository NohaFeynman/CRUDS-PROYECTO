package com.example.webproyecto.servlets.encuestador;

import com.example.webproyecto.beans.AsignacionFormulario;
import com.example.webproyecto.daos.encuestador.AsignacionFormularioDao;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "FormulariosAsignadosServlet", value = "/FormulariosAsignadosServlet")
public class FormulariosAsignadosServlet extends HttpServlet {

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

        AsignacionFormularioDao dao = new AsignacionFormularioDao();
        List<AsignacionFormulario> formulariosAsignados = dao.obtenerFormulariosAsignados(idEncuestador);
        //System.out.println(formulariosAsignados.size());
        request.setAttribute("formulariosAsignados", formulariosAsignados);
        request.getRequestDispatcher("formulariosAsignados.jsp").forward(request, response);
    }
}
