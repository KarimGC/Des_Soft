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
<h2>
  Abasto 
</h2>


  <table class="table">
    <thead>
      <tr>
        <th>Nombre</th>
        <th>Cantidad</th>
        <th>Unidad de Medida</th>
        <th>Accion</th>
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

        $sql = "SELECT * FROM Dieta_A";
        $result = $conn->query($sql);

        while ($row = $result->fetch_assoc()) {
          echo "<tr>";
          echo "<td>" . $row['nombre'] . "</td>";
          echo "<td>" . $row['cantidad'] . "</td>";
          echo "<td>" . $row['UnidadMedida'] . "</td>";
          echo "<td>";
          echo "<a href='editar_dieta_A.php?id_alimento=" . $row['id_alimento'] . "' class='btn btn-primary btn-sm'>Editar</a>";
          echo "</td>";
          echo "</tr>";
        }

        $conn->close();
      ?>
    </tbody>
  </table>
</div>

<div class="container mt-5">
  <h2>Inicio</h2>
  
  <table class="table">
    <thead>
      <tr>
        <th>Nombre</th>
        <th>Cantidad</th>
        <th>Unidad de Medida</th>
        <th>Acciones</th>
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

        $sql = "SELECT * FROM Dieta_I";
        $result = $conn->query($sql);

        while ($row = $result->fetch_assoc()) {
          echo "<tr>";
          echo "<td>" . $row['nombre'] . "</td>";
          echo "<td>" . $row['cantidad'] . "</td>";
          echo "<td>" . $row['UnidadMedida'] . "</td>";
          echo "<td>";
          echo "<a href='editar_dieta_I.php?id_alimento=" . $row['id_alimento'] . "' class='btn btn-primary btn-sm'>Editar</a>";
          echo "</td>";
          echo "</tr>";
        }

        $conn->close();
      ?>
    </tbody>
  </table>
</div>

<div class="container mt-5">
  <h2>Desarrollo</h2>
  
  <table class="table">
    <thead>
      <tr>
        <th>Nombre</th>
        <th>Cantidad</th>
        <th>Unidad de Medida</th>
        <th>Acciones</th>
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

        $sql = "SELECT * FROM Dieta_D";
        $result = $conn->query($sql);

        while ($row = $result->fetch_assoc()) {
          echo "<tr>";
          echo "<td>" . $row['nombre'] . "</td>";
          echo "<td>" . $row['cantidad'] . "</td>";
          echo "<td>" . $row['UnidadMedida'] . "</td>";
          echo "<td>";
          echo "<a href='editar_dieta_D.php?id_alimento=" . $row['id_alimento'] . "' class='btn btn-primary btn-sm'>Editar</a>";
          echo "</td>";
          echo "</tr>";
        }

        $conn->close();
      ?>
    </tbody>
  </table>
</div>

<div class="container mt-5">
  <h2>Engorda</h2>
  
  <table class="table">
    <thead>
      <tr>
        <th>Nombre</th>
        <th>Cantidad</th>
        <th>Unidad de Medida</th>
        <th>Acciones</th>
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

        $sql = "SELECT * FROM Dieta_E";
        $result = $conn->query($sql);

        while ($row = $result->fetch_assoc()) {
          echo "<tr>";
          echo "<td>" . $row['nombre'] . "</td>";
          echo "<td>" . $row['cantidad'] . "</td>";
          echo "<td>" . $row['UnidadMedida'] . "</td>";
          echo "<td>";
          echo "<a href='editar_dieta_E.php?id_alimento=" . $row['id_alimento'] . "' class='btn btn-primary btn-sm'>Editar</a>";
          echo "</td>";
          echo "</tr>";
        }

        $conn->close();
      ?>
    </tbody>
  </table>
</div>

<div class="container mt-5">
  <h2>Finalizacion</h2>
  
  <table class="table">
    <thead>
      <tr>
        <th>Nombre</th>
        <th>Cantidad</th>
        <th>Unidad de Medida</th>
        <th>Acciones</th>
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

        $sql = "SELECT * FROM Dieta_F";
        $result = $conn->query($sql);

        while ($row = $result->fetch_assoc()) {
          echo "<tr>";
          echo "<td>" . $row['nombre'] . "</td>";
          echo "<td>" . $row['cantidad'] . "</td>";
          echo "<td>" . $row['UnidadMedida'] . "</td>";
          echo "<td>";
          echo "<a href='editar_dieta_F.php?id_alimento=" . $row['id_alimento'] . "' class='btn btn-primary btn-sm'>Editar</a>";
          echo "</td>";
          echo "</tr>";
        }

        $conn->close();
      ?>
    </tbody>
  </table>
</div>

<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>

</body>
</html>