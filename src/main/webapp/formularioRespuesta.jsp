<%--
  Created by IntelliJ IDEA.
  User: Nilton
  Date: 14/05/2025
  Time: 14:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <title>Responder Formulario</title>
    <link rel="stylesheet" href="formularioRespuesta.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Roboto&display=swap" rel="stylesheet" />
</head>
<body>
<input type="checkbox" id="menu-toggle" class="menu-toggle" />
<div class="sidebar">
    <div class="sidebar-content">
        <ul class="menu-links">
            <li><a href="FormulariosAsignadosServlet"><i class="icon-dashboard"></i> Ver formularios asignados</a></li>
            <li><a href="HistorialFormulariosServlet"><i class="icon-coordinators"></i> Ver historial de formulario</a></li>
            <li><a href="CerrarSesionServlet"><i class="icon-surveyors"></i> Cerrar sesión</a></li>
        </ul>
    </div>
</div>
<label for="menu-toggle" class="overlay"></label>
<header class="header-bar">
    <div class="header-content">
        <div class="header-left">
            <label for="menu-toggle" class="menu-icon">&#9776;</label>
            <div class="logo-section">
                <div class="logo-large">
                    <img src="${pageContext.request.contextPath}/imagenes/logo.jpg" alt="Logo Combinado" />
                </div>
            </div>
        </div>
        <nav class="header-right">
            <div class="nav-item dropdown" id="btn-encuestador" tabindex="0">
                <img src="${pageContext.request.contextPath}/imagenes/usuario.png" alt="Icono Usuario" class="nav-icon">
                <span>
                    <c:choose>
                        <c:when test="${not empty datosPerfil.usuario.nombre && not empty datosPerfil.usuario.apellidopaterno}">
                            ${fn:substring(datosPerfil.usuario.nombre, 0, 1)}. ${datosPerfil.usuario.apellidopaterno}
                        </c:when>
                        <c:otherwise>
                            ${sessionScope.nombre}
                        </c:otherwise>
                    </c:choose>
                </span>
                <div class="dropdown-menu">
                    <a href="VerPerfilServlet">Ver perfil</a>
                    <a href="CerrarSesionServlet">Cerrar sesión</a>
                </div>
            </div>
            <a href="InicioEncuestadorServlet" class="nav-item" id="btn-inicio">
                <img src="${pageContext.request.contextPath}/imagenes/inicio.png" alt="Icono de perfil" class="nav-icon" />
            </a>
        </nav>
    </div>
</header>
<main class="main-content">
    <h2>${titulo}</h2>

    <form action="GuardarRespuestasServlet" method="post" onsubmit="return confirmarEnvio(event);">
        <input type="hidden" name="accion" id="accion-hidden" value="" />
        <input type="hidden" name="idFormulario" value="${idFormulario}" />
        <input type="hidden" name="idEncuestador" value="${sessionScope.idUsuario}" />
        <input type="hidden" name="fechaEntrevista" value="<%= java.time.LocalDate.now().toString() %>" />
        <input type="hidden" name="idAsignacionFormulario" value="${idAsignacionFormulario}" />
        <c:if test="${modoReingreso}">
            <input type="hidden" name="idSesion" value="${idSesion}" />
        </c:if>

        <c:set var="seccionActual" value="" />
        <c:forEach var="pregunta" items="${preguntas}">
            <c:if test="${pregunta.seccion ne seccionActual}">
                <h3 style="margin-top: 40px; color: #007bff;">
                        ${pregunta.seccion}
                </h3>
                <c:set var="seccionActual" value="${pregunta.seccion}" />
            </c:if>

            <div style="margin-bottom: 30px; padding: 20px; border: 1px solid #ddd; border-radius: 8px; background-color: #f9f9f9;">
                <p><strong>${pregunta.orden}. ${pregunta.textoPregunta}</strong></p>

                <c:if test="${not empty pregunta.descripcion}">
                    <p style="font-style: italic; color: gray;">${pregunta.descripcion}</p>
                </c:if>

                <c:set var="respuestaAnterior" value="${respuestasAnteriores[pregunta.idPregunta]}" />

                <c:choose>
                    <c:when test="${pregunta.tipoPregunta == 0}">
                        <c:forEach var="opcion" items="${pregunta.opciones}">
                            <label style="display: block; margin: 5px 0;">
                                <input type="radio"
                                       name="respuesta_${pregunta.idPregunta}"
                                       value="${opcion.idOpcion}"
                                        <c:if test="${modoReingreso and respuestaAnterior != null and opcion.idOpcion == respuestaAnterior.idOpcion}">
                                            checked
                                        </c:if> />
                                    ${opcion.textoOpcion}
                            </label>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <textarea name="respuesta_${pregunta.idPregunta}" rows="3" style="width: 100%; padding: 8px;" placeholder="Escribe tu respuesta...">${modoReingreso and respuestaAnterior != null ? respuestaAnterior.textoRespuesta : ''}</textarea>
                    </c:otherwise>
                </c:choose>

                <input type="hidden" name="tipo_${pregunta.idPregunta}" value="${pregunta.tipoPregunta}" />
                <input type="hidden" name="obligatorio_${pregunta.idPregunta}" value="${pregunta.obligatorio}" />
            </div>
        </c:forEach>

        <div style="text-align: right; margin-top: 40px;">
            <button type="submit" name="accion" value="borrador"
                    style="padding: 10px 20px; background-color: #ffc107; color: white; border: none; border-radius: 4px; margin-right: 10px;">
                Guardar Borrador
            </button>
            <button type="submit" name="accion" value="terminar"
                    style="padding: 10px 20px; background-color: #28a745; color: white; border: none; border-radius: 4px;">
                Terminar y Enviar
            </button>
        </div>
    </form>

    <!-- POPUPS -->
    <div id="popup-vacio" class="popup-centrado" style="display:none;">
        <div class="popup-contenido">
            <h3 style="color:#dc3545;">¡Formulario vacío!</h3>
            <p>No se ha respondido a ninguna pregunta. Debes completar al menos una.</p>
            <button onclick="cerrarPopups()">Aceptar</button>
        </div>
    </div>

    <div id="popup-obligatorias" class="popup-centrado" style="display:none;">
        <div class="popup-contenido">
            <h3 style="color:#dc3545;">¡Faltan preguntas obligatorias!</h3>
            <p>Debes completar todas las preguntas obligatorias de las secciones B y C.</p>
            <button onclick="cerrarPopups()">Aceptar</button>
        </div>
    </div>

    <div id="popup-confirmar-borrador" class="popup-centrado" style="display:none;">
        <div class="popup-contenido">
            <h3 style="color:#ffc107;">¿Guardar como borrador?</h3>
            <p>¿Estás seguro de guardar este formulario como borrador?</p>
            <button onclick="enviarFormulario()">Sí</button>
            <button onclick="cerrarPopups()">Cancelar</button>
        </div>
    </div>

    <div id="popup-confirmar-envio" class="popup-centrado" style="display:none;">
        <div class="popup-contenido">
            <h3 style="color:#28a745;">¿Enviar formulario?</h3>
            <p>¿Estás seguro de terminar y enviar el formulario?</p>
            <button onclick="enviarFormulario()">Sí</button>
            <button onclick="cerrarPopups()">Cancelar</button>
        </div>
    </div>

    <style>
        .popup-centrado {
            position: fixed;
            top: 0; left: 0;
            width: 100vw; height: 100vh;
            background: rgba(0,0,0,0.35);
            z-index: 9999;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .popup-contenido {
            background: #fff;
            padding: 2rem 2.5rem;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.2);
            text-align: center;
        }

        .popup-contenido button {
            margin-top: 1.5rem;
            padding: 0.5rem 1.5rem;
            border: none;
            border-radius: 5px;
            font-size: 1rem;
            cursor: pointer;
        }

        .popup-contenido button:first-child {
            background: #007bff;
            color: white;
            margin-right: 1rem;
        }

        .popup-contenido button:last-child {
            background: #ccc;
        }
    </style>

    <script>
        let formGlobal = null;

        function confirmarEnvio(event) {
            event.preventDefault();
            const form = event.target;
            formGlobal = form;
            const accion = event.submitter?.value || '';
            document.getElementById('accion-hidden').value = accion;

            const elementos = form.elements;
            let respondidas = new Set();
            let obligatoriasNoRespondidas = [];

            for (let i = 0; i < elementos.length; i++) {
                const el = elementos[i];
                if (el.name.startsWith("respuesta_")) {
                    const id = el.name.split("_")[1];
                    if ((el.type === "radio" && el.checked) || (el.tagName === "TEXTAREA" && el.value.trim() !== "")) {
                        respondidas.add(id);
                    }
                }
            }

            if (respondidas.size === 0) {
                document.getElementById('popup-vacio').style.display = 'flex';
                return false;
            }

            if (accion === "borrador") {
                document.getElementById('popup-confirmar-borrador').style.display = 'flex';
                return false;
            }

            for (let i = 0; i < elementos.length; i++) {
                const el = elementos[i];
                if (el.name.startsWith("obligatorio_") && el.value === "1") {
                    const idPregunta = el.name.split("_")[1];
                    if (!respondidas.has(idPregunta)) {
                        obligatoriasNoRespondidas.push(idPregunta);
                    }
                }
            }

            if (obligatoriasNoRespondidas.length > 0) {
                document.getElementById('popup-obligatorias').style.display = 'flex';
                return false;
            }

            document.getElementById('popup-confirmar-envio').style.display = 'flex';
            return false;
        }

        function cerrarPopups() {
            document.querySelectorAll('[id^="popup-"]').forEach(p => p.style.display = 'none');
        }

        function enviarFormulario() {
            cerrarPopups();
            if (formGlobal) formGlobal.submit();
        }

        window.onload = function () {
            const params = new URLSearchParams(window.location.search);
            if (params.get("error") === "vacio") {
                document.getElementById("popup-vacio").style.display = "flex";
            } else if (params.get("error") === "obligatorias") {
                document.getElementById("popup-obligatorias").style.display = "flex";
            }
        }
    </script>
</main>


<script>
    // Mostrar/ocultar menú desplegable del botón Encuestador
    const btnEncuestador = document.getElementById('btn-encuestador');
    btnEncuestador.addEventListener('click', () => {
        btnEncuestador.classList.toggle('dropdown-active');
    });
    // Cerrar el dropdown si se hace click fuera
    document.addEventListener('click', (e) => {
        if (!btnEncuestador.contains(e.target)) {
            btnEncuestador.classList.remove('dropdown-active');
        }
    });
</script>
<style>
    /* RESET BÁSICO */
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }
    body {
        font-family: Arial, sans-serif;
        background-color: #ffffff;
        color: #333;
    }
    .menu-toggle {
        display: none;
    }
    .sidebar {
        position: fixed;
        top: 0;
        left: -280px;
        width: 280px;
        height: 100%;
        background-color: #e6f0ff;
        box-shadow: 4px 0 12px rgba(0, 0, 0, 0.2);
        transition: left 0.3s ease;
        z-index: 1000;
        overflow-y: auto;
        padding: 20px 0;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    .sidebar-content .menu-links {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .sidebar-content .menu-links li {
        margin-bottom: 15px;
    }

    .sidebar-content .menu-links a {
        display: flex;
        align-items: center;
        padding: 12px 20px;
        margin: 0 15px;
        border-radius: 8px;
        color: #1a1a1a;
        text-decoration: none;
        background-color: transparent;
        transition: all 0.3s ease;
        box-shadow: 0 0 0 transparent;
        font-size: 16px;
    }

    .sidebar-content .menu-links a i {
        margin-right: 10px;
        font-size: 18px;
    }

    .sidebar-content .menu-links a:hover {
        background-color: #b3ccff;
        transform: scale(1.05);
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        color: #003366;
    }
    .menu-toggle:checked ~ .sidebar {
        left: 0;
    }
    .overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0,0,0,0.5);
        opacity: 0;
        visibility: hidden;
        transition: opacity 0.3s ease;
        z-index: 900;
    }
    .menu-toggle:checked ~ .overlay {
        opacity: 1;
        visibility: visible;
    }
    .sidebar-content {
        display: flex;
        flex-direction: column;
        align-items: flex-start; /* texto alineado a la izquierda */
        padding: 1rem;
    }
    .menu-links {
        list-style: none;
        width: 100%;
        padding: 0;
        margin: 0;
        display: flex;
        flex-direction: column;
        gap: 1.5rem;
        align-items: flex-start; /* texto alineado a la izquierda */
    }
    .menu-links li a {
        display: flex;
        align-items: center;
        justify-content: flex-start; /* Alinea texto e íconos a la izquierda */
        width: 100%;
        text-decoration: none;
        color: #000;
        font-weight: bold;
        text-transform: uppercase;
        font-size: 0.95rem;
        transition: color 0.3s;
        padding-left: 10px; /* pequeño padding para que no quede pegado al borde */
    }
    .menu-links li a:hover {
        color: #007bff;
    }
    .menu-links li a i {
        margin-right: 0.8rem;
        font-size: 1.2rem;
    }
    /* Header más pequeño y ajustes */
    .header-bar {
        background-color: #dbeeff;
        height: 56.8px; /* altura reducida */
        display: flex;
        align-items: center;
        justify-content: center;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        position: relative;
        z-index: 800;
    }
    .header-content {
        width: 90%;
        max-width: 1200px;
        display: flex;
        align-items: center;
        justify-content: flex-start; /* contenido alineado a la izquierda */
        gap: 1rem; /* menor espacio entre íconos */
        transition: margin-left 0.3s ease;
    }
    /* Cuando el sidebar está abierto, desplaza el header-content */

    .header-left {
        display: flex;
        align-items: center;
        gap: 0.5rem; /* reducir espacio entre las 3 rayas y el logo */
        margin-left: 0; /* sin margen extra */
    }
    .menu-icon {
        font-size: 26px; /* ligeramente más grande para que sea visible */
        cursor: pointer;
        color: #333;
        display: inline-block;
        margin-left: 0; /* pegado a la izquierda */
    }
    .logo-section {
        display: flex;
        flex-direction: column;
        gap: 0.2rem;
        margin-left: 10px; /* separación del logo respecto a las rayas */
    }
    .logo-large img {
        height: 40px; /* más pequeño para que quede estético */
        object-fit: contain;
    }
    .header-right {
        display: flex;
        gap: 2.5rem; /* mayor separación entre iconos para estética */
        margin-left: auto; /* para empujar a la derecha */
    }
    /* Iconos de Inicio y Encuestador más pequeños */
    .nav-item {
        display: flex;
        align-items: center;
        gap: 6px;
        cursor: pointer;
        font-weight: bold;
        color: #333;
        text-transform: uppercase;
        font-size: 0.9rem;
        user-select: none;
        position: relative;
    }
    .nav-icon {
        width: 28px; /* más pequeño */
        height: 28px;
        object-fit: cover;
    }
    /* Texto debajo de inicio quitado */
    .nav-item#btn-inicio span {
        display: none;
    }
    /* Texto a la izquierda del ícono encuestador */
    .nav-item#btn-encuestador {
        flex-direction: row;
        justify-content: flex-start;
        gap: 8px;
        color: #007bff;
        font-weight: bold;
    }
    .nav-item#btn-encuestador span {
        display: inline-block;
    }
    /* Barra desplegable para botón Encuestador */
    .dropdown-menu {
        position: absolute;
        top: 36px;
        left: 0;
        background-color: white;
        border: 1px solid #ccc;
        border-radius: 6px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        padding: 0.5rem 0;
        width: 150px;
        display: none;
        z-index: 1001;
        flex-direction: column;
    }
    .dropdown-menu a {
        padding: 8px 16px;
        text-decoration: none;
        color: #007bff;
        font-weight: 600;
        font-size: 0.9rem;
        white-space: nowrap;
    }
    .dropdown-menu a:hover {
        background-color: #e6f0ff;
    }
    .nav-item.dropdown-active .dropdown-menu {
        display: flex;
    }

    /* ================== CONTENIDO PRINCIPAL ================== */
    .main-content {
        width: 90%;
        max-width: 1200px;
        margin: 1rem auto;
        min-height: calc(100vh - 70px - 40px); /* Resta header y footer */
    }

    /* Sección de tarjetas estadísticas */
    .admin-stats {
        display: flex;
        flex-direction: column;
        gap: 1rem;
        margin-bottom: 1.5rem;
    }

    .stat-item {
        background-color: #dbeeff;
        padding: 1rem;
        border-radius: 6px;
        font-weight: bold;
        box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .stat-title {
        font-size: 1rem;
    }

    .stat-value {
        font-size: 1rem;
        color: #333;
    }

    /* Sección de imagen grande */
    .admin-image {
        background-color: #f9f9f9;
        padding: 1rem;
        border-radius: 8px;
        box-shadow: 0 1px 3px rgba(0,0,0,0.1);
    }

    .large-image {
        display: block;
        width: 100%;
        height: auto;
        object-fit: cover;
        border-radius: 6px;
    }

    /* ================== PIE DE PÁGINA ================== */
    .footer-bar {
        height: 40px;
        background-color: #fff;
        border-top: 1px solid #ccc;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
        margin-top: 1rem;
    }

    /* ================== RESPONSIVIDAD ================== */
    @media (max-width: 768px) {
        .header-content {
            flex-direction: column;
            height: auto;
            padding: 0.5rem 1rem;
            gap: 1rem;
            justify-content: center;
        }

        .header-left,
        .header-right {
            width: 100%;
            display: flex;
            justify-content: center;
        }

        .header-right {
            flex-wrap: wrap;
            gap: 1rem;
            margin-top: 0.5rem;
        }

        .nav-icon {
            width: 30px;
            height: 30px;
        }

        .admin-stats {
            flex-direction: column;
            gap: 1rem;
        }
    }

    .main-content {
        width: 90%;
        max-width: 1200px;
        margin: 1rem auto;
        min-height: calc(100vh - 70px - 40px); /* Considera header y footer */
    }

    /* Sección Encuestas Recientes y Historial */
    .section-encuestas,
    .section-historial {
        background-color: #f9f9f9;
        padding: 1rem;
        border-radius: 8px;
        box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        margin-bottom: 1.5rem;
    }

    .section-encuestas h2,
    .section-historial h2 {
        font-size: 1rem;
        margin-bottom: 0.5rem;
        font-weight: bold;
    }

    /* Tarjetas de Encuestas Recientes */
    .tablaresumen-container {
        display: flex;
        flex-direction: column;
        gap: 1rem;
    }

    .secciones-item {
        background-color: #ffffff;
        border: 0.5px solid #ddd;
        border-radius: 6px;
        padding: 0.5rem;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .secciones-info {
        display: flex;
        flex-direction: column;
    }
    .secciones-titulo {
        font-weight: bold
    }
    .secciones-fecha {
        font-size: 0.9rem;
        color: #666;
    }

    .seccion-respuesta {
        padding: 0.5rem 1rem;
        background-color: #5e81ac;
        color: #fff;
        border: none;
        border-radius: 4px;
        font-weight: bold;
    }

    /* Botón Crear Respuesta */
    .btn-respuesta {
        padding: 0.5rem 1rem;
        background-color: #5e81ac;
        color: #fff;
        border: none;
        border-radius: 4px;
        font-weight: bold;
    }

    .btn-respuesta:hover {
        background-color: #4c669f;
    }

    /* Tarjetas de Historial de Formularios */
    .estadisticas-container {
        display: flex;
        flex-direction: column;
        gap: 1rem;
    }

    /* Paginación */
    .paginacion {
        margin-top: 1rem;
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 0.5rem;
    }

    .pag-arrow {
        background: none;
        border: none;
        font-size: 1.2rem;
        cursor: pointer;
        color: #5e81ac;
        transition: color 0.3s;
    }

    .pag-arrow:hover {
        color: #4c669f;
    }

    .pag-num {
        padding: 0.3rem 0.6rem;
        background-color: #fff;
        border: 1px solid #ccc;
        border-radius: 4px;
        cursor: pointer;
        font-size: 0.9rem;
        transition: background-color 0.3s;
    }

    .pag-num:hover {
        background-color: #eee;
    }

    /* ================== PIE DE PÁGINA ================== */
    /* .footer-bar {
      height: 40px;
      background-color: #ffffff;
      border-top: 1px solid #ccc;
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: bold;
      margin-top: 1rem;
    } */

    /* ================== RESPONSIVIDAD ================== */
    @media (max-width: 768px) {
        .header-content {
            flex-direction: column;
            height: auto;
            padding: 0.5rem 1rem;
            gap: 1rem;
            justify-content: center;
        }

        .header-left,
        .header-right {
            width: 100%;
            display: flex;
            justify-content: center;
        }

        .header-right {
            flex-wrap: wrap;
            gap: 1rem;
            margin-top: 0.5rem;
        }

        .nav-icon {
            width: 30px;
            height: 30px;
        }
    }

    /* ================== GRAFICOS ================== */
    body{
        background-color: #f4f7ff;
    }
    .board{
        margin: auto;
        width: 55%;
        height: 450px;
        background-color: #e2e2e2;
        padding: 10px;
        box-sizing: border-box;
        overflow: hidden;
    }
    .titulo_grafica{
        width: 100%;
        height: 10%;
    }
    .titulo_grafica>h3{
        padding: 0;
        margin: 0px;
        text-align: center;
        color: #666666;
    }
    .sub_board{
        width: 100%;
        height: 90%;
        padding: 10px;
        margin-top: 0px;
        background-color:#f4f4f4;
        overflow: hidden;
        box-sizing: border-box;
    }
    .sep_board{
        width: 100%;
        height: 10%;
    }
    .cont_board{
        width: 100%;
        height: 80%;
    }
    .graf_board{
        width: 85%;
        height: 100%;
        float: right;
        margin-top: 0px;
        background-color: darkgrey;
        border-left: 2px solid #999999;
        border-bottom: 2px solid #999999;
        box-sizing: border-box;
        display: flex;
        background: -moz-linear-gradient(top, rgba(0,0,0,0) 0%,
        rgba(0,0,0,0) 9.5%,  rgba(0,0,0,0.3) 10%, rgba(0,0,0,0) 10.5%,
        rgba(0,0,0,0) 19.5%, rgba(0,0,0,0.3) 20%, rgba(0,0,0,0) 20.5%,
        rgba(0,0,0,0) 29.5%, rgba(0,0,0,0.3) 30%, rgba(0,0,0,0) 30.5%,
        rgba(0,0,0,0) 39.5%, rgba(0,0,0,0.3) 40%, rgba(0,0,0,0) 40.5%,
        rgba(0,0,0,0) 49.5%, rgba(0,0,0,0.3) 50%, rgba(0,0,0,0) 50.5%,
        rgba(0,0,0,0) 59.5%, rgba(0,0,0,0.3) 60%, rgba(0,0,0,0) 60.5%,
        rgba(0,0,0,0) 69.5%, rgba(0,0,0,0.3) 70%, rgba(0,0,0,0) 70.5%,
        rgba(0,0,0,0) 79.5%, rgba(0,0,0,0.3) 80%, rgba(0,0,0,0) 80.5%,
        rgba(0,0,0,0) 89.5%, rgba(0,0,0,0.3) 90%, rgba(0,0,0,0) 90.5%,
        rgba(0,0,0,0) 100%);

        background: -webkit-linear-gradient(top, rgba(0,0,0,0) 0%,
        rgba(0,0,0,0) 9.5%,  rgba(0,0,0,0.3) 10%, rgba(0,0,0,0) 10.5%,
        rgba(0,0,0,0) 19.5%, rgba(0,0,0,0.3) 20%, rgba(0,0,0,0) 20.5%,
        rgba(0,0,0,0) 29.5%, rgba(0,0,0,0.3) 30%, rgba(0,0,0,0) 30.5%,
        rgba(0,0,0,0) 39.5%, rgba(0,0,0,0.3) 40%, rgba(0,0,0,0) 40.5%,
        rgba(0,0,0,0) 49.5%, rgba(0,0,0,0.3) 50%, rgba(0,0,0,0) 50.5%,
        rgba(0,0,0,0) 59.5%, rgba(0,0,0,0.3) 60%, rgba(0,0,0,0) 60.5%,
        rgba(0,0,0,0) 69.5%, rgba(0,0,0,0.3) 70%, rgba(0,0,0,0) 70.5%,
        rgba(0,0,0,0) 79.5%, rgba(0,0,0,0.3) 80%, rgba(0,0,0,0) 80.5%,
        rgba(0,0,0,0) 89.5%, rgba(0,0,0,0.3) 90%, rgba(0,0,0,0) 90.5%,
        rgba(0,0,0,0) 100%);

        background: linear-gradient(to bottom, rgba(0,0,0,0) 0%,
        rgba(0,0,0,0) 9.5%,  rgba(0,0,0,0.3) 10%, rgba(0,0,0,0) 10.5%,
        rgba(0,0,0,0) 19.5%, rgba(0,0,0,0.3) 20%, rgba(0,0,0,0) 20.5%,
        rgba(0,0,0,0) 29.5%, rgba(0,0,0,0.3) 30%, rgba(0,0,0,0) 30.5%,
        rgba(0,0,0,0) 39.5%, rgba(0,0,0,0.3) 40%, rgba(0,0,0,0) 40.5%,
        rgba(0,0,0,0) 49.5%, rgba(0,0,0,0.3) 50%, rgba(0,0,0,0) 50.5%,
        rgba(0,0,0,0) 59.5%, rgba(0,0,0,0.3) 60%, rgba(0,0,0,0) 60.5%,
        rgba(0,0,0,0) 69.5%, rgba(0,0,0,0.3) 70%, rgba(0,0,0,0) 70.5%,
        rgba(0,0,0,0) 79.5%, rgba(0,0,0,0.3) 80%, rgba(0,0,0,0) 80.5%,
        rgba(0,0,0,0) 89.5%, rgba(0,0,0,0.3) 90%, rgba(0,0,0,0) 90.5%,
        rgba(0,0,0,0) 100%);

        filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#00ffffff', endColorstr='#00ffffff',GradientType=0 );
    }
    .barra{
        width:100%;
        height: 100%;
        margin-right: 15px;
        margin-left: 15px;
        background-color: none;
        display: flex;
        flex-wrap: wrap;
        align-items: flex-end;
    }
    .sub_barra{
        width: 100%;
        height: 80%;
        background: #00799b;
        background: -moz-linear-gradient(top, #00799b 0%, #64d1be 100%);
        background: -webkit-linear-gradient(top, #00799b 0%,#64d1be 100%);
        background: linear-gradient(to bottom, #00799b 0%,#64d1be 100%);
        filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#00799b', endColorstr='#64d1be',GradientType=0 );

        -webkit-border-radius: 3px 3px 0 0;
        border-radius: 3px 3px 0 0;
    }
    .tag_g{
        position: relative;
        width: 100%;
        height: 100%;
        margin-bottom: 30px;
        text-align: center;
        margin-top: -20px;
        z-index: 2;
    }
    .tag_leyenda{
        width: 100%;
        text-align: center;
        margin-top: 5px;
    }
    .tag_board{
        height: 100%;
        width: 15%;
        border-bottom: 2px solid rgba(0,0,0,0);
        box-sizing: border-box;
    }
    .sub_tag_board{
        height: 100%;
        width: 100%;
        display: flex;
        align-items: flex-end;
        flex-wrap: wrap;
    }
    .sub_tag_board>div{
        width: 100%;
        height: 10%;
        text-align: right;
        padding-right: 10px;
        box-sizing: border-box;
    }
    .b1{ height: 35%}
    .b2{ height: 45%}
    .b3{ height: 55%}
    .b4{ height: 75%}
    .b5{ height: 85%}
    footer{
        position: absolute;
        bottom: 0px;
        width: 100%;
        text-align: center;
        font-size: 12px;
        font-family: sans-serif;
    }

    /* === ESTILOS AÑADIDOS PARA ENCUESTADOR === */
    .encuestas-container {
        display: flex;
        flex-direction: column;
        gap: 1rem;
    }

    .encuesta-item {
        background-color: #ffffff;
        border: 1px solid #ddd;
        border-radius: 6px;
        padding: 1rem;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .encuesta-info {
        display: flex;
        flex-direction: column;
    }

    .encuesta-titulo {
        font-weight: bold;
    }

    .encuesta-fecha {
        font-size: 0.9rem;
        color: #666;
    }

    .historial-container {
        display: flex;
        flex-direction: column;
        gap: 1rem;
    }

    .formulario-item {
        background-color: #ffffff;
        border: 1px solid #ddd;
        border-radius: 6px;
        padding: 1rem;
        display: grid;
        grid-template-columns: 1fr auto;
        grid-template-rows: auto auto;
        gap: 0.5rem;
        align-items: center;
    }

    .formulario-info {
        grid-column: 1 / 2;
        grid-row: 1 / 2;
    }

    .formulario-titulo {
        font-weight: bold;
    }

    .formulario-fecha {
        font-size: 0.9rem;
        color: #666;
    }

    .barra-progreso {
        grid-column: 1 / 2;
        grid-row: 2 / 3;
        width: 80%;
        height: 8px;
        background-color: #e4e4e4;
        border-radius: 4px;
        overflow: hidden;
        margin-top: 0.3rem;
    }

    .barra-llenado {
        width: 30%;
        height: 100%;
        background-color: #5e81ac;
        border-radius: 4px 0 0 4px;
    }

    .btn-reingresar {
        text-decoration: none;
        display: inline-block;
        grid-column: 2 / 3;
        grid-row: 1 / 3;
        align-self: center;
        padding: 0.5rem 1rem;
        background-color: #5e81ac;
        color: #fff;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-weight: bold;
        font-size: 13.3px;
        transition: background-color 0.3s;
    }

    .btn-respuesta {
        text-decoration: none;
        display: inline-block;
        padding: 0.5rem 1rem;
        background-color: #5e81ac;
        color: #fff;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-weight: bold;
        transition: background-color 0.3s;
        font-size: 13.3px;
    }




</style>
</body>
</html>
