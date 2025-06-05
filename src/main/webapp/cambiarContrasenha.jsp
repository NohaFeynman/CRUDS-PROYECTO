<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Intranet - Cambiar Contraseña</title>
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
    /* ================== MENÚ LATERAL (Sidebar) ================== */
    /* Oculta el checkbox */
    .menu-toggle {
      display: none;
    }

    /* Sidebar: se ensancha a 280px para mayor espacio */
    .sidebar {
      position: fixed;
      top: 0;
      left: -280px; /* Ancho del menú: 280px */
      width: 280px;
      height: 100%;
      background-color: #c9ddff; /* Fondo celeste claro */
      box-shadow: 2px 0 8px rgba(0,0,0,0.3);
      transition: left 0.3s ease;
      z-index: 1000;
      overflow-y: auto;
    }

    .menu-toggle:checked ~ .sidebar {
      left: 0;
    }

    /* Overlay: oscurece el fondo cuando el menú está abierto */
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

    /* Contenido del Sidebar */
    .sidebar-content {
      display: flex;
      flex-direction: column;
      align-items: center;
      padding: 1rem;
    }

    /* Sección de perfil: fondo blanco, mayor tamaño */
    .profile-section {
      background-color: #fff;
      width: 90%;
      padding: 1.2rem;
      border-radius: 8px;
      text-align: center;
      margin-bottom: 2rem;
    }

    .profile-pic {
      width: 100px;
      height: 100px;
      border-radius: 50%;
      margin-bottom: 0.8rem;
      object-fit: cover;
      background-color: #ccc;
    }

    .profile-btn {
      background-color: #007bff;
      color: #fff;
      border: none;
      border-radius: 4px;
      padding: 0.6rem 1.2rem;
      cursor: pointer;
      font-weight: bold;
      font-size: 0.9rem;
      margin-bottom: 1rem;
    }

    .logout-btn {
      background-color: #dc3545;
      color: #fff;
      border: none;
      border-radius: 4px;
      padding: 0.6rem 1.2rem;
      cursor: pointer;
      font-weight: bold;
      font-size: 0.9rem;
      width: 100%;
    }

    .profile-btn:hover {
      background-color: #0056b3;
    }

    .logout-btn:hover {
      background-color: #c82333;
    }

    /* Lista de enlaces del Sidebar */
    .menu-links {
      list-style: none;
      width: 100%;
      padding: 0;
      margin: 0;
      display: flex;
      flex-direction: column;
      gap: 1.5rem;
      align-items: center;
    }

    .menu-links li a {
      display: flex;
      align-items: center;
      justify-content: center;
      width: 100%;
      text-decoration: none;
      color: #000;
      font-weight: bold;
      text-transform: uppercase;
      font-size: 0.95rem;
      transition: color 0.3s;
    }

    .menu-links li a:hover {
      color: #007bff;
    }

    .menu-links li a i {
      margin-right: 0.8rem;
      font-size: 1.2rem;
    }

    /* ================== CABECERA (Header) ================== */
    .header-bar {
      background-color: #dbeeff;
      height: 56.8px;
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
      justify-content: flex-start;
      gap: 1rem;
      transition: margin-left 0.3s ease;
    }

    .header-left {
      display: flex;
      align-items: center;
      gap: 0.5rem;
      margin-left: 0;
    }

    .menu-icon {
      font-size: 26px;
      cursor: pointer;
      color: #333;
      display: inline-block;
      margin-left: 0;
    }

    .logo-section {
      display: flex;
      flex-direction: column;
      gap: 0.2rem;
      margin-left: 10px;
    }

    .logo-large img {
      height: 40px;
      object-fit: contain;
    }

    .header-right {
      display: flex;
      gap: 2.5rem;
      margin-left: auto;
    }

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
      width: 28px;
      height: 28px;
      object-fit: cover;
    }

    .nav-item#btn-inicio span {
      display: none;
    }

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
      margin: 2rem auto;
      padding-bottom: 2rem;
      text-align: center;
    }

    .main-content h2 {
      margin-bottom: 2rem;
      font-size: 1.5rem;
      font-weight: bold;
      color: #007bff;
    }

    /* ================== INTERFAZ "CAMBIAR CONTRASEÑA" ================== */
    .profile-container {
      background-color: #f5f5f5;
      margin: 0 auto;
      max-width: 800px;
      padding: 2rem;
      border-radius: 8px;
      box-shadow: 0 1px 3px rgba(0,0,0,0.1);
      text-align: left;
    }

    .profile-header {
      display: flex;
      align-items: center;
      gap: 1.5rem;
      margin-bottom: 1.5rem;
    }

    .profile-photo {
      position: relative;
    }

    .profile-photo img {
      width: 150px;
      height: 150px;
      border-radius: 50%;
      object-fit: cover;
      background-color: #ccc;
    }

    .profile-info h3 {
      margin-bottom: 0.5rem;
      font-size: 1.8rem;
      color: #007bff;
    }

    .profile-info p {
      margin: 0.3rem 0;
      font-size: 1rem;
    }

    .profile-details {
      margin-top: 2rem;
    }

    .profile-row {
      display: flex;
      margin-bottom: 1rem;
      padding-bottom: 1rem;
      border-bottom: 1px solid #e0e0e0;
    }

    .profile-label {
      flex: 0 0 200px;
      font-weight: bold;
      color: #555;
    }

    .profile-value {
      flex: 1;
    }

    .profile-value input {
      width: 100%;
      padding: 0.5rem;
      border: 1px solid #ddd;
      border-radius: 4px;
    }

    .profile-actions {
      display: flex;
      justify-content: flex-end;
      gap: 1rem;
      margin-top: 2rem;
    }

    .btn-back, .btn-confirm {
      padding: 0.8rem 1.5rem;
      font-size: 1rem;
      border-radius: 4px;
      cursor: pointer;
      transition: background-color 0.3s;
      border: none;
    }

    .btn-back {
      background-color: #dc3545;
      color: #fff;
    }

    .btn-back:hover {
      background-color: #c82333;
    }

    .btn-confirm {
      background-color: #007bff;
      color: #fff;
    }

    .btn-confirm:hover {
      background-color: #0056b3;
    }

    /* ================== RESPONSIVIDAD ================== */
    @media (max-width: 768px) {
      .header-content {
        flex-direction: column;
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

      .profile-header {
        flex-direction: column;
        align-items: center;
        gap: 1rem;
      }

      .profile-info h3 {
        font-size: 1.5rem;
        text-align: center;
      }

      .profile-row {
        flex-direction: column;
      }

      .profile-label {
        margin-bottom: 0.5rem;
      }

      .profile-actions {
        flex-direction: column;
      }

      .btn-back, .btn-confirm {
        width: 100%;
      }
    }
  </style>
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
      <!-- Encuestador ahora está antes que Inicio -->
      <div class="nav-item dropdown" id="btn-encuestador" tabindex="0">
        <div class="nav-item">
          <img src="${pageContext.request.contextPath}/imagenes/usuario.png" alt="Icono Usuario" class="nav-icon">
          <span>${sessionScope.nombre} </span>
        </div>
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

<!-- CONTENIDO PRINCIPAL: Interfaz de Cambiar Contraseña -->
<main class="main-content">
  <h2>Cambiar Contraseña</h2>
  <div class="profile-container">
    <div class="profile-header">
      <div class="profile-photo">
        <c:choose>
          <c:when test="${not empty datosPerfil.usuario.foto}">
            <img src="data:image/jpeg;base64,${datosPerfil.usuario.foto}" alt="Foto de usuario" style="width:150px;height:150px;border-radius:50%;object-fit:cover;background-color:#ccc;" onerror="this.src='https://via.placeholder.com/150?text=Foto'">
          </c:when>
          <c:otherwise>
            <img src="https://via.placeholder.com/150?text=Foto" alt="Foto de usuario" style="width:150px;height:150px;border-radius:50%;object-fit:cover;background-color:#ccc;">
          </c:otherwise>
        </c:choose>
      </div>
      <div class="profile-info">
        <h3>${nombreCompleto}</h3>
        <p><strong>Rol:</strong> ${datosPerfil.nombreRol}</p>
        <p><strong>Último acceso:</strong>
          <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date()) %>
        </p>
      </div>
    </div>

    <form action="CambiarContrasenhaServlet" method="post">
      <!-- Mostrar mensajes de error/éxito solo si vienen del servlet -->

      <c:if test="${not empty requestScope.error}">
        <div class="alert alert-danger">${requestScope.error}</div>
      </c:if>


      <div class="profile-details">
        <div class="profile-row">
          <div class="profile-label">Contraseña actual:</div>
          <div class="profile-value">
            <input type="password" name="contrasenhaActual" placeholder="Ingrese su contraseña actual" required>
          </div>
        </div>
        <div class="profile-row">
          <div class="profile-label">Nueva contraseña:</div>
          <div class="profile-value">
            <input type="password" name="nuevaContrasenha" placeholder="Ingrese su nueva contraseña" required>
          </div>
        </div>
        <div class="profile-row">
          <div class="profile-label">Confirmar contraseña:</div>
          <div class="profile-value">
            <input type="password" name="confirmarContrasenha" placeholder="Confirme su nueva contraseña" required>
          </div>
        </div>
      </div>

      <div class="profile-actions">
        <button type="button" class="btn-back" onclick="window.location.href='VerPerfilServlet'">Cancelar</button>
        <button type="submit" class="btn-confirm">Cambiar Contraseña</button>
      </div>
    </form>
  </div>
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

<div id="popup-exito" style="display:none; position:fixed; top:0; left:0; width:100vw; height:100vh; background:rgba(0,0,0,0.35); z-index:9999; align-items:center; justify-content:center;">
  <div style="background:#fff; padding:2rem 2.5rem; border-radius:10px; box-shadow:0 2px 10px rgba(0,0,0,0.2); text-align:center;">
    <h3 style="color:#28a745; margin-bottom:1rem;">¡Contraseña cambiada!</h3>
    <p>Su contraseña se ha cambiado exitosamente</p>
  </div>
</div>
<script>
  // Validación y popup al cambiar contraseña
  document.querySelector('.btn-confirm').addEventListener('click', function(e) {
    e.preventDefault();
    var form = this.closest('form');
    var nueva = form.querySelector('input[name="nuevaContrasenha"]').value;
    var confirmar = form.querySelector('input[name="confirmarContrasenha"]').value;

    // Validación de longitud mínima
    if (nueva.length < 8) {
      mostrarAlerta('La nueva contraseña debe tener al menos 8 caracteres.', 'danger');
      return;
    }
    // Validación de coincidencia
    if (nueva !== confirmar) {
      mostrarAlerta('Las contraseñas no coinciden.', 'danger');
      return;
    }

    // Si pasa la validación, mostrar popup de éxito y enviar
    var popup = document.getElementById('popup-exito');
    popup.style.display = 'flex';
    setTimeout(function() {
      popup.style.display = 'none';
      form.submit();
    }, 1500);
  });

  // Función para mostrar alertas de error
  function mostrarAlerta(mensaje, tipo) {
    // Elimina alertas previas
    var prev = document.getElementById('alerta-popup');
    if (prev) prev.remove();
    // Crea alerta
    var alerta = document.createElement('div');
    alerta.id = 'alerta-popup';
    alerta.className = 'alert alert-' + tipo;
    alerta.style.position = 'fixed';
    alerta.style.top = '30px';
    alerta.style.left = '50%';
    alerta.style.transform = 'translateX(-50%)';
    alerta.style.zIndex = '2001';
    alerta.style.minWidth = '250px';
    alerta.style.textAlign = 'center';
    alerta.innerText = mensaje;
    document.body.appendChild(alerta);
    setTimeout(function() {
      alerta.remove();
    }, 2000);
  }
</script>



<!-- Agregar estilos para mensajes de alerta -->
<style>
  .alert {
    padding: 1rem;
    margin-bottom: 1.5rem;
    border-radius: 4px;
  }
  .alert-danger {
    background-color: #f8d7da;
    color: #721c24;
    border: 1px solid #f5c6cb;
  }
  .alert-success {
    background-color: #d4edda;
    color: #155724;
    border: 1px solid #c3e6cb;
  }
</style>
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
    background-color: #c9ddff;
    box-shadow: 2px 0 8px rgba(0,0,0,0.3);
    transition: left 0.3s ease;
    z-index: 1000;
    overflow-y: auto;
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