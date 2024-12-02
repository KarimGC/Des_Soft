<?php 
session_start();
include "../class/Auth.php";

$email = $_POST['email'];
$password = $_POST['password'];

$Auth = new Auth();

if ($Auth->logear($email, $password)) {
    header("location:../menu_admin_2.php");
    exit(); // Asegurarse de que el script no continúe después de la redirección.
} else {
    echo "<!DOCTYPE html>
    <html lang='es'>
    <head>
        <meta charset='UTF-8'>
        <meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>
        <title>Error de Inicio de Sesión</title>
        <link href='https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css' rel='stylesheet'>
    </head>
    <body>
        <div class='container mt-5'>
            <div class='alert alert-danger' role='alert'>
                <h4 class='alert-heading'>¡Error de inicio de sesión!</h4>
                <p>No se pudo logear. Por favor, verifica tus credenciales.</p>
                <hr>
                <p class='mb-0'>Si tienes problemas, contacta con el administrador.</p>
            </div>
            <a href='../index.php' class='btn btn-primary btn-lg'>Volver a la página principal</a>
        </div>

        <script src='https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js'></script>
    </body>
    </html>";
}
?>
