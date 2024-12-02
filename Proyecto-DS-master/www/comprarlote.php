<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <title>Comprar Lote</title>
</head>
<body>
<?php
include("includes/header.php");
include("class/Conexion.php");

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Procesar el formulario cuando se envíe
    $conexion = new Conexion();

    // Obtener la conexión a la base de datos
    $conn = $conexion->conectar();

    if (!$conn) {
        die("Conexión fallida: " . mysqli_connect_error());
    }

    // Recoger los datos del formulario
    $razonSocial = $_POST["razonSocial"];
    $fechaEntrada = $_POST["fechaEntrada"];
    $pesoLote = $_POST["pesoLote"];
    $precioKilo = $_POST["precioKilo"];
    $cantidadAnimales = $_POST["cantidadAnimales"];

    // Insertar los datos en la tabla Lotes sin incluir PrecioTotal
    $sql = "INSERT INTO Lotes (Razonsocial, CantidadAnimales, PesoLote, PrecioKilo, FechaEntrada) 
            VALUES ('$razonSocial', $cantidadAnimales, '$pesoLote', '$precioKilo', '$fechaEntrada')";

    if ($conn->query($sql) === TRUE) {
        // No need to manually update 'PrecioTotal' when it's a generated column

        // Insertar datos en la tabla Caja
        $fechaOperacion = $fechaEntrada;
        $tipoOperacion = 'Gasto';
        $monto = $pesoLote * $precioKilo; // Assuming 'Monto' is based on 'PesoLote' and 'PrecioKilo'

        $sqlCaja = "INSERT INTO Caja (FechaOperacion, TipoOperacion, Monto) 
                    VALUES ('$fechaOperacion', '$tipoOperacion', '$monto')";

        if ($conn->query($sqlCaja) !== TRUE) {
            echo "<div class='container mt-5'><p>Error al registrar el gasto en la caja: " . $conn->error . "</p></div>";
        }

        echo "<div class='container mt-5'><p>Lote comprado con éxito y gasto registrado en la caja.</p></div>";
    } else {
        echo "<div class='container mt-5'><p>Error al comprar el lote: " . $conn->error . "</p></div>";
    }

    $conn->close();
}

// Volver a abrir la conexión para obtener opciones de RazonSocial y ID Lote
$conexion = new Conexion();
$conn = $conexion->conectar();

if (!$conn) {
    die("Conexión fallida: " . mysqli_connect_error());
}

// Obtener opciones de RazonSocial desde la base de datos (tabla Ganaderos)
$sqlRazonSocial = "SELECT Razonsocial FROM Ganaderos";
$resultRazonSocial = $conn->query($sqlRazonSocial);

// Obtener opciones de ID Lote basadas en la Razón Social seleccionada
$idLoteOptions = array();
if (isset($_POST["razonSocial"])) {
    $selectedRazonSocial = $_POST["razonSocial"];
    $sqlIdLote = "SELECT Id_lote FROM Lotes WHERE Razonsocial = '$selectedRazonSocial'";
    $resultIdLote = $conn->query($sqlIdLote);
    while ($rowIdLote = $resultIdLote->fetch_assoc()) {
        $idLoteOptions[] = $rowIdLote["Id_lote"];
    }
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Compra de Lote</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" integrity="sha384-rbs5Fb0LfoBxKOzqPk7rOEHRz6HfaNz5oBX6Z3Nry5XfHjGz8r+JGIRGzKbck5V9" crossorigin="anonymous">
</head>
<body>

<div class="container mt-5">
    <h2>Comprar Lote</h2>
    <form method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>"><br>
        
    <div class="mb-3">
            <label for="razonSocial" class="form-label">Razón Social</label>
            <select class="form-select" id="razonSocial" name="razonSocial" required>
                <?php
                while ($rowRazonSocial = $resultRazonSocial->fetch_assoc()) {
                    $selected = ($rowRazonSocial["Razonsocial"] == $selectedRazonSocial) ? "selected" : "";
                    echo "<option value='" . $rowRazonSocial["Razonsocial"] . "' $selected>" . $rowRazonSocial["Razonsocial"] . "</option>";
                }
                ?>
            </select>
        </div>
        
        <div class="mb-3">
            <label for="nreemo" class="form-label">N.REEMO</label>
            <input type="text" class="form-control" id="reemo" name="reemo" required>
        </div>

        <div class="mb-3">
            <label for="motivo" class="form-label">Motivo</label>
            <input type="text" class="form-control" id="motivo" name="motivo" required>
        </div>

        <div class="mb-3">
            <label for="fechaEntrada" class="form-label">Fecha de Entrada</label>
            <input type="date" class="form-control" id="fechaEntrada" name="fechaEntrada" required>
        </div>
        <div class="mb-3">
            <label for="pesoLote" class="form-label">Peso del Lote</label>
            <input type="text" class="form-control" id="pesoLote" name="pesoLote" required>
        </div>
        <div class="mb-3">
            <label for="precioKilo" class="form-label">Precio por Kilo</label>
            <input type="text" class="form-control" id="precioKilo" name="precioKilo" required>
        </div>
        <div class="mb-3">
            <label for="cantidadAnimales" class="form-label">Cantidad de Animales</label>
            <input type="number" class="form-control" id="cantidadAnimales" name="cantidadAnimales" required>
        </div>

        
        
        <button type="submit" class="btn btn-primary btn-success">Comprar Lote</button>
        <a href="ganaderos_registro.php" class="btn btn-primary btn-secondary" role="button" aria-pressed="true">Agregar Nueva Razon Social</a>
    </form>
</div>

<!-- Bootstrap Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-bz3htznfnCJUiN+ouzWEhA0J6i/DOTt8Y5FzhKG6z13MiWBKRl0pMb7OoBydSMIk" crossorigin="anonymous"></script>
</body>
</html>
