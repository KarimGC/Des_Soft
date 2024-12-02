<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <title>Vender Lote</title>
</head>
<body>

<?php
include("includes/header.php");
include("class/Conexion.php");


if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $idLote = $_POST["idLote"];
    $precioKilo = $_POST["precioKilo"];
    $animalesVenta = $_POST["animalesVenta"];

    // procedure VenderLote
    $conexion = new Conexion();
    $conn = $conexion->conectar();

    if (!$conn) {
        die("Conexión fallida: " . mysqli_connect_error());
    }

    // procedure almacenado
    $sqlCallProcedure = "CALL VenderLote(?, ?, ?)";
    $stmtCallProcedure = $conn->prepare($sqlCallProcedure);

    if ($stmtCallProcedure) {
        $stmtCallProcedure->bind_param("idi", $idLote, $precioKilo, $animalesVenta);

        if ($stmtCallProcedure->execute()) {
            echo "<div class='container mt-5'><div class='alert alert-success' role='alert'>Venta registrada con éxito.</div></div>";
        } else {
            echo "<div class='container mt-5'><div class='alert alert-danger' role='alert'>Error al registrar la venta.</div></div>";
        }

        $stmtCallProcedure->close();
    } else {
        echo "<div class='container mt-5'><div class='alert alert-danger' role='alert'>Error en la preparación del procedimiento almacenado.</div></div>";
    }

    $conn->close();
}
?>

<div class="container mt-5">
    <h1>Vender Lote</h1><br>

    <form method="post" action="procesar_formularios.php">
        <div class="form-group">
            <label for="lote">Seleccione el Lote:</label>
            <select class="form-control" id="lote" name="lote">
                <?php
                $servername = "db";
                $username = "root";
                $password = "clave";
                $dbname = "Ganaderia";

                $conn = new mysqli($servername, $username, $password, $dbname);

                if ($conn->connect_error) {
                    die("Conexión fallida: " . $conn->connect_error);
                }

                $sql = "SELECT DISTINCT REEMO FROM Lotes";
                $result = $conn->query($sql);

                if ($result->num_rows > 0) {
                    while ($row = $result->fetch_assoc()) {
                        echo "<option value='{$row['REEMO']}'>{$row['REEMO']}</option>";
                    }
                } else {
                    echo "<option value='' disabled>No hay lotes disponibles</option>";
                }

                $conn->close();
                ?>
            </select>
        </div>

        <div class="mb-3">
            <label for="motivo" class="form-label">Motivo</label>
            <select class="form-control" id="motivo" name="motivo" required>
            <option value="Engorda">Engorda</option>
            <option value="Cría">Cría</option>
            <option value="Vitaminas">Sacrificio</option>
        </select>
        </div>

        <div class="mb-3">
            <label for="precioKilo" class="form-label">Precio total</label>
            <input type="number" class="form-control" id="precioKilo" name="precioKilo" required>
        </div>

        <div class="mb-3">
            <label for="fechaVenta" class="form-label">Fecha de venta</label>
            <input type="date" class="form-control" id="fechaVenta" name="fechaVenta" required>
        </div>
        <br>
        <button type="submit" class="btn btn-success btn-lg">Registrar Venta</button>
    </form>
</div>

<div class="container mt-5">
    <h1>Vender Animal</h1><br>

    <form method="post" action="procesar_formularios.php">

    <div class="form-group">
            <label for="arete">Arete:</label>
            <input type="text" class="form-control" id="arete" name="arete" list="areteOptions" placeholder="Escribe el número de arete" required>
            <datalist id="areteOptions">
                <?php
                $servername = "db";
                $username = "root";
                $password = "clave";
                $dbname = "Ganaderia";

                $conn = new mysqli($servername, $username, $password, $dbname);

                if ($conn->connect_error) {
                    die("Conexión fallida: " . $conn->connect_error);
                }

                $sql = "SELECT DISTINCT Arete FROM Lotes";
                $result = $conn->query($sql);

                if ($result->num_rows > 0) {
                    while ($row = $result->fetch_assoc()) {
                        echo "<option value='{$row['Arete']}'>";
                    }
                }

                $conn->close();
                ?>
            </datalist>
        </div>

        <div class="mb-3">
            <label for="motivo" class="form-label">Motivo</label>
            <select class="form-control" id="motivo" name="motivo" required>
            <option value="Engorda">Engorda</option>
            <option value="Cría">Cría</option>
            <option value="Vitaminas">Sacrificio</option>
        </select>
        </div>

        <div class="mb-3">
            <label for="peso" class="form-label">Peso</label>
            <input type="number" class="form-control" id="peso" name="peso" required>
        </div>
        
        <div class="mb-3">
            <label for="precio" class="form-label">Precio por kg</label>
            <input type="number" class="form-control" id="precio" name="precio" required>
        </div>

        <div class="mb-3">
            <label for="fechaVenta" class="form-label">Fecha de venta</label>
            <input type="date" class="form-control" id="fechaVenta" name="fechaVenta" required>
        </div>
        <br>
        <button type="submit" class="btn btn-success btn-lg">Registrar Venta</button>
    </form>
</div>

<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
</body>
</html>