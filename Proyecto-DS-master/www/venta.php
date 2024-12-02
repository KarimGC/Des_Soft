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

function obtenerOpcionesGanaderos() {
    $conexion = new Conexion();
    $conn = $conexion->conectar();

    if (!$conn) {
        die("Conexión fallida: " . mysqli_connect_error());
    }

    $sqlGanaderos = "SELECT Razonsocial, Nombre FROM Ganaderos";
    $resultGanaderos = $conn->query($sqlGanaderos);

    $opciones = [];

    while ($rowGanadero = $resultGanaderos->fetch_assoc()) {
        $razonSocial = $rowGanadero['Razonsocial'];
        $nombre = $rowGanadero['Nombre'];

        // Agregar opción al array
        $opciones[] = [
            'razonSocial' => $razonSocial,
            'nombre' => $nombre,
        ];
    }

    $conn->close();

    return $opciones;
}

function obtenerOpcionesLotes() {
    $conexion = new Conexion();
    $conn = $conexion->conectar();

    if (!$conn) {
        die("Conexión fallida: " . mysqli_connect_error());
    }

    $sqlLotes = "SELECT Id_lote, Razonsocial, CantidadAnimales FROM Lotes";
    $resultLotes = $conn->query($sqlLotes);

    $opciones = [];

    while ($rowLote = $resultLotes->fetch_assoc()) {
        $idLote = $rowLote['Id_lote'];
        $razonSocial = $rowLote['Razonsocial'];
        $cantidadAnimales = $rowLote['CantidadAnimales'];

        $opciones[] = [
            'id' => $idLote,
            'label' => "$razonSocial (Animales: $cantidadAnimales)"
        ];
    }

    $conn->close();

    return $opciones;
}

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
    <h2>Vender Lote</h2>
    <form method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>">
        <div class="mb-3">
            <label for="ganadero" class="form-label">Seleccionar Ganadero</label>
            <select class="form-select" id="ganadero" name="ganadero" required>
                <?php
                $opcionesGanaderos = obtenerOpcionesGanaderos();
                foreach ($opcionesGanaderos as $opcionGanadero) {
                    echo "<option value='" . $opcionGanadero['razonSocial'] . "'>" . $opcionGanadero['razonSocial'] . " - " . $opcionGanadero['nombre'] . "</option>";
                }
                ?>
            </select>
        </div>
        <div class="mb-3">
            <label for="idLote" class="form-label">Seleccionar Lote</label>
            <select class="form-select" id="idLote" name="idLote" required>
                <?php
                $opcionesLotes = obtenerOpcionesLotes();
                foreach ($opcionesLotes as $opcion) {
                    echo "<option value='" . $opcion['id'] . "'>" . $opcion['label'] . "</option>";
                }
                ?>
            </select>
        </div>
        <div class="mb-3">
            <label for="precioKilo" class="form-label">Precio por Kilo</label>
            <input type="text" class="form-control" id="precioKilo" name="precioKilo" required>
        </div>
        <div class="mb-3">
            <label for="animalesVenta" class="form-label">Cantidad de Animales a Vender</label>
            <input type="number" class="form-control" id="animalesVenta" name="animalesVenta" required min="1">
        </div>
        
        <button type="submit" class="btn btn-primary">Registrar Venta</button>
    </form>
</div>

<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
</body>
</html>
