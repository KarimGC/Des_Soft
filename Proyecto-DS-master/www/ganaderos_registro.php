<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.18.0/font/bootstrap-icons.css">
    
    <title>Ganaderos</title>
</head>

<body>

<?php
include("class/Conexion.php"); // Ruta a la conexión
include("includes/header.php"); // Ruta al encabezado
?>

<div class="container mt-5">
    <h3>Agregar Ganadero</h3><br>
    <form method="post" action="">
        <div class="form-group">
            <label for="razonSocial">Razón Social:</label>
            <input type="text" class="form-control" id="razonSocial" name="razonSocial" required>
        </div>
        <div class="form-group">
            <label for="nombre">Nombre:</label>
            <input type="text" class="form-control" id="nombre" name="nombre" required>
        </div>
        <div class="form-group">
            <label for="psg">PSG:</label>
            <input type="text" class="form-control" id="psg" name="psg" required>
        </div>
        <div class="form-group">
            <label for="domicilio">Domicilio:</label>
            <input type="text" class="form-control" id="domicilio" name="domicilio" required>
        </div>
        <div class="form-group">
            <label for="codigoPostal">Código Postal:</label>
            <input type="text" class="form-control" id="codigoPostal" name="codigoPostal" required>
        </div>
        <div class="form-group">
            <label for="municipio">Municipio:</label>
            <input type="text" class="form-control" id="municipio" name="municipio" required>
        </div>
        <div class="form-group">
            <label for="estado">Estado:</label>
            <input type="text" class="form-control" id="estado" name="estado" required>
        </div>
        <div class="form-group">
            <label for="localidad">Localidad:</label>
            <input type="text" class="form-control" id="localidad" name="localidad" required>
        </div>
        <button type="submit" class="btn btn-success btn-lg" name="agregarGanadero">Agregar ganadero y continuar registro</button><br><br>
    </form>
</div>

<!-- Modal -->
<div class="modal fade" id="successModal" tabindex="-1" role="dialog" aria-labelledby="successModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="successModalLabel">¡Éxito!</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                Ganadero agregado exitosamente.
            </div>
            <div class="modal-footer">
                <a href="comprarlote.php" class="btn btn-primary">Seguir capturando</a>
            </div>
        </div>
    </div>
</div>


<?php


$conexion = new Conexion();
$conn = $conexion->conectar();

if ($conn === null) {
    die("Error: La conexión a la base de datos es nula.");
}



if (isset($_POST['agregarGanadero'])) {
    $razonSocial = $_POST['razonSocial'];
    $nombre = $_POST['nombre'];
    $psg = $_POST['psg'];
    $domicilio = $_POST['domicilio'];
    $codigoPostal = $_POST['codigoPostal'];
    $Municipio = $_POST['municipio'];
    $Estado = $_POST['estado'];
    $Localidad = $_POST['localidad'];

    // Verificar si el código postal ya existe en la tabla CP
    $checkCodigoPostal = $conn->prepare("SELECT * FROM CP WHERE CodigoPostal = ?");
    $checkCodigoPostal->bind_param("s", $codigoPostal);
    $checkCodigoPostal->execute();
    $result = $checkCodigoPostal->get_result();

    // Si el código postal no existe, agregarlo
    if ($result->num_rows == 0) {
        $insertCodigoPostal = $conn->prepare("INSERT INTO CP (CodigoPostal) VALUES (?)");
        $insertCodigoPostal->bind_param("s", $codigoPostal);
        if (!$insertCodigoPostal->execute()) {
            echo '<div class="alert alert-danger mt-3" role="alert">Error al agregar el código postal: ' . $insertCodigoPostal->error . '</div>';
            exit;
        }
    }
    
    // procedure para agregar ganadero
    $stmt = $conn->prepare("CALL AgregarGanadero(?, ?, ?, ?, ?, ?, ?, ?)");
    if ($stmt === false) {
        die('Error al preparar la consulta: ' . $conn->error);
    }
    $stmt->bind_param("ssssisss", $razonSocial, $nombre, $psg, $domicilio, $codigoPostal, $Municipio, $Estado, $Localidad);
    
    if ($stmt->execute()) {
        echo '<script>
            window.onload = function() {
                $("#successModal").modal("show");
            }
        </script>';
    } else {
        echo '<div class="alert alert-danger mt-3" role="alert">Error al agregar el ganadero: ' . $stmt->error . '</div>';
    }    
    
    $stmt->close();
} 

$conn->close();
?>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
