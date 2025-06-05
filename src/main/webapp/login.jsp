<%--
  Created by IntelliJ IDEA.
  User: Nilton
  Date: 13/05/2025
  Time: 18:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Inicio de Sesión</title>
    <link rel="stylesheet" href="estilos/login.css?v=2">
</head>

<body>
<!------------------------------------------------------------------------------------------------------------------------------------->

<div class="main-container">

    <!-- Barra superior -->
    <header class="header-bar">
        <img src="imagenes/logo.jpg" alt="Logo superior">
    </header>

    <!-- Contenido principal -->
    <main class="content">

        <!-- Sección de imagen grande -->
        <section class="image-section">
            <img src="imagenes/portada.jpg" alt="Imagen principal">
        </section>

        <!-- Sección de login -->
        <section class="login-section">
            <h4>INICIO DE SESIÓN</h4>

            <!-- Mostrar mensaje de error si lo hay -->
            <%
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
            <p class="error-message"><%= error %></p>
            <%
                }
            %>

            <form action="LoginServlet" method="post">
                <input type="email" name="correo" placeholder="Correo" required>
                <input type="password" name="contrasenha" placeholder="Contraseña" required>

                <div class="forgot-password">
                    <a href="credencial_reinicioPassword.html">¡Olvidé mi contraseña!</a>
                </div>

                <button type="submit" class="login-btn">Ingresar</button>

                <div class="register-link">
                    <a href="${pageContext.request.contextPath}/registro">Registrarme</a>
                </div>
            </form>
        </section>

    </main>

    <!-- Pie de página -->
    <footer class="footer-bar">
        Defensora mundial de la igualdad de género
    </footer>

</div>
<div id="popup-exito" style="display:none; position:fixed; top:0; left:0; width:100vw; height:100vh; background:rgba(0,0,0,0.35); z-index:9999; align-items:center; justify-content:center;">
    <div style="background:#fff; padding:2rem 2.5rem; border-radius:10px; box-shadow:0 2px 10px rgba(0,0,0,0.2); text-align:center;">
        <h3 style="color:#28a745; margin-bottom:1rem;">¡Registro exitoso!</h3>
        <p>Se ha registrado exitosamente</p>
        <button onclick="document.getElementById('popup-exito').style.display='none'" style="margin-top:1.5rem; padding:0.5rem 1.5rem; background:#28a745; color:#fff; border:none; border-radius:5px; font-size:1rem; cursor:pointer;">Aceptar</button>
    </div>
</div>
<script>
    // Mostrar popup si el registro fue exitoso
    window.onload = function() {
        const params = new URLSearchParams(window.location.search);
        if (params.get('registro') === 'exito') {
            document.getElementById('popup-exito').style.display = 'flex';
        }
    }
</script>
</body>
</html>
