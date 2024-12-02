<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Link Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <link rel="stylesheet" href="style/login.css">
    <title>Empleados</title>
</head>

<?php
include("includes/header.php");
$servername = "db";
$username = "root";
$password = "clave";
$dbname = "Ganaderia";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Conexión fallida: " . $conn->connect_error);
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    if (isset($_POST["id_empleado"])) {
        $idEmpleado = $_POST["id_empleado"];
        eliminarEmpleado($conn, $idEmpleado);
    } elseif (
        isset($_POST["nombre"]) && 
        isset($_POST["paterno"]) && 
        isset($_POST["materno"]) && 
        isset($_POST["edad"]) && 
        isset($_POST["id_puesto"])
    ) {
        $nombre = $_POST["nombre"];
        $paterno = $_POST["paterno"];
        $materno = $_POST["materno"];
        $edad = $_POST["edad"];
        $idPuesto = $_POST["id_puesto"];
        
        insertarEmpleado($conn, $nombre, $paterno, $materno, $edad, $idPuesto);
    }
}

$queryPuestos = "SELECT Id_puesto, Nombre FROM Puestos";
$resultPuestos = $conn->query($queryPuestos);

if ($resultPuestos === false) {
    die("Error en la consulta de Puestos: " . $conn->error);
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Lista de Empleados</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/css/bootstrap.min.css">
</head>
<body>

<div class="container mt-4">
    <h2 class="mb-4">Lista de Empleados</h2>
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>Nombre</th>
                <th>Apellido Paterno</th>
                <th>Apellido Materno</th>
                <th>Edad</th>
                <th>Puesto</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <?php
            $queryEmpleados = "SELECT e.*, p.Nombre AS NombrePuesto
                               FROM Empleados e
                               INNER JOIN Puestos p ON e.Id_puesto = p.Id_puesto";
            $resultEmpleados = $conn->query($queryEmpleados);

            if ($resultEmpleados === false) {
                die("Error en la consulta de Empleados: " . $conn->error);
            }

            while ($row = $resultEmpleados->fetch_assoc()) {
                echo "<tr>
                        <td>{$row['Nombre']}</td>
                        <td>{$row['Paterno']}</td>
                        <td>{$row['Materno']}</td>
                        <td>{$row['Edad']}</td>
                        <td>{$row['NombrePuesto']}</td>
                        <td>
                            <form action='' method='post' style='display:inline;'>
                                <input type='hidden' name='id_empleado' value='{$row['Id_empleado']}'>
                                <button type='submit' class='btn btn-danger btn-sm'>
                                    <svg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='currentColor' class='bi bi-trash3-fill' viewBox='0 0 16 16'>
                                        <path d='M11 1.5v1h3.5a.5.5 0 0 1 0 1h-.538l-.853 10.66A2 2 0 0 1 11.115 16h-6.23a2 2 0 0 1-1.994-1.84L2.038 3.5H1.5a.5.5 0 0 1 0-1H5v-1A1.5 1.5 0 0 1 6.5 0h3A1.5 1.5 0 0 1 11 1.5m-5 0v1h4v-1a.5.5 0 0 0-.5-.5h-3a.5.5 0 0 0-.5.5M4.5 5.029l.5 8.5a.5.5 0 1 0 .998-.06l-.5-8.5a.5.5 0 1 0-.998.06Zm6.53-.528a.5.5 0 0 0-.528.47l-.5 8.5a.5.5 0 0 0 .998.058l.5-8.5a.5.5 0 0 0-.47-.528ZM8 4.5a.5.5 0 0 0-.5.5v8.5a.5.5 0 0 0 1 0V5a.5.5 0 0 0-.5-.5'/>
                                    </svg>
                                </button>
                            </form>
                        </td>
                    </tr>";
            }
                     
            ?>
        </tbody>
    </table>

    <button class="btn btn-primary mt-4" onclick="toggleForm()">Agregar Empleado</button>

    <div id="formContainer" style="display: none;">
        <h2 class="mt-4">Agregar Nuevo Empleado</h2>
        <form action='' method='post'>
            <div class="mb-3">
                <label for="nombre" class="form-label">Nombre:</label>
                <input type="text" class="form-control" name="nombre" required>
            </div>
            <div class="mb-3">
                <label for="paterno" class="form-label">Apellido Paterno:</label>
                <input type="text" class="form-control" name="paterno" required>
            </div>
            <div class="mb-3">
                <label for="materno" class="form-label">Apellido Materno:</label>
                <input type="text" class="form-control" name="materno" required>
            </div>
            <div class="mb-3">
                <label for="edad" class="form-label">Edad:</label>
                <input type="number" class="form-control" name="edad" required>
            </div>
            <div class="mb-3">
                <label for="id_puesto" class="form-label">Puesto:</label>
                <select class="form-control" name="id_puesto" required>
                    <?php
                    $resultPuestos = $conn->query($queryPuestos);
                    while ($rowPuesto = $resultPuestos->fetch_assoc()) {
                        echo "<option value='{$rowPuesto['Id_puesto']}'>{$rowPuesto['Nombre']}</option>";
                    }
                    ?>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Aceptar</button>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function toggleForm() {
        var formContainer = document.getElementById('formContainer');
        formContainer.style.display = (formContainer.style.display === 'none') ? 'block' : 'none';
    }
</script>
</body>
</html>

<?php
function eliminarEmpleado($conn, $idEmpleado) {
    $stmt = $conn->prepare("CALL EliminarEmpleado(?)");
    $stmt->bind_param("i", $idEmpleado);
    
    if ($stmt->execute()) {
        echo "Empleado eliminado correctamente.";
    } else {
        echo "Error al intentar eliminar al empleado.";
    }

    $stmt->close();
}

function insertarEmpleado($conn, $nombre, $paterno, $materno, $edad, $idPuesto) {
    $stmt = $conn->prepare("CALL InsertarEmpleado(?, ?, ?, ?, ?)");
    $stmt->bind_param("sssis", $nombre, $paterno, $materno, $edad, $idPuesto);

    if ($stmt->execute()) {
        echo "Empleado insertado correctamente.";
    } else {
        echo "Error al intentar insertar un nuevo empleado. Error: " . $conn->error;
    }

    $stmt->close();
}

?>
