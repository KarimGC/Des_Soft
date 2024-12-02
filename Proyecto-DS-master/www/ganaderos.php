<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.18.0/font/bootstrap-icons.css">
    
    <title>Ganaderos</title>
</head>

<body>

<?php
include("class/Conexion.php"); // Ruta a la conexión
include("includes/header.php"); // Ruta al encabezado

$conexion = new Conexion();
$conn = $conexion->conectar();

if ($conn === null) {
    die("Error: La conexión a la base de datos es nula.");
}

function mostrarFormularioAgregar() {
    echo '
    <form action="" method="post">
        <h3>Agregar Ganadero</h3>
        <div class="form-group">
            <label for="razonSocial">Razón Social:</label>
            <input type="text" class="form-control" id="razonSocial" name="razonSocial" required>
        </div>
        <div class="form-group">
            <label for="nombre">Nombre:</label>
            <input type="text" class="form-control" id="nombre" name="nombre" required>
        </div>
        <div class="form-group">
            <label for="psg">PSG:</label>
            <input type="text" class="form-control" id="psg" name="psg" required>
        </div>
        <div class="form-group">
            <label for="domicilio">Domicilio:</label>
            <input type="text" class="form-control" id="domicilio" name="domicilio" required>
        </div>
        <div class="form-group">
            <label for="codigoPostal">Código Postal:</label>
            <input type="text" class="form-control" id="codigoPostal" name="codigoPostal" required>
        </div>
        <button type="submit" class="btn btn-primary" name="agregarGanadero">Agregar Ganadero</button>
    </form>
    ';
}

if (isset($_POST['agregarGanadero'])) {
    $razonSocial = $_POST['razonSocial'];
    $nombre = $_POST['nombre'];
    $psg = $_POST['psg'];
    $domicilio = $_POST['domicilio'];
    $codigoPostal = $_POST['codigoPostal'];

    // procedure para agregar ganadero
    $stmt = $conn->prepare("CALL AgregarGanadero(?, ?, ?, ?, ?)");
    $stmt->bind_param("ssssi", $razonSocial, $nombre, $psg, $domicilio, $codigoPostal);
    
    if ($stmt->execute()) {
        echo '<div class="alert alert-success mt-3" role="alert">Ganadero agregado.</div>';
    } else {
        echo '<div class="alert alert-danger mt-3" role="alert">Error al agregar el ganadero: ' . $stmt->error . '</div>';
    }

    $stmt->close();
}

if (isset($_POST['eliminarGanadero'])) {
    $razonSocialEliminar = $_POST['eliminarGanadero'];

    // procedure eliminar ganadro
    $stmtEliminar = $conn->prepare("CALL EliminarGanadero(?)");
    $stmtEliminar->bind_param("s", $razonSocialEliminar);

    if ($stmtEliminar->execute()) {
        echo '<div class="alert alert-success mt-3" role="alert">Ganadero eliminado con éxito.</div>';
    } else {
        echo '<div class="alert alert-danger mt-3" role="alert">Error al eliminar el ganadero: ' . $stmtEliminar->error . '</div>';
    }

    $stmtEliminar->close();
}

        echo '<div class="container mt-5">';
        echo '<h2>Tabla de Ganaderos</h2>';
        echo '<table class="table table-bordered">';
        echo '<thead>';
        echo '<thead>';
echo '<tr>
        <th>Razón Social</th>
        <th>Nombre</th>
        <th>PSG</th>
        <th>Domicilio</th>
            <th>Codigo Postal</th>
        <th>Colonia</th>
        <th>Ciudad</th>
        <th>Municipio</th>
        <th>Estado</th>
        <th>Acciones</th>
    </tr>';
echo '</thead><tbody>';

$result = $conn->query("SELECT Ganaderos.*, CP.Colonia, Ciudades.Ciudad, Municipios.Municipio, Estados.Estado
    FROM Ganaderos
    LEFT JOIN CP ON Ganaderos.codigo_postal = CP.CodigoPostal
    LEFT JOIN Ciudades ON CP.Id_ciudad = Ciudades.Id_ciudad
    LEFT JOIN Municipios ON Ciudades.Id_municipio = Municipios.Id_municipio
    LEFT JOIN Estados ON Municipios.Id_estado = Estados.Id_estado");

        if ($result === false) {
        echo "Error en la consulta SQL: " . $conn->error;
        } else {
        while ($row = $result->fetch_assoc()) {
        echo '<tr>';
        echo '<td>' . $row['razonsocial'] . '</td>';
        echo '<td>' . $row['nombre'] . '</td>';
        echo '<td>' . $row['psg'] . '</td>';
        echo '<td>' . $row['domicilio'] . '</td>';
        echo '<td>' . $row['codigo_postal'] . '</td>';
        echo '<td>' . $row['Colonia'] . '</td>';
        echo '<td>' . $row['Ciudad'] . '</td>';
        echo '<td>' . $row['Municipio'] . '</td>';
        echo '<td>' . $row['Estado'] . '</td>';
        echo '<td>';
        echo '<form method="post" action="">';
        echo '<input type="hidden" name="eliminarGanadero" value="' . $row['razonsocial'] . '">';
        echo '<button type="submit" class="btn btn-danger">';
        echo '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-trash3-fill" viewBox="0 0 16 16">';
        echo '<path d="M11 1.5v1h3.5a.5.5 0 0 1 0 1h-.538l-.853 10.66A2 2 0 0 1 11.115 16h-6.23a2 2 0 0 1-1.994-1.84L2.038 3.5H1.5a.5.5 0 0 1 0-1H5v-1A1.5 1.5 0 0 1 6.5 0h3A1.5 1.5 0 0 1 11 1.5m-5 0v1h4v-1a.5.5 0 0 0-.5-.5h-3a.5.5 0 0 0-.5.5M4.5 5.029l.5 8.5a.5.5 0 1 0 .998-.06l-.5-8.5a.5.5 0 1 0-.998.06Zm6.53-.528a.5.5 0 0 0-.528.47l-.5 8.5a.5.5 0 0 0 .998.058l.5-8.5a.5.5 0 0 0-.47-.528ZM8 4.5a.5.5 0 0 0-.5.5v8.5a.5.5 0 0 0 1 0V5a.5.5 0 0 0-.5-.5"/>';
        echo '</svg>';
        echo '</button>';
        echo '</form>';
        echo '</td>';
        
        echo '</tr>';
    }
}

echo '</tbody></table>';

echo '<button class="btn btn-primary mt-4" onclick="mostrarForm()">Agregar Ganadero</button>';
echo '<div id="formulario" style="display:none;">';
mostrarFormularioAgregar();
echo '</div>'; 

$conn->close();
?>

<script>
    function mostrarForm() {
        var formulario = document.getElementById('formulario');
        formulario.style.display = 'block';
    }
</script>

</body>
</html>
