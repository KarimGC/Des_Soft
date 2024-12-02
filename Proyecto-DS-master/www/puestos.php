<?php
include("db.php");
include("includes/header.php");
?>

<body>
    <div class="container mt-5">
        <h1>Puestos</h1>
        <div class="table-responsive">
            <table class="table table-striped table-bordered">
                <thead class="thead-dark">
                    <tr>
                        <th>ID</th>
                        <th>Nombre del Puesto</th>
                    </tr>
                </thead>
                <tbody>
                    <?php
                    // Obtener los datos de la tabla Puestos
                    $query = "SELECT * FROM Puestos";
                    $result = mysqli_query($conn, $query);

                    // Verificar si se encontraron registros
                    if ($result && mysqli_num_rows($result) > 0) {
                        while ($row = mysqli_fetch_assoc($result)) {
                            echo "<tr>";
                            echo "<td>" . $row['Id_puesto'] . "</td>";
                            echo "<td>" . $row['Puesto'] . "</td>";
                            echo "</tr>";
                        }
                    } else {
                        echo "<tr><td colspan='2'>No se encontraron puestos.</td></tr>";
                    }
                    ?>
                </tbody>
            </table>
        </div>
    </div>
    <div class="text-center">
        <a href="agregar_p.php" class="btn btn-success">Añadir</a>
        <a href="eliminar_p.php" class="btn btn-danger">Eliminar</a>
    </div>
    <div class="text-center mt-3">
        <button class="btn btn-primary" onclick="history.back()">Regresar</button>
    </div>

</body>
</html>

<?php include("includes/footer.php") ?>
