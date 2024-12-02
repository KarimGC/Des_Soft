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
    $conexion = new Conexion();
    $conn = $conexion->conectar();

    if (!$conn) {
        die("<div class='container mt-5'><div class='alert alert-danger text-center' role='alert'><strong>Error:</strong> Conexión fallida: " . mysqli_connect_error() . "</div></div>");
    }

    if (isset($_POST['lote']) && !empty($_POST['lote'])) {
        // Procesar el primer formulario: Guardar en Venta_lote y luego eliminar por REEMO
        $reemo = $_POST['lote'];
        $motivo = $_POST['motivo'];
        $precio = $_POST['precioKilo'];
        $fecha = $_POST['fechaVenta'];

        // Guardar datos en Venta_lote
        $sqlInsert = "INSERT INTO Venta_lote (REEMO, Motivo, Precio, Fecha) VALUES (?, ?, ?, ?)";
        $stmtInsert = $conn->prepare($sqlInsert);

        if ($stmtInsert) {
            $stmtInsert->bind_param("ssds", $reemo, $motivo, $precio, $fecha);

            if ($stmtInsert->execute()) {
                echo "<div class='container mt-5'><div class='alert alert-success text-center' role='alert'><strong>Éxito:</strong> Los datos del lote fueron guardados en Venta_lote.</div></div>";
            } else {
                echo "<div class='container mt-5'><div class='alert alert-danger text-center' role='alert'><strong>Error:</strong> No se pudieron guardar los datos del lote.</div></div>";
            }
            $stmtInsert->close();
        } else {
            echo "<div class='container mt-5'><div class='alert alert-danger text-center' role='alert'><strong>Error:</strong> No se pudo preparar la consulta de inserción en Venta_lote.</div></div>";
        }

        // Eliminar datos de Lotes por REEMO
        $sqlDelete = "DELETE FROM Lotes WHERE REEMO = ?";
        $stmtDelete = $conn->prepare($sqlDelete);

        if ($stmtDelete) {
            $stmtDelete->bind_param("s", $reemo);

            if ($stmtDelete->execute()) {
                echo "<div class='container mt-5'><div class='alert alert-success text-center' role='alert'><strong>Éxito:</strong> Los lotes fueron eliminados exitosamente.</div></div>";
            } else {
                echo "<div class='container mt-5'><div class='alert alert-danger text-center' role='alert'><strong>Error:</strong> No se pudieron eliminar los lotes.</div></div>";
            }
            $stmtDelete->close();
        }
    }

    if (isset($_POST['arete']) && !empty($_POST['arete'])) {
        $arete = $_POST['arete'];
        $motivo = $_POST['motivo'];
        $peso = $_POST['peso'];
        $precioKg = $_POST['precio'];
        $fecha = $_POST['fechaVenta'];
    
        $sqlInsert = "INSERT INTO Venta_animal (Arete, Motivo, Peso, Precio_kg, Fecha) VALUES (?, ?, ?, ?, ?)";
        $stmtInsert = $conn->prepare($sqlInsert);
    
        if ($stmtInsert) {
            $stmtInsert->bind_param("ssdds", $arete, $motivo, $peso, $precioKg, $fecha);
    
            if ($stmtInsert->execute()) {
                echo "<div class='container mt-5'><div class='alert alert-success text-center' role='alert'><strong>Éxito:</strong> Los datos del animal fueron guardados en Venta_animal.</div></div>";
            } else {
                echo "<div class='container mt-5'><div class='alert alert-danger text-center' role='alert'><strong>Error:</strong> No se pudieron guardar los datos del animal.</div></div>";
            }
            $stmtInsert->close();
        } else {
            echo "<div class='container mt-5'><div class='alert alert-danger text-center' role='alert'><strong>Error:</strong> No se pudo preparar la consulta de inserción en Venta_animal.</div></div>";
        }

        // Eliminar datos de Lotes por Arete
        $sqlDelete = "DELETE FROM Lotes WHERE Arete = ?";
        $stmtDelete = $conn->prepare($sqlDelete);

        if ($stmtDelete) {
            $stmtDelete->bind_param("s", $arete);

            if ($stmtDelete->execute()) {
                echo "<div class='container mt-5'><div class='alert alert-success text-center' role='alert'><strong>Éxito:</strong> El animal fue eliminado exitosamente.</div></div>";
            } else {
                echo "<div class='container mt-5'><div class='alert alert-danger text-center' role='alert'><strong>Error:</strong> No se pudo eliminar el animal.</div></div>";
            }
            $stmtDelete->close();
        }
    }
} else {
    echo "<div class='container mt-5'><div class='alert alert-warning text-center' role='alert'><strong>Advertencia:</strong> El formulario no es válido o hay campos vacíos.</div></div>";
}

$conn->close();
?>

<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
</body>
</html>