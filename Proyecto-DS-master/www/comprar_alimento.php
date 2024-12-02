<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <title>Compra de Alimentos</title>
</head>
<body>

<?php
include("includes/header.php");
?>

<div class="container mt-4">
    <h2>Compra de Alimentos</h2>

    <?php
    if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["comprarAlimentos"])) {
        $cantidadMaiz = $_POST["cantidadMaiz"];
        $cantidadSalvado = $_POST["cantidadSalvado"];
        $cantidadSoya = $_POST["cantidadSoya"];
        $cantidadMelaza = $_POST["cantidadMelaza"];
        $cantidadZilpaterol = $_POST["cantidadZilpaterol"];
        $cantidadMinerales = $_POST["cantidadMinerales"];
        $cantidadRastrojo = $_POST["cantidadRastrojo"];
        $cantidadRolado = $_POST["cantidadRolado"];
        $cantidadAlfalfa = $_POST["cantidadAlfalfa"];
        $cantidadUrea = $_POST["cantidadUrea"];
        $cantidadElectro = $_POST["cantidadElectro"];


        $servername = "db";
        $username = "root";
        $password = "clave";
        $dbname = "Ganaderia";

        $conn = new mysqli($servername, $username, $password, $dbname);

        if ($conn->connect_error) {
            die("Conexión fallida: " . $conn->connect_error);
        }

        $sql = "CALL ComprarAlimento($cantidadMaiz, $cantidadSalvado, $cantidadSoya, $cantidadMelaza, $cantidadZilpaterol, $cantidadMinerales, $cantidadRastrojo, $cantidadRolado, $cantidadAlfalfa, $cantidadUrea, $cantidadElectro)";

        $result = $conn->query($sql);

        if ($result) {
            echo "<div class='alert alert-success' role='alert'>Compra de alimentos realizada con éxito.</div>";
            
            exit();
        } else {
            echo "<div class='alert alert-danger' role='alert'>Error al realizar la compra de alimentos: " . $conn->error . "</div>";
        }

        $conn->close();
    }
    ?>

    <form method="post" action="<?php echo $_SERVER['PHP_SELF']; ?>">
        <div class="form-group">
            <label for="cantidadMaiz">Cantidad de Maíz:</label>
            <input type="number" class="form-control" id="cantidadMaiz" name="cantidadMaiz" value="0">
        </div>
        <div class="form-group">
            <label for="cantidadSalvado">Cantidad de Salvado:</label>
            <input type="number" class="form-control" id="cantidadSalvado" name="cantidadSalvado" value="0">
        </div>
        <div class="form-group">
            <label for="cantidadSoya">Cantidad de Soya:</label>
            <input type="number" class="form-control" id="cantidadSoya" name="cantidadSoya" value="0">
        </div>
        <div class="form-group">
            <label for="cantidadMelaza">Cantidad de Melaza:</label>
            <input type="number" class="form-control" id="cantidadMelaza" name="cantidadMelaza" value="0">
        </div>

        <div class="form-group">
            <label for="cantidadZilpaterol">Cantidad de Zilpaterol:</label>
            <input type="number" class="form-control" id="cantidadZilpaterol" name="cantidadZilpaterol" value="0">
        </div>

        <div class="form-group">
            <label for="cantidadMinerales">Cantidad de Minerales:</label>
            <input type="number" class="form-control" id="cantidadMinerales" name="cantidadMinerales" value="0">
        </div>
        <div class="form-group">
            <label for="cantidadRastrojo">Cantidad de Rastrojo:</label>
            <input type="number" class="form-control" id="cantidadRastrojo" name="cantidadRastrojo" value="0">
        </div>
        <div class="form-group">
            <label for="cantidadRolado">Cantidad de Maiz rolado:</label>
            <input type="number" class="form-control" id="cantidadRolado" name="cantidadRolado" value="0">
        </div>
        <div class="form-group">
            <label for="cantidadAlfalfa">Cantidad de Alfalfa molida:</label>
            <input type="number" class="form-control" id="cantidadAlfalfa" name="cantidadAlfalfa" value="0">
        </div>
        <div class="form-group">
            <label for="cantidadUrea">Cantidad de Urea:</label>
            <input type="number" class="form-control" id="cantidadUrea" name="cantidadUrea" value="0">
        </div>
        <div class="form-group">
            <label for="cantidadElectro">Cantidad de Electrolitos:</label>
            <input type="number" class="form-control" id="cantidadElectro" name="cantidadElectro" value="0">
        </div>


        <button type="submit" class="btn btn-primary" name="comprarAlimentos">Comprar</button>
    </form>
</div>

<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>

</body>
</html>
