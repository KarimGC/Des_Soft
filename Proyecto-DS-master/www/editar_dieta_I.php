<?php
// Configuración de la base de datos
$servername = "db";
$username = "root";
$password = "clave";
$dbname = "Ganaderia";

// Crear conexión
$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Conexión fallida: " . $conn->connect_error);
}

// Obtener los datos del registro si es un GET
if ($_SERVER['REQUEST_METHOD'] === 'GET' && isset($_GET['id_alimento'])) {
    $id_alimento = intval($_GET['id_alimento']);
    $sql = "SELECT * FROM Dieta_I WHERE id_alimento = $id_alimento";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
    } else {
        die("Registro no encontrado.");
    }
}

// Guardar cambios si es un POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $id_alimento = intval($_POST['id_alimento']);
    $cantidad = floatval($_POST['cantidad']);

    $sql = "UPDATE Dieta_I SET cantidad = $cantidad WHERE id_alimento = $id_alimento";
    if ($conn->query($sql) === TRUE) {
        header("Location: dietas.php"); 
        exit();
    } else {
        echo "Error: " . $conn->error;
    }
}

$conn->close();
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <title>Editar Cantidad</title>
</head>
<body>
<div class="container mt-5">
    <h2>Editar Cantidad</h2>
    <form method="POST" action="editar_dieta_I.php">
        <input type="hidden" name="id_alimento" value="<?php echo htmlspecialchars($row['id_alimento']); ?>">
        <div class="form-group">
            <label for="nombre">Nombre:</label>
            <input type="text" class="form-control" id_alimento="nombre" value="<?php echo htmlspecialchars($row['nombre']); ?>" disabled>
        </div>
        <div class="form-group">
            <label for="cantidad">Cantidad:</label>
            <input type="number" class="form-control" id_alimento="cantidad" name="cantidad" value="<?php echo htmlspecialchars($row['cantidad']); ?>" required>
        </div>
        <div class="form-group">
            <label for="unidad">Unidad de Medida:</label>
            <input type="text" class="form-control" id_alimento="unidad" value="<?php echo htmlspecialchars($row['UnidadMedida']); ?>" disabled>
        </div>
        <button type="submit" class="btn btn-success">Guardar Cambios</button>
        <a href="dietas.php" class="btn btn-secondary">Cancelar</a>
    </form>
</div>
</body>
</html>
