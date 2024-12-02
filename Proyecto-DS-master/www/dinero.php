<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Tablas Venta</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
</head>
<body>

<?php
include("includes/header.php");  // Incluye tu encabezado
?>

<div class="container mt-4">
    <h2 class="mb-4">Tabla de Venta Animal</h2>

    <?php
    // Configuración de la base de datos
    $servername = "db";
    $username = "root";
    $password = "clave";
    $dbname = "Ganaderia";

    $conn = new mysqli($servername, $username, $password, $dbname);

    if ($conn->connect_error) {
        die("Conexión fallida: " . $conn->connect_error);
    }

    // Obtener los datos de Venta_animal
    $queryVentaAnimal = "SELECT * FROM Venta_animal";
    $resultVentaAnimal = $conn->query($queryVentaAnimal);

    // Obtener la suma de la columna Precio_total
    $querySumaVentaAnimal = "SELECT SUM(Precio_total) AS total_precio FROM Venta_animal";
    $resultSumaVentaAnimal = $conn->query($querySumaVentaAnimal);
    $totalVentaAnimal = $resultSumaVentaAnimal->fetch_assoc()['total_precio'];

    ?>

    <table class="table table-bordered">
        <thead>
            <tr>
                <th>Arete</th>
                <th>Motivo</th>
                <th>Peso</th>
                <th>Precio/kg</th>
                <th>Fecha</th>
                <th>Precio Total</th>
            </tr>
        </thead>
        <tbody>
        <?php
        if ($resultVentaAnimal && $resultVentaAnimal->num_rows > 0) {
            while ($row = $resultVentaAnimal->fetch_assoc()) {
                echo "<tr>
                        <td>{$row['Arete']}</td>
                        <td>{$row['Motivo']}</td>
                        <td>{$row['Peso']}</td>
                        <td>{$row['Precio_kg']}</td>
                        <td>{$row['Fecha']}</td>
                        <td>{$row['Precio_total']}</td>
                      </tr>";
            }
        } else {
            echo "<tr><td colspan='6'>No se encontraron registros en Venta_animal.</td></tr>";
        }
        ?>
        </tbody>
    </table>
    <p><strong>Suma de Precio Total: </strong><?php echo number_format($totalVentaAnimal, 2); ?></p>

    <h2 class="mb-4 mt-5">Tabla de Venta Lote</h2>

    <?php
    // Obtener los datos de Venta_lote
    $queryVentaLote = "SELECT * FROM Venta_lote";
    $resultVentaLote = $conn->query($queryVentaLote);

    // Obtener la suma de la columna Precio
    $querySumaVentaLote = "SELECT SUM(Precio) AS total_precio_lote FROM Venta_lote";
    $resultSumaVentaLote = $conn->query($querySumaVentaLote);
    $totalVentaLote = $resultSumaVentaLote->fetch_assoc()['total_precio_lote'];
    ?>

    <table class="table table-bordered">
        <thead>
            <tr>
                <th>REEMO</th>
                <th>Motivo</th>
                <th>Precio</th>
                <th>Fecha</th>
            </tr>
        </thead>
        <tbody>
        <?php
        if ($resultVentaLote && $resultVentaLote->num_rows > 0) {
            while ($row = $resultVentaLote->fetch_assoc()) {
                echo "<tr>
                        <td>{$row['REEMO']}</td>
                        <td>{$row['Motivo']}</td>
                        <td>{$row['Precio']}</td>
                        <td>{$row['Fecha']}</td>
                      </tr>";
            }
        } else {
            echo "<tr><td colspan='4'>No se encontraron registros en Venta_lote.</td></tr>";
        }
        ?>
        </tbody>
    </table>
    <p><strong>Suma de Precio: </strong><?php echo number_format($totalVentaLote, 2); ?></p>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
