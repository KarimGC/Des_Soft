
</body>
</html>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <title>Compra de Medicamentos</title>
</head>
<body>

<?php
include("includes/header.php");
?>

<div class="container mt-4">
    <h2>Compra de Medicamentos</h2>

    <?php
    if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["comprarVacuna"])) {
        $cantidadVacuna = $_POST["cantidadVacuna"];
        $cantidadDespa = $_POST["cantidadDespa"];
        $cantidadVitamns = $_POST["cantidadVitamns"];



        $servername = "db";
        $username = "root";
        $password = "clave";
        $dbname = "Ganaderia";

        $conn = new mysqli($servername, $username, $password, $dbname);

        if ($conn->connect_error) {
            die("Conexión fallida: " . $conn->connect_error);
        }

        $sql = "CALL ComprarVacuna($cantidadVacuna, $cantidadDespa, $cantidadVitamns)";

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
            <label for="cantidadVacuna">Cantidad de Vacunas:</label>
            <input type="number" class="form-control" id="cantidadVacuna" name="cantidadVacuna" value="0">
        </div>
        <div class="form-group">
            <label for="cantidadDespa">Cantidad de Desparasitante:</label>
            <input type="number" class="form-control" id="cantidadDespa" name="cantidadDespa" value="0">
        </div>
        <div class="form-group">
            <label for="cantidadVitamns">Cantidad de Vitaminas:</label>
            <input type="number" class="form-control" id="cantidadVitamns" name="cantidadVitamns" value="0">
        </div>
        
        <button type="submit" class="btn btn-primary" name="comprarVacuna">Comprar</button>
    </form>
</div>
<?
echo $sql;
?>
<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>

</body>
</html>
