<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <title>Alimentar y Vacunar Lotes</title>
</head>
<body>

<?php
include("includes/header.php");
?>

<div class="container mt-4">
    <h2>Alimentar Lote</h2>

<?php
    if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["alimentarLotes"])){
    $loteId = $_POST["lote"];
    $dieta = $_POST["dieta"];
    $fechaEntrada = $_POST["fechaEntrada"];

    $servername = "db";
    $username = "root";
    $password = "clave";
    $dbname = "Ganaderia";

    $conn = new mysqli($servername, $username, $password, $dbname);

    if ($conn->connect_error) {
        die("Conexión fallida: " . $conn->connect_error);
    }

    if ($dieta == "Abasto") {
        // Tomar cantidades de Dieta_A y restarlas de Alimentos
        $sql = "
            UPDATE Alimentos AS a
            JOIN Dieta_A AS d ON a.id_alimento = d.id_alimento
            SET a.cantidad = a.cantidad - d.cantidad
            WHERE a.cantidad >= d.cantidad;
        ";

        if ($conn->query($sql) === TRUE) {
            echo "<div class='alert alert-success' role='alert'>Se han actualizado las cantidades de Alimentos según la dieta 'Abasto'.</div>";
        } else {
            echo "<div class='alert alert-danger' role='alert'>Error al actualizar las cantidades: " . $conn->error . "</div>";
        }
    }
    
    if ($dieta == "Engorda") {
        // Tomar cantidades de Dieta_A y restarlas de Alimentos
        $sql = "
            UPDATE Alimentos AS a
            JOIN Dieta_E AS d ON a.id_alimento = d.id_alimento
            SET a.cantidad = a.cantidad - d.cantidad
            WHERE a.cantidad >= d.cantidad;
        ";
            

        if ($conn->query($sql) === TRUE) {
            echo "<div class='alert alert-success' role='alert'>Se han actualizado las cantidades de Alimentos según la dieta 'Abasto'.</div>";
        } else {
            echo "<div class='alert alert-danger' role='alert'>Error al actualizar las cantidades: " . $conn->error . "</div>";
        }
    }
    
    if ($dieta == "Desarrollo") {
        // Tomar cantidades de Dieta_A y restarlas de Alimentos
        $sql = "
            UPDATE Alimentos AS a
            JOIN Dieta_D AS d ON a.id_alimento = d.id_alimento
            SET a.cantidad = a.cantidad - d.cantidad
            WHERE a.cantidad >= d.cantidad;
        ";
            

        if ($conn->query($sql) === TRUE) {
            echo "<div class='alert alert-success' role='alert'>Se han actualizado las cantidades de Alimentos según la dieta 'Abasto'.</div>";
        } else {
            echo "<div class='alert alert-danger' role='alert'>Error al actualizar las cantidades: " . $conn->error . "</div>";
        }
    }

    if ($dieta == "Finalizacion") {
        // Tomar cantidades de Dieta_A y restarlas de Alimentos
        $sql = "
            UPDATE Alimentos AS a
            JOIN Dieta_F AS d ON a.id_alimento = d.id_alimento
            SET a.cantidad = a.cantidad - d.cantidad
            WHERE a.cantidad >= d.cantidad;
        ";
            

        if ($conn->query($sql) === TRUE) {
            echo "<div class='alert alert-success' role='alert'>Se han actualizado las cantidades de Alimentos según la dieta 'Abasto'.</div>";
        } else {
            echo "<div class='alert alert-danger' role='alert'>Error al actualizar las cantidades: " . $conn->error . "</div>";
        }
    }

    if ($dieta == "Inicio") {
        // Tomar cantidades de Dieta_A y restarlas de Alimentos
        $sql = "
            UPDATE Alimentos AS a
            JOIN Dieta_I AS d ON a.id_alimento = d.id_alimento
            SET a.cantidad = a.cantidad - d.cantidad
            WHERE a.cantidad >= d.cantidad;
        ";
            

        if ($conn->query($sql) === TRUE) {
            echo "<div class='alert alert-success' role='alert'>Se han actualizado las cantidades de Alimentos según la dieta 'Abasto'.</div>";
        } else {
            echo "<div class='alert alert-danger' role='alert'>Error al actualizar las cantidades: " . $conn->error . "</div>";
        }
    }

    $sql = "INSERT INTO Dieta_Historial (REEMO, Fecha) VALUES ('$loteId', '$fechaEntrada')";
        if ($conn->query($sql) === TRUE) {
            echo "<div class='alert alert-success' role='alert'>Historial actualizado exitosamente.</div>";
        } else {
            echo "<div class='alert alert-danger' role='alert'>Error al guardar el historial: " . $conn->error . "</div>";
        }

    $conn->close();
}
    
?>


    <form action="alimentar_v2.php" method="post">
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

        <div class="form-group">
    <label for="dieta">Seleccione la Dieta:</label>
    <select class="form-control" id="dieta" name="dieta">
        <option value="Engorda">Engorda</option>
        <option value="Abasto">Abasto</option>
        <option value="Desarrollo">Desarrollo</option>
        <option value="Finalizacion">Finalizacion</option>
        <option value="Inicio">Inicio</option>
    </select>
    <br>
    <div class="mb-3">
            <label for="fechaEntrada" class="form-label">Fecha</label>
            <input type="date" class="form-control" id="fechaEntrada" name="fechaEntrada" required>
    </div>

</div>
        <button type="submit" class="btn btn-primary" name="alimentarLotes">Alimentar Lote</button>
    </form>
</div>


<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>

</body>
</html>