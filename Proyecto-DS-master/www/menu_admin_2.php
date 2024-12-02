<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <title>INICIO</title>
    <style>
        .grid-container {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            grid-template-rows: repeat(2, 1fr);
            gap: 20px;
            padding: 20px;
        }
        .grid-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    text-align: center;
    border: 2px solid #6c757d;
    border-radius: 10px;
    padding: 20px;
    cursor: pointer;
    transition: transform 0.2s ease, box-shadow 0.2s ease;
    text-decoration: none; /* Eliminar subrayado */
        }
        .grid-item:hover {
            transform: scale(1.05);
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
        }
        .grid-item img {
            width: 120px;
            height: auto;
            margin-bottom: 10px;
        }
        .grid-item:hover .btn-name {
    color: black; /* Asegurarse de que el color permanezca negro al hacer hover */
}
        
        .grid-item .btn-name {
    font-size: 1.2rem;
    font-weight: bold;
    color: black; /* Cambiar color a negro */
}

        /* Colores específicos para cada elemento */
        .item-1 {
            background-color: #ffadad; /* Rojo claro */
        }
        .item-2 {
            background-color: #ffd6a5; /* Naranja claro */
        }
        .item-3 {
            background-color: #9bf6ff; /* Amarillo claro */
        }
        .item-4 {
            background-color: #cbcbcb; /* Verde claro */
        }
        .item-5 {
            background-color: #e0c079; /* Azul claro */
        }
        .item-6 {
            background-color: #caffbf; /* Azul oscuro */
        }
    </style>
</head>
<body>

<?php
include("includes/header.php");
?>

<div class="container mt-4">
    <div class="grid-container">
        <a href="compra.php" class="grid-item item-1">
            <img src="../images/ganadoic.png" alt="Ganado">
            <div class="btn-name">Compra</div>
        </a>
        <a href="menu_alimentar.php" class="grid-item item-2">
            <img src="../images/alimentoic.png" alt="Alimentar y Vacunar">
            <div class="btn-name">Alimentar</div>
        </a>
        <a href="curar.php" class="grid-item item-3">
            <img src="../images/almacenic.png" alt="Almacén">
            <div class="btn-name">Curar</div>
        </a>
        <a href="almacen_v2.php" class="grid-item item-4">
            <img src="../images/empleados.jpg" alt="Empleados">
            <div class="btn-name">Almacén</div>
        </a>
        <a href="animales.php" class="grid-item item-5">
            <img src="../images/cajaic.png" alt="Animales">
            <div class="btn-name">Animales</div>
        </a>
        <a href="vender.php" class="grid-item item-6">
            <img src="../images/ganaderoic.jpg" alt="Ganaderos">
            <div class="btn-name">Venta</div>
        </a>
    </div>
</div>
<?php
include("includes/footer.php");
?>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js" integrity="sha384-Y7xk1Bjc8F9zJxKtJcC5EPsbFVf0jcZ5z5Ff5r5l5uue6bF5f5u5z5z5z5z5z5z" crossorigin="anonymous"></script>
</body>
</html>
