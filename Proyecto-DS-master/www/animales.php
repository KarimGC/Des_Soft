<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Animales</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
</head>
<body>

<?php
include("includes/header.php");
?>

<div class="container mt-4">
    <h2 class="mb-4">Animales</h2>

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

    // Manejo de solicitudes POST para CRUD
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        if (isset($_POST["eliminar_id"])) {
            $idLote = $_POST["eliminar_id"];
            eliminarLote($conn, $idLote);
        } elseif (isset($_POST["PesoLote"], $_POST["PrecioKilo"], $_POST["FechaEntrada"], $_POST["Razonsocial"], $_POST["REEMO"], $_POST["Motivo"], $_POST["Consecutivo"], $_POST["Arete"], $_POST["Sexo"], $_POST["Meses"], $_POST["Clasif"])) {
            $pesoLote = $_POST["PesoLote"];
            $precioKilo = $_POST["PrecioKilo"];
            $fechaEntrada = $_POST["FechaEntrada"];
            $razonSocial = $_POST["Razonsocial"];
            $reemo = $_POST["REEMO"];
            $motivo = $_POST["Motivo"];
            $consecutivo = $_POST["Consecutivo"];
            $arete = $_POST["Arete"];
            $sexo = $_POST["Sexo"];
            $meses = $_POST["Meses"];
            $clasif = $_POST["Clasif"];
            insertarLote($conn, $pesoLote, $precioKilo, $fechaEntrada, $razonSocial, $reemo, $motivo, $consecutivo, $arete, $sexo, $meses, $clasif);
        }
    }

    function eliminarLote($conn, $idLote) {
        $stmt = $conn->prepare("DELETE FROM Lotes WHERE Id_lote = ?");
        $stmt->bind_param("i", $idLote);

        if ($stmt->execute()) {
            echo "<div class='alert alert-success'>Lote eliminado correctamente.</div>";
        } else {
            echo "<div class='alert alert-danger'>Error al eliminar el lote.</div>";
        }

        $stmt->close();
    }

    function insertarLote($conn, $pesoLote, $precioKilo, $fechaEntrada, $razonSocial, $reemo, $motivo, $consecutivo, $arete, $sexo, $meses, $clasif) {
        $stmt = $conn->prepare("INSERT INTO Lotes (PesoLote, PrecioKilo, FechaEntrada, Razonsocial, REEMO, Motivo, Consecutivo, Arete, Sexo, Meses, Clasif) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
        $stmt->bind_param("ddsssssssis", $pesoLote, $precioKilo, $fechaEntrada, $razonSocial, $reemo, $motivo, $consecutivo, $arete, $sexo, $meses, $clasif);

        if ($stmt->execute()) {
            echo "<div class='alert alert-success'>Lote agregado correctamente.</div>";
        } else {
            echo "<div class='alert alert-danger'>Error al agregar el lote: " . $conn->error . "</div>";
        }

        $stmt->close();
    }

    // Obtener lotes
    $query = "SELECT PesoLote, PrecioKilo, FechaEntrada, Razonsocial, REEMO, Motivo, Consecutivo, Arete, Sexo, Meses, Clasif FROM Lotes";
    $result = $conn->query($query);
    ?>

    <table class="table table-bordered">
        <thead>
        <tr>
            <th>Peso</th>
            <th>Precio/kg</th>
            <th>Fecha Entrada</th>
            <th>Razón Social</th>
            <th>REEMO</th>
            <th>Motivo</th>
            <th>Consecutivo</th>
            <th>Arete</th>
            <th>Sexo</th>
            <th>Meses</th>
            <th>Clasificación</th>
            <th>Acciones</th>
        </tr>
        </thead>
        <tbody>
        <?php
        if ($result && $result->num_rows > 0) {
            while ($row = $result->fetch_assoc()) {
                echo "<tr>
                        <td>{$row['PesoLote']}</td>
                        <td>{$row['PrecioKilo']}</td>
                        <td>{$row['FechaEntrada']}</td>
                        <td>{$row['Razonsocial']}</td>
                        <td>{$row['REEMO']}</td>
                        <td>{$row['Motivo']}</td>
                        <td>{$row['Consecutivo']}</td>
                        <td>{$row['Arete']}</td>
                        <td>{$row['Sexo']}</td>
                        <td>{$row['Meses']}</td>
                        <td>{$row['Clasif']}</td>
                        <td>
                            <form action='' method='post' style='display:inline;'>
                                <input type='hidden' name='eliminar_id' value='{$row['Id_lote']}'>
                                <button type='submit' class='btn btn-danger btn-sm'>Eliminar</button>
                            </form>
                        </td>
                      </tr>";
            }
        } else {
            echo "<tr><td colspan='12'>No se encontraron lotes.</td></tr>";
        }
        ?>
        </tbody>
    </table>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
