<%--
  Created by IntelliJ IDEA.
  User: Nilton
  Date: 14/05/2025
  Time: 12:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <title>Intranet - Formularios Asignados</title>
    <link rel="stylesheet" href="historialFormularios.css" />
</head>
<body>

<input class="menu-toggle" id="menu-toggle" type="checkbox"/>

<!-- Menú lateral -->
<div class="sidebar">
    <div class="sidebar-content">
        <div class="profile-section">
            <img alt="Foto de usuario" class="profile-pic" src="https://via.placeholder.com/100?text=User"/>
            <a class="profile-btn" href="VerPerfilServlet">Ver perfil</a>
        </div>
        <ul class="menu-links">
            <li><a href="FormulariosAsignadosServlet">FORMULARIOS ASIGNADOS</a></li>
            <li><a href="HistorialFormulariosServlet">HISTORIAL DE FORMULARIOS</a></li>
            <li><a href="LogoutServlet">CERRAR SESIÓN</a></li>
        </ul>
    </div>
</div>

<label class="overlay" for="menu-toggle"></label>

<!-- CABECERA -->
<header class="header-bar">
    <div class="header-content">
        <div class="header-left">
            <label class="menu-icon" for="menu-toggle"><span>☰</span></label>
            <div class="logo-section">
                <div class="logo-large">
                    <img alt="Logo Combinado" src="imagenes/logo.jpg"/>
                </div>
            </div>
        </div>
        <nav class="header-right">
            <div class="nav-item"><img alt="Inicio" class="nav-icon" src="imagenes/inicio.png"/><span>INICIO</span></div>
            <div class="nav-item"><img alt="Buscar" class="nav-icon" src="imagenes/buscar.png"/><span>BUSCAR</span></div>
            <div class="nav-item"><img alt="Encuestador" class="nav-icon" src="imagenes/usuario.png"/><span>ENCUESTADOR</span></div>
            <div class="nav-item"><img alt="Salir" class="nav-icon" src="imagenes/salir.png"/><span>SALIR</span></div>
        </nav>
    </div>
</header>

<!-- Contenido principal -->
<main class="main-content">

    <h2>Historial de Formularios</h2>

    <form method="get" action="HistorialFormulariosServlet" style="margin-bottom: 20px;">
        <label for="fechaFiltro">Filtrar por fecha:</label>
        <input type="date" id="fechaFiltro" name="fechaFiltro" value="${param.fechaFiltro}" />
        <button type="submit">Buscar</button>
    </form>

    <div class="contenedor-grid">
        <c:forEach var="sesion" items="${historialFormularios}">
            <section class="bloque-personalizado">
                <div style="background-color: #ffffff; border: 1px solid #333; padding: 10px; margin-bottom: 10px; border-radius: 10px;">
                    <h3 style="margin: 0;">Cuestionario ${sesion.idsesion}</h3>

                    <p style="margin: 5px 0;">
                        Última modificación:
                        <c:choose>
                            <c:when test="${not empty sesion.fechaenvio}">
                                ${sesion.fechaenvio}
                            </c:when>
                            <c:otherwise>
                                ${sesion.fechainicio} <!-- Usado como placeholder -->
                                <%-- En el futuro, reemplazar por la fecha de último guardado real --%>
                            </c:otherwise>
                        </c:choose>
                    </p>

                    <!-- Barra de progreso ficticia -->
                    <div style="background-color: #e0e0e0; height: 10px; border-radius: 5px; margin: 10px 0;">
                        <div style="width: 50%; background-color: #007bff; height: 100%; border-radius: 5px;"></div>
                    </div>

                    <!-- Mostrar botón Reingresar solo si el formulario está en borrador -->
                    <c:if test="${sesion.estadoTerminado == 0}">
                        <form action="ReingresarFormularioServlet" method="get">
                            <input type="hidden" name="idSesion" value="${sesion.idsesion}" />
                            <button type="submit" style="padding: 8px 16px; background-color: #28a745; color: white; border: none; border-radius: 4px;">
                                Reingresar
                            </button>
                        </form>
                    </c:if>
                </div>
            </section>
        </c:forEach>
    </div>

</main>
</body>
</html>

