<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
  <title>Tabla de Alimentos</title>
</head>
<body>

<?php
include("includes/header.php");
?>

<div class="container mt-5">
  <h2>Tabla de alimentos</h2>
  
  <table class="table">
    <thead>
      <tr>
        <th>Nombre</th>
        <th>Cantidad</th>
        <th>Unidad de Medida</th>
      </tr>
    </thead>
    <tbody>
      <?php
        
        $servername = "db"; 
        $username = "root"; 
        $password = "clave"; 
        $dbname = "Ganaderia";

        $conn = new mysqli($servername, $username, $password, $dbname);

        if ($conn->connect_error) {
          die("Conexión fallida: " . $conn->connect_error);
        }

        $sql = "SELECT * FROM Alimentos";
        $result = $conn->query($sql);

        while ($row = $result->fetch_assoc()) {
          echo "<tr>";
          echo "<td>" . $row['nombre'] . "</td>";
          echo "<td>" . $row['cantidad'] . "</td>";
          echo "<td>" . $row['UnidadMedida'] . "</td>";
          echo "</tr>";
        }

        $conn->close();
      ?>
    </tbody>
  </table>
  <form action="comprar_alimento.php" method="post">
    <button type="submit" class="btn btn-primary">Agregar alimentos</button>
  </form>
</div>

<div class="container mt-5">
  <h2>Tabla de medicamentos</h2>
  
  <table class="table">
    <thead>
      <tr>
        <th>Nombre</th>
        <th>Cantidad</th>
        <th>Presentacion<th>
      </tr>
    </thead>
    <tbody>
      <?php
        
        $servername = "db"; 
        $username = "root"; 
        $password = "clave"; 
        $dbname = "Ganaderia";

        $conn = new mysqli($servername, $username, $password, $dbname);

        if ($conn->connect_error) {
          die("Conexión fallida: " . $conn->connect_error);
        }

        $sql = "SELECT * FROM Vacunas";
        $result = $conn->query($sql);

        while ($row = $result->fetch_assoc()) {
          echo "<tr>";
          echo "<td>" . $row['nombre'] . "</td>";
          echo "<td>" . $row['cantidad'] . "</td>";
          echo "<td>" . $row['Presentacion'] . "</td>";
          echo "</tr>";
        }

        $conn->close();
      ?>
    </tbody>
  </table>
  <form action="comprar_medicamento.php" method="post">
    <button type="submit" class="btn btn-primary">Agregar medicamentos</button>
  </form>
</div>

<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>

</body>
</html>