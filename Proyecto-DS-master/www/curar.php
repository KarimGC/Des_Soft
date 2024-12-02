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
    <h2>Tratar Lote</h2>

    <?php
    if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["vacunarLote"])) {
        $reemo = $_POST["lote"];
        $vacunaId = $_POST["vacuna"];

        $servername = "db";
        $username = "root";
        $password = "clave";
        $dbname = "Ganaderia";

        $conn = new mysqli($servername, $username, $password, $dbname);

        if ($conn->connect_error) {
            die("Conexión fallida: " . $conn->connect_error);
        }

        // Obtener la cantidad de recurrencias del REEMO en la tabla Lotes
        $getCantidadSql = "SELECT COUNT(*) as recurrencias FROM Lotes WHERE REEMO = '$reemo'";
        $resultCantidad = $conn->query($getCantidadSql);

        if ($resultCantidad->num_rows > 0) {
            $rowCantidad = $resultCantidad->fetch_assoc();
            $cantidadRecurrencias = $rowCantidad['recurrencias'];

            // Actualizar la cantidad en la tabla Vacunas
            $updateSql = "UPDATE Vacunas SET cantidad = cantidad - $cantidadRecurrencias WHERE id_vacuna = $vacunaId";

            if ($conn->query($updateSql) === TRUE) {
                echo "<div class='alert alert-success' role='alert'>Vacunación realizada con éxito.</div>";
            } else {
                echo "<div class='alert alert-danger' role='alert'>Error al vacunar el lote: " . $conn->error . "</div>";
            }
        } else {
            echo "<div class='alert alert-danger' role='alert'>No se encontró ningún lote con el REEMO proporcionado.</div>";
        }

        $conn->close();
    }

    if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["vacunarAnimal"])) {
        $arete = $_POST["arete"];  // Número de arete del animal
        $vacunaId = $_POST["vacuna"];
        $dosis = $_POST["dosis"];  // Cantidad de dosis introducida

        $servername = "db";
        $username = "root";
        $password = "clave";
        $dbname = "Ganaderia";

        $conn = new mysqli($servername, $username, $password, $dbname);

        if ($conn->connect_error) {
            die("Conexión fallida: " . $conn->connect_error);
        }

        // Actualizar la cantidad en la tabla Vacunas usando la cantidad de dosis introducida
        $updateSql = "UPDATE Vacunas SET cantidad = cantidad - $dosis WHERE id_vacuna = $vacunaId";

            if ($conn->query($updateSql) === TRUE) {
                echo "<div class='alert alert-success' role='alert'>Vacunación realizada con éxito.</div>";
            } else {
                echo "<div class='alert alert-danger' role='alert'>Error al vacunar el lote: " . $conn->error . "</div>";
            }


        $conn->close();
    }

    ?>

    <form action="curar.php" method="post">
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
            <label for="vacuna">Seleccione el tratamiento:</label>
            <select class="form-control" id="vacuna" name="vacuna">
                <?php
                $servername = "db";
                $username = "root";
                $password = "clave";
                $dbname = "Ganaderia";

                $conn = new mysqli($servername, $username, $password, $dbname);

                if ($conn->connect_error) {
                    die("Conexión fallida: " . $conn->connect_error);
                }

                $sql = "SELECT id_vacuna, nombre, cantidad, PrecioUni FROM Vacunas";
                $result = $conn->query($sql);

                if ($result->num_rows > 0) {
                    while ($row = $result->fetch_assoc()) {
                        echo "<option value='{$row['id_vacuna']}'>
                                {$row['nombre']} - Cantidad: {$row['cantidad']}
                              </option>";
                    }
                } else {
                    echo "<option value='' disabled>No hay vacunas disponibles</option>";
                }

                $conn->close();
                ?>
            </select>
        </div>

        <button type="submit" class="btn btn-primary" name="vacunarLote">Tratar Lote</button>
    </form>
</div>

<div class="container mt-4">
    <br><h2>Tratar animal</h2>

    <form action="curar.php" method="post">

        <div class="form-group">
            <label for="arete">Numero de arete:</label>
            <select class="form-control" id="arete" name="arete">
                <?php
                $servername = "db";
                $username = "root";
                $password = "clave";
                $dbname = "Ganaderia";

                $conn = new mysqli($servername, $username, $password, $dbname);

                if ($conn->connect_error) {
                    die("Conexión fallida: " . $conn->connect_error);
                }

                $sql = "SELECT Arete FROM Lotes";
                $result = $conn->query($sql);

                if ($result->num_rows > 0) {
                    while ($row = $result->fetch_assoc()) {
                        echo "<option value='{$row['Arete']}'>{$row['Arete']}</option>";
                    }
                } else {
                    echo "<option value='' disabled>No hay aretes disponibles</option>";
                }

                $conn->close();
                ?>
            </select>
        </div>

        <div class="form-group">
            <label for="vacuna">Seleccionar tratamiento:</label>
            <select class="form-control" id="vacuna" name="vacuna">
                <?php
                $servername = "db";
                $username = "root";
                $password = "clave";
                $dbname = "Ganaderia";

                $conn = new mysqli($servername, $username, $password, $dbname);

                if ($conn->connect_error) {
                    die("Conexión fallida: " . $conn->connect_error);
                }

                $sql = "SELECT id_vacuna, nombre, cantidad, PrecioUni FROM Vacunas";
                $result = $conn->query($sql);

                if ($result->num_rows > 0) {
                    while ($row = $result->fetch_assoc()) {
                        echo "<option value='{$row['id_vacuna']}'>
                                {$row['nombre']} - Cantidad: {$row['cantidad']}
                              </option>";
                    }
                } else {
                    echo "<option value='' disabled>No hay vacunas disponibles</option>";
                }

                $conn->close();
                ?>
            </select>
        </div>

        <div class="mb-3">
            <label for="dosis" class="form-label">Cantidad</label>
            <input type="number" class="form-control" id="dosis" name="dosis" required>
    </div>

        <button type="submit" class="btn btn-primary" name="vacunarAnimal">Tratar animal</button>
    </form>
</div>

<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>

</body>
</html>