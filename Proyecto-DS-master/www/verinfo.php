<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <title>Información del Lote</title>
</head>
<body>

<?php
include("includes/header.php");

$id_lote = $_GET['id'];

$servername = "db";
$username = "root";
$password = "clave";
$dbname = "Ganaderia";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Conexión fallida: " . $conn->connect_error);
}

$sql = "SELECT *, PrecioKilo * PesoLote AS PrecioTotal FROM Lotes WHERE id_lote = $id_lote";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    ?>
    <div class="container mt-5">
        <h2>Información del Lote</h2>
        <table class="table">
            <tr>
                <th>Razón Social</th>
                <td><?php echo $row["Razonsocial"]; ?></td>
            </tr>
            <tr>
                <th>Cantidad de Animales</th>
                <td><?php echo $row["CantidadAnimales"]; ?></td>
            </tr>
            <tr>
                <th>Peso por Lote</th>
                <td><?php echo $row["PesoLote"]; ?></td>
            </tr>
            <tr>
                <th>Fecha de Entrada</th>
                <td><?php echo $row["FechaEntrada"]; ?></td>
            </tr>
            <tr>
                <th>Precio por Kilo</th>
                <td><?php echo $row["PrecioKilo"]; ?></td>
            </tr>
            <tr>
                <th>Precio Total</th>
                <td><?php echo $row["PrecioTotal"]; ?></td>
            </tr>
        </table>
    </div>
    <?php
} else {
    echo "<div class='container mt-5'><p>No se encontró información para el lote seleccionado.</p></div>";
}

$conn->close();
?>

<!-- Bootstrap Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-bz3htznfnCJUiN+ouzWEhA0J6i/DOTt8Y5FzhKG6z13MiWBKRl0pMb7OoBydSMIk" crossorigin="anonymous"></script>
</body>
</html>
